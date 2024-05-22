//
//  Public+NavigatableView.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialising
public extension NavigatableView {
    func implementNavigationView(config: NavigationGlobalConfig = .init()) -> some View { GeometryReader { reader in
        NavigationView(config: config)
            .onAppear { ScreenManager.update(reader); NavigationManager.setRoot(self) }
            .onChange(of: reader.size) { _ in ScreenManager.update(reader) }
            .onChange(of: reader.safeAreaInsets) { _ in ScreenManager.update(reader) }
    }}
}

// MARK: - Customising
public extension NavigatableView {
    func configure(view: NavigationConfig) -> NavigationConfig { view }
}

// MARK: - Presenting Views
public extension NavigatableView {
    /// Pushes a new view. Stacks previous one
    @discardableResult func push(with animation: TransitionAnimation) -> some NavigatableView { NavigationManager.performOperation(.insert(self, animation)); return self }

    /// Sets the selected view as the new navigation root
    @discardableResult func setAsNewRoot() -> some NavigatableView { NavigationManager.replaceRoot(self); return self }

    /// Supplies an observable object to a view’s hierarchy
    @discardableResult func environmentObject(_ object: some ObservableObject) -> any NavigatableView { AnyNavigatableView(self, object) }
}
