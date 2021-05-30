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
    
    private lazy var winnerViewController: SelectWinnerViewController = {
       let vc = SelectWinnerViewController()
        vc.tabBarItem = UITabBarItem(title: "Pick a Winner", image: UIImage(systemName: "scribble"), tag: 1)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: homeViewController), winnerViewController]
    }
}
