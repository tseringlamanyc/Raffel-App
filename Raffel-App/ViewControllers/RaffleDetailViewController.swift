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
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Participant>
    private var dataSource: DataSource!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Participant>
    
    var allParticipant = [Participant]()
    
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
        getAllParticipants()
        configureDataSource()
    }
    
    private func setUpCollectionView() {
        detailView.cv = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        detailView.cv.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.resueIdentifier)
        detailView.cv.backgroundColor = .systemBackground
        detailView.cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: detailView.cv, cellProvider: { [weak self] collectionView, indexPath, participant in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCell.resueIdentifier, for: indexPath) as? ParticipantCell else {
                fatalError()
            }
            
            cell.configureCell(participant: participant)
            return cell
        })
    }
    
    private func updateSnapShot(participant: [Participant]) {
        var snapshot = Snapshot()
        snapshot.appendSections([SectionKind.main])
        snapshot.appendItems(participant)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
