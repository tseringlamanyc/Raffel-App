//
//  ViewController.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import UIKit

class RaffleViewController: UIViewController {
    
    var allRaffels = [Raffle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        getAllRaffles()
    }
    
    func getAllRaffles() {
        RaffleAPIClient.getAllRaffle { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self?.allRaffels = data
                dump(data)
            }
        }
    }
}
