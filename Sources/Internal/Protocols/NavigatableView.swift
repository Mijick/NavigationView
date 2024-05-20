//
//  NavigatableView.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol NavigatableView: View {
    func configure(view: NavigationConfig) -> NavigationConfig
}

// MARK: - Internals
extension NavigatableView {
    var id: String { .init(describing: Self.self) }
}
