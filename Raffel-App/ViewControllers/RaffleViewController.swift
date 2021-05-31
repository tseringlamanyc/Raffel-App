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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addARaffle))
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
    
    @objc
    private func addARaffle() {
        let ac = UIAlertController(title: "Enter a raffle", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Raffle Name"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Secret Token"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            
            //MARK:- COMBINE 
            guard let raffleName = ac?.textFields?[0].text, !raffleName.isEmpty, let secretToken = ac?.textFields?[1].text, !secretToken.isEmpty else {
                self?.showAlert(title: "Fail", message: "Please enter all the fields")
                return
            }
            
            self?.postARaffle(name: raffleName, token: secretToken)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true) {
            
        }
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
     }
    
    private func postARaffle(name: String, token: String) {
        let createdRaffle = Raffle(id: nil, name: name, created_at: nil, raffled_at: nil, winner_id: nil, secret_token: token)
        RaffleAPIClient.postARaffle(createdRaffle: createdRaffle) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("error adding raffle: \(error)")
                case .success(_):
                    self?.showAlert(title: "Success", message: "Raffle Added")
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
        dataSource = DataSource(collectionView: homeView.cv, cellProvider: { [weak self] collectionView, indexPath, raffle in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaffleCell.reuseIdentifier, for: indexPath) as? RaffleCell else {
                fatalError()
            }
            
            cell.configureCell(raffle: raffle)
            return cell
        })
    }
    
    private func updateSnapShot(raffles: [Raffle]) {
        var snapshot = Snapshot()
        snapshot.appendSections([SectionKind.main])
        snapshot.appendItems(raffles)
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
