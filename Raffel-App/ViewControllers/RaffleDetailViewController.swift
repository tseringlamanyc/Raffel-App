//
//  RaffleDetailViewController.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

class RaffleDetailViewController: UIViewController {
    
    private var raffle: Raffle
    
    private var detailView = RaffleDetailView()
    
    private lazy var emptyView = EmptyView(title: "No Participants", message: "No one has registered for this raffle yet")
    
    override func loadView() {
        view = detailView 
    }
    
    enum SectionKind: Int, CaseIterable {
        case main
        case secondary
        
        var title: String {
            switch self {
            case .main:
                return "Participants"
            case .secondary:
                return "Pick a winner"
            }
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Participant>
    private var dataSource: DataSource!
        
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Participant>
    typealias Snapshot2 = NSDiffableDataSourceSnapshot<SectionKind, String>
    
    var allParticipant = [Participant]() {
        didSet {
            if allParticipant.isEmpty {
                detailView.cv.backgroundView = emptyView
                emptyView.addButton.addTarget(self, action: #selector(addAParticipantButtonTapped), for: .touchUpInside)
                navigationItem.rightBarButtonItem = nil
            } else {
                detailView.cv.backgroundView = nil
            }
        }
    }
    
    init(raffle: Raffle) {
        self.raffle = raffle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        getAllParticipants()
        setupParticipantCV()
        configureDataSource()
    }
    
    private func setupParticipantCV() {
        detailView.cv = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        detailView.cv.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.resueIdentifier)
        detailView.cv.backgroundColor = .systemBackground
        detailView.cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailView.cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        detailView.cv.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier)
        view.addSubview(detailView.cv)
    }
    
    
    private func configureNavBar() {
        navigationItem.title = raffle.name?.uppercased()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addAParticipantButtonTapped))
    }
    
    
    private func getAllParticipants() {
        RaffleAPIClient.getAllParticipants(id: raffle.id!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let participants):
                    self?.updateSnapShot(participant: participants)
                    self?.allParticipant = participants
                }
            }
        }
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = SectionKind(rawValue: sectionIndex) else {
                return nil
            }
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            
            //2) Create and configure group
            let groupHeight = NSCollectionLayoutDimension.absolute(200)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            //3) Configure section
            let section = NSCollectionLayoutSection(group: group)
            
            //4) Configure layout
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)) // .estimate = changes based on content
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                        
            section.boundarySupplementaryItems = [header, footer]
            
            return section
        }
        
        return layout
    }
        
    private func configureDataSource() {
        dataSource = DataSource(collectionView: detailView.cv, cellProvider: { [weak self] collectionView, indexPath, participant in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCell.resueIdentifier, for: indexPath) as? ParticipantCell else {
                fatalError()
            }
            
            cell.configureCell(participant: participant, raffle: self!.raffle)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = self?.detailView.cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                    fatalError()
                }
                
                headerView.textLabel.text = "\(SectionKind.main.title)".capitalized
                headerView.layer.cornerRadius = 8
                headerView.layer.borderWidth = 2
                headerView.layer.borderColor = UIColor.systemGray.cgColor
                return headerView
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = self?.detailView.cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                    fatalError()
                }
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self?.pickAWinnerTapped(_:)))
                footerView.addGestureRecognizer(gesture)
                
                footerView.textLabel.text = "\(SectionKind.secondary.title)".capitalized
                footerView.layer.cornerRadius = 8
                footerView.layer.borderWidth = 2
                footerView.layer.borderColor = UIColor.systemGray.cgColor
                return footerView
            default:
                break
            }
            return nil
        }
    }
    
    @objc
    func pickAWinnerTapped(_ sender:UITapGestureRecognizer) {
        
        if let hasAWinner = raffle.winner_id {
            self.showAlert(title: "Sorry", message: "This raffle already has a winner: \(hasAWinner)")
        } else {
            let ac = UIAlertController(title: "Secret Token", message: nil, preferredStyle: .alert)
            ac.addTextField { (textField) in
                textField.placeholder = "Enter the secret token *"
            }
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
                guard let secretToken = ac?.textFields?[0].text, !secretToken.isEmpty else {
                    self?.showAlert(title: "Fail", message: "Please enter a valid token")
                    return
                }
                
                self?.putAWinner(token: secretToken, raffleId: (self?.raffle.id!)!)
            }
            
            ac.addAction(submitAction)
            present(ac, animated: true)
        }
    }
    
    private func putAWinner(token: String, raffleId: Int) {
        RaffleAPIClient.requestAWinner(token: token, raffleId: raffle.id!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self?.showAlert(title: "Winner", message: "The winner is \(self?.raffle.winner_id?.description ?? "")")
                }
            }
        }
    }
    
    @objc
    private func addAParticipantButtonTapped() {
        let ac = UIAlertController(title: "Enter participants information below", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Firstname*"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Lastname*"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Enter email*"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Phone (optional)"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            
            let phone = ac?.textFields?[3].text
            
            //MARK:- COMBINE
            guard let firstName = ac?.textFields?[0].text, !firstName.isEmpty, let lastName = ac?.textFields?[1].text, !lastName.isEmpty, let email = ac?.textFields?[2].text, !email.isEmpty else {
                self?.showAlert(title: "Fail", message: "Please enter all the fields")
                return
            }
            
            self?.addAParticipant(firstName: firstName, lastName: lastName, email: email, phone: phone)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    private func addAParticipant(firstName: String, lastName: String, email: String, phone: String?) {
        let aParticipant = Participant(id: nil, raffle_id: raffle.id!, firstname: firstName, lastname: lastName, email: email, phone: phone, registered_at: nil)
        RaffleAPIClient.postAParticipant(id: raffle.id!, participant: aParticipant) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self?.showAlert(title: "Success", message: "\(aParticipant.firstname) \(aParticipant.lastname) was added to this raffle")
                }
            }
        }
    }
    
    
    private func updateSnapShot(participant: [Participant]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(participant, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
