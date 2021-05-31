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
    
    override func loadView() {
        view = detailView 
    }
    
    enum SectionKind: Int, CaseIterable {
        case main
        
        var title: String {
            switch self {
            case .main:
                return "Participants"
            }
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Participant>
    private var dataSource: DataSource!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Participant>
    
    var allParticipant = [Participant]() {
        didSet {
            
            if allParticipant.isEmpty {
                detailView.cv.backgroundView = EmptyView(title: "No Participants", message: "No one has registered for this raffle yet")
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
        setUpCollectionView()
        configureDataSource()
        getAllParticipants()
    }
    
    private func setUpCollectionView() {
        detailView.cv = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        detailView.cv.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.resueIdentifier)
        detailView.cv.backgroundColor = .systemBackground
        detailView.cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailView.cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        view.addSubview(detailView.cv)
    }
    
    private func configureNavBar() {
        navigationItem.title = raffle.name?.uppercased()
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
        
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = SectionKind(rawValue: sectionIndex) else {
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            
            //2) Create and configure group
            let groupHeight = NSCollectionLayoutDimension.absolute(200)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            //3) Configure section
            let section = NSCollectionLayoutSection(group: group)
            
            //4) Configure layout
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)) // .estimate = changes based on content
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [header]
            
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
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let headerView = self.detailView.cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            
            headerView.textLabel.text = "\(SectionKind.allCases[indexPath.section].title)".capitalized
            headerView.layer.cornerRadius = 8
            headerView.layer.borderWidth = 2
            headerView.layer.borderColor = UIColor.systemGray.cgColor
            return headerView
        }
    }
    
    private func updateSnapShot(participant: [Participant]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(participant, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
}
