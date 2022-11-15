//
//  ScriptMessageHandler.swift
//  ios_blog
//
//  Created by William Kennedy on 06/11/2022.
//

import WebKit
import Contacts
import Turbo

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: ScriptMessageDelegate?

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage ) {
        guard
            let body = message.body as? [String: Any],
            let msg = body["name"] as? String
        else {
            print("No call")
            return
        }
        handleMessage(ScriptMessageHandler.MessageTypes(rawValue: msg) ?? ScriptMessageHandler.MessageTypes.none)
    }

    private func handleMessage(_ messageType: MessageTypes) -> String? {
        switch messageType {
        case .hello:
            print("hello world")
            return nil
        case .contacts:
            fetchContacts()
            return nil
        case .none:
            print("No message")
            return nil
        }
    }

    enum MessageTypes: String {
        case hello = "hello"
        case contacts = "contacts"
        case none = "none"
    }

    private func fetchContacts() {
        let store = CNContactStore()
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)

        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        for contact in contacts {
            delegate?.evaluate(contact.givenName)
            print(contact.givenName, contact.familyName)
        }
    }
}

protocol ScriptMessageDelegate: AnyObject {
    func evaluate(_ name: String)
}

