//
//  TurboCoordinator.swift
//  ios_blog
//
//  Created by William Kennedy on 08/09/2022.
//

import Turbo
import UIKit


class TurboCoordinator: Coordinator {
    var rootViewController: UIViewController {
        navigationController.tabBarItem = tab()
        return navigationController

    }
    var resetApp: (() -> Void)?

    func tab() -> UITabBarItem {
        let item = UITabBarItem()
        item.title = "Turbo"
        item.image = UIImage(systemName: "tram")
        return item
    }

    override func start() {
        visit(url: URL(string: "http://localhost:3000/")!)
    }

    // MARK: Private
    private let navigationController = UINavigationController()
    private lazy var session = makeSession()
    private lazy var modalSession = makeSession()

    private func makeSession() -> Session {
        let session = Session()
        session.delegate = self
        return session
    }

    private func visit(url: URL, action: VisitAction = .advance, properties: PathProperties = [:]) {
        let viewController = makeViewController(for: url, from: properties)

        let action: VisitAction = url ==
          session.topmostVisitable?.visitableURL ? .replace : action
        navigate(to: viewController, via: action)
        visit(viewController)
    }

    private func makeViewController(for url: URL, from properties: PathProperties) -> UIViewController {
        return VisitableViewController(url: url)
    }

    private func navigate(to viewController: UIViewController, via action: VisitAction) {
         if action == .advance {
            navigationController.pushViewController(viewController, animated: true)
        } else if action == .replace {
            navigationController.dismiss(animated: true)
            navigationController.viewControllers = Array(navigationController.viewControllers.dropLast()) + [viewController]
        } else {
            navigationController.viewControllers = Array(navigationController.viewControllers.dropLast()) + [viewController]
        }
    }

    private func visit(_ viewController: UIViewController) {
        guard let visitable = viewController as? Visitable else { return }

        session.visit(visitable)
    }
}


extension TurboCoordinator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
          visit(url: proposal.url)
      }

      func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
          print("didFailRequestForVisitable: \(error)")
      }

      func sessionWebViewProcessDidTerminate(_ session: Session) {
          session.reload()
      }
}
