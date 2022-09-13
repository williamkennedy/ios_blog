//
//  HelloWorldCoordinator.swift
//  ios_blog
//
//  Created by William Kennedy on 07/09/2022.
//
import UIKit
import Foundation

class HelloWorldCoordinator: Coordinator {
    var rootViewController: UIViewController {
        helloWorldViewController.tabBarItem = tab()
        return helloWorldViewController
    }

    func tab() -> UITabBarItem {
        let item = UITabBarItem()
        item.title = "Hello"
        item.image = UIImage(systemName: "network")
        return item
    }

    private let helloWorldViewController = HelloWorldViewController()
}
