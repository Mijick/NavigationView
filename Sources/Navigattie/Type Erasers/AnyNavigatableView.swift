//
//  AnyNavigatableView.swift of Navigattie
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
    let backgroundColour: Color?
    private let _body: AnyView


    init(_ view: some NavigatableView, _ animation: TransitionAnimation) {
        self.id = view.id
        self.animation = animation
        self.backgroundColour = view.backgroundColour
        self._body = AnyView(view)
    }
}
extension AnyNavigatableView {
    static func == (lhs: AnyNavigatableView, rhs: AnyNavigatableView) -> Bool { lhs.id == rhs.id }
}
extension AnyNavigatableView {
    var body: some View { _body }
}
