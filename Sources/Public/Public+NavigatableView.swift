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
    func implementNavigationView(config: NavigationGlobalConfig? = nil) -> some View { NavigationView(rootView: self, config: config) }
}

// MARK: - Customising
public extension NavigatableView {
    func configure(view: NavigationConfig) -> NavigationConfig { view }
}

// MARK: - Pushing And Removing Views From Stack
public extension NavigatableView {
    /// Pushes a new view. Stacks previous one
    func push(with animation: TransitionAnimation) { NavigationManager.push(self, animation) }
}
public extension View {
    /// Removes the presented view from the stack
    func pop() { NavigationManager.pop() }

    /// Removes all views up to the selected view in the stack. The view from the argument will be the new active view
    func pop<N: NavigatableView>(to view: N.Type) { NavigationManager.pop(to: view) }

    /// Removes all views from the stack. Root view will be the new active view
    func popToRoot() { NavigationManager.popToRoot() }
}
