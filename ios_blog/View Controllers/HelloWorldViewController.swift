//
//  HelloWorldViewController.swift
//  ios_blog
//
//  Created by William Kennedy on 07/09/2022.
//

import UIKit
import SwiftUI

class HelloWorldViewController: UIHostingController<HelloWorldView> {
    init() {
        super.init(rootView: HelloWorldView())
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HelloWorldView: View {
    var body: some View {
        Text("hello world")
    }
}

struct HelloWorld_Previews: PreviewProvider {
    static var previews: some View {
        HelloWorldView()
    }
}
