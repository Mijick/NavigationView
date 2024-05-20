//
//  AnimationCompletionModifier.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func onAnimationCompleted<V: VectorArithmetic>(for value: V, perform action: @escaping () -> ()) -> some View { modifier(Modifier(observedValue: value, completion: action)) }
}

// MARK: - Implementation
fileprivate struct Modifier<V: VectorArithmetic>: AnimatableModifier {
    var animatableData: V { didSet { notifyCompletionIfFinished() }}
    private var targetValue: V
    private var completion: () -> ()


    init(observedValue: V, completion: @escaping () -> ()) {
        self.animatableData = observedValue
        self.targetValue = observedValue
        self.completion = completion
    }
    func body(content: Content) -> some View { content }
}

private extension Modifier {
    func notifyCompletionIfFinished() { if animatableData == targetValue {
        DispatchQueue.main.async { self.completion() }
    }}
}
