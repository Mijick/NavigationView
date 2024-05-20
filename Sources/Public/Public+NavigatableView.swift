//
//  Public+NavigatableView.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialising
public extension NavigatableView {
    func implementNavigationView(config: NavigationGlobalConfig? = nil) -> some View { GeometryReader { reader in
        NavigationView(rootView: self, config: config)
            .onAppear { ScreenManager.update(reader) }
            .onChange(of: reader.size) { _ in ScreenManager.update(reader) }
            .onChange(of: reader.safeAreaInsets) { _ in ScreenManager.update(reader) }
    }}
}

// MARK: - Customising
public extension NavigatableView {
    func configure(view: NavigationConfig) -> NavigationConfig { view }
}

// MARK: - Pushing Views To Stack
public extension NavigatableView {
    /// Pushes a new view. Stacks previous one
    func push(with animation: TransitionAnimation) { NavigationManager.push(self, animation) }
}
