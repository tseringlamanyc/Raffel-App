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
    
    var allRaffels = [Raffle]() {
        didSet {
            homeView.cv.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpCollectionView()
        getAllRaffles()
        //configureDataSource()
        dump(allRaffels.count)
    }
    
    private func setUpCollectionView() {
         homeView.cv.register(RaffleCell.self, forCellWithReuseIdentifier: RaffleCell.reuseIdentifier)
         homeView.cv.dataSource = self
         homeView.cv.delegate = self
     }
    
    func getAllRaffles() {
        RaffleAPIClient.getAllRaffle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self?.allRaffels = data
                    //self?.updateSnapShot(raffles: data)
                }
            }
        }
    }
    
//    private func updateSnapShot(raffles: [Raffle]) {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(raffles, toSection: .main)
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//
//    private func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout{ (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//
//
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            let itemSpacing: CGFloat = 5
//            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35))
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
//
//            let section = NSCollectionLayoutSection(group: group)
//            return section
//        }
//
//        return layout
//    }
//
//    private func configureDataSource() {
//        dataSource = DataSource(collectionView: homeView.cv, cellProvider: { collectionView, indexPath, raffle in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaffleCell.reuseIdentifier, for: indexPath) as? RaffleCell else {
//                fatalError()
//            }
//            cell.backgroundColor = .systemRed
//            cell.raffleName.text = raffle.name
//            return cell
//        })
//    }
}

extension RaffleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRaffels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaffleCell.reuseIdentifier, for: indexPath) as?
                RaffleCell else {
            fatalError()
        }
        
        let aRaffle = allRaffels[indexPath.row]
        
        if let winnerID = aRaffle.created_at {
            cell.raffleName.text = winnerID.toDate()
        } else {
            cell.raffleName.text = "No winner yet"
        }
        cell.backgroundColor = .systemBackground
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }
}

extension RaffleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interspacing = CGFloat(5)
        let maxwidth = UIScreen.main.bounds.size.width
        let maxheight = UIScreen.main.bounds.size.height / 4
        let numOfItems = CGFloat(2)
        let totalSpacing = CGFloat(numOfItems * interspacing)
        let itemWidth = CGFloat((maxwidth - totalSpacing) / (numOfItems) )
        return CGSize(width: itemWidth, height: maxheight)
    }
    
}
