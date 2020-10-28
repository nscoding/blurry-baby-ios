//
//  LazyView.swift
//  Mel
//
//  Created by kremyzas on 10/27/20.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
