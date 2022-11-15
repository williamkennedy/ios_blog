//
//  TurboCoordinator.swift
//  ios_blog
//
//  Created by William Kennedy on 08/09/2022.
//

import Turbo
import UIKit
import SafariServices
import WebKit


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
        visit(url: URL(string: "http://ios-blog.test/")!)
    }

    // MARK: Private
    private let navigationController = UINavigationController()
    private lazy var session = makeSession()
    private lazy var modalSession = makeSession()

    private func makeSession() -> Session {
        let configuration = WKWebViewConfiguration()
        let scriptMessageHandler = ScriptMessageHandler()
        scriptMessageHandler.delegate = self
        configuration.userContentController.add(scriptMessageHandler, name: "nativeApp")
        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        session.pathConfiguration = PathConfiguration(sources: [
                   .file(Bundle.main.url(forResource: "PathConfiguration", withExtension: "json")!),
               ])
        return session
    }

    private func visit(url: URL, action: VisitAction = .advance, properties: PathProperties = [:]) {
        let viewController = makeViewController(for: url, from: properties)
        let modal = properties["presentation"] as? String == "modal"
        let action: VisitAction = url ==
          session.topmostVisitable?.visitableURL ? .replace : action
        navigate(to: viewController, via: action, asModal: modal)
        visit(viewController, as: modal)
    }

    private func makeViewController(for url: URL, from properties: PathProperties) -> UIViewController {
        return VisitableViewController(url: url)
    }

    private func navigate(to viewController: UIViewController, via action: VisitAction, asModal modal: Bool) {
        if modal {
            navigationController.present(viewController, animated: true)
        } else if action == .advance {
            navigationController.pushViewController(viewController, animated: true)
        } else if action == .replace {
            navigationController.dismiss(animated: true)
            navigationController.viewControllers = Array(navigationController.viewControllers.dropLast()) + [viewController]
        } else {
            navigationController.viewControllers = Array(navigationController.viewControllers.dropLast()) + [viewController]
        }
    }

    private func visit(_ viewController: UIViewController, as modal: Bool) {
        guard let visitable = viewController as? Visitable else { return }
        let session = modal ? modalSession : self.session
        session.visit(visitable)
    }
}


extension TurboCoordinator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url, action: proposal.options.action, properties: proposal.properties)
      }

      func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
          print("didFailRequestForVisitable: \(error)")
      }

      func sessionWebViewProcessDidTerminate(_ session: Session) {
          session.reload()
      }
}

extension TurboCoordinator: ScriptMessageDelegate {
    // Existing functions.
    func evaluate(_ name: String) {
        session.webView.evaluateJavaScript("Bridge.importingContacts('\(name)')")
    }
}


