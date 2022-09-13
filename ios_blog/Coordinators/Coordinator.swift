//
//  Coordinator.swift
//  ios_blog
//
//  Created by William Kennedy on 07/09/2022.
//

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {

    var didFinish: ((Coordinator) -> Void)?


    var childCoordinators: [Coordinator] = []

    // MARK: - Methods

    func start() {}

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}


    func pushCoordinator(_ coordinator: Coordinator) {
        // Install Handler
        coordinator.didFinish = { [weak self] (coordinator) in
            self?.popCoordinator(coordinator)
        }

        // Start Coordinator
        coordinator.start()

        // Append to Child Coordinators
        childCoordinators.append(coordinator)
    }

    func popCoordinator(_ coordinator: Coordinator) {
        // Remove Coordinator From Child Coordinators
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }

}
