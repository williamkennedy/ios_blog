//
//  ApplicationCoordinator.swift
//  ios_blog
//
//  Created by William Kennedy on 07/09/2022.
//

import UIKit

class ApplicationCoordinator: Coordinator {

    var rootViewController: UIViewController {
        return tabBarController
    }

    private let tabBarController = UITabBarController()

    override init() {
        super.init()

        let helloWorldCoordinator = HelloWorldCoordinator()
        let turboCoodinator = TurboCoordinator()

        tabBarController.viewControllers = [
            helloWorldCoordinator.rootViewController,
            turboCoodinator.rootViewController
        ]

        childCoordinators.append(helloWorldCoordinator)
        childCoordinators.append(turboCoodinator)

    }

    override func start() {
        childCoordinators.forEach { (childCoordinator) in
            childCoordinator.start()
        }
    }

}
