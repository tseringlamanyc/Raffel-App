//
//  ViewController.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import UIKit

class RaffleViewController: UIViewController {
    
    
    private var homeView = AllRaffleView()
    
    override func loadView() {
        view = homeView
    }
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Raffle>
    private var dataSource: DataSource!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Raffle>
    
    var allRaffels = [Raffle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpCollectionView()
        getAllRaffles()
        configureDataSource()
        configureNavBar()
    }
    
    private func setUpCollectionView() {
        homeView.cv = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        homeView.cv.register(RaffleCell.self, forCellWithReuseIdentifier: RaffleCell.reuseIdentifier)
        homeView.cv.delegate = self
        homeView.cv.backgroundColor = .systemBackground
        homeView.cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(homeView.cv)
    }
    
    private func configureNavBar() {
        navigationItem.title = "ALL RAFFLES"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
    }
    
    func getAllRaffles() {
        RaffleAPIClient.getAllRaffle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self?.updateSnapShot(raffles: data)
                    self?.allRaffels = data
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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1) 
        
        //3) Configure section
        let section = NSCollectionLayoutSection(group: group)
        
        //4) Configure layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: homeView.cv, cellProvider: { collectionView, indexPath, raffle in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaffleCell.reuseIdentifier, for: indexPath) as? RaffleCell else {
                fatalError()
            }
            
            cell.layer.cornerRadius = 8.0
            
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 2
            
            if let hasWinner = raffle.winner_id {
                cell.layer.borderColor = UIColor.red.cgColor
                cell.layer.borderWidth = 2
                cell.winnerLabel.text = "Has a winner: \(hasWinner)"
            } else {
                cell.winnerLabel.text = "No winner yet for: \(raffle.id ?? 0)"
            }
            
            cell.raffleName.text = "\(raffle.name ?? "") \(raffle.id ?? 0)"
            return cell
        })
    }
    
    private func updateSnapShot(raffles: [Raffle]) {
        var snapshot = Snapshot()
        snapshot.appendSections([SectionKind.main])
        snapshot.appendItems(raffles)
        snapshot.reloadItems(raffles)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension RaffleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let raffle = dataSource.itemIdentifier(for: indexPath) else {return}
        
        let detailRaffleVC = RaffleDetailViewController(raffle: raffle)
        navigationController?.pushViewController(detailRaffleVC, animated: true)
    }
}
