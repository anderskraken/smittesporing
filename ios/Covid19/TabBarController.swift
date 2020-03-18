//
//  TabBarController.swift
//  Covid19
//
//  Created by Per Thomas Haga on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import SnapKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.isTranslucent = false
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .darkGray
        tabBar.layer.borderColor = .stroke
        tabBar.layer.borderWidth = 1

        let locationViewController = LocationTrackingViewController()
        let symptomsViewController = SymptomsViewController()
        let shareViewController = ShareViewController()

        locationViewController.tabBarItem = UITabBarItem(title: "Bevegelser", image: UIImage(named: "location"), tag: 0)
        symptomsViewController.tabBarItem = UITabBarItem(title: "Symptomer", image: UIImage(named: "person"), tag: 1)
        shareViewController.tabBarItem = UITabBarItem(title: "Del data", image: UIImage(named: "share"), tag: 2)
        
        viewControllers = [locationViewController, symptomsViewController, shareViewController]
        
        viewControllers?.forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 2, right: 0)
        }
        
        
    }
}

