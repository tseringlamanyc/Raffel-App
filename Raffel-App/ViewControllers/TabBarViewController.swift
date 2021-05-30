//
//  TableViewController.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

class TableViewController: UITabBarController {
    
    private lazy var homeViewController: RaffleViewController = {
       let vc = RaffleViewController()
        vc.tabBarItem = UITabBarItem(title: "All Raffles", image: UIImage(systemName: "person"), tag: 0)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: homeViewController)]
    }
}
