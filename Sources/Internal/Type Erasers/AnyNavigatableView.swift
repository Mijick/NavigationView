//
//  AnyNavigatableView.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyNavigatableView: NavigatableView, Equatable {
    let id: String
    let animation: TransitionAnimation
    private let _body: AnyView
    private let _configure: (NavigationConfig) -> (NavigationConfig)


    init(_ view: some NavigatableView, _ animation: TransitionAnimation) {
        self.id = view.id
        self.animation = animation
        self._body = AnyView(view)
        self._configure = view.configure
    }
    init(_ view: some NavigatableView, _ environmentObject: some ObservableObject) {
        self.id = view.id
        self.animation = .no
        self._body = AnyView(view.environmentObject(environmentObject))
        self._configure = view.configure
    }
}
extension AnyNavigatableView {
    static func == (lhs: AnyNavigatableView, rhs: AnyNavigatableView) -> Bool { lhs.id == rhs.id }
}
extension AnyNavigatableView {
    var body: some View { _body }
    func configure(view: NavigationConfig) -> NavigationConfig { _configure(view) }
}
