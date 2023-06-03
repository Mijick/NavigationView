//
//  NavigationStackView.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct NavigationStackView: View {
    @ObservedObject private var stack: NavigationManager = .shared
    @State private var temporaryViews: [AnyNavigatableView] = []
    @State private var animatableOffset: CGFloat = 0
    @State private var animatableOpacity: CGFloat = 1


    init(namespace: Namespace.ID) { self._temporaryViews = .init(initialValue: NavigationManager.shared.views); NavigationManager.setNamespace(namespace) }
    var body: some View {
        ZStack(content: createStack)
            .onChange(of: stack.views, perform: onViewsChanged)
            .onAnimationCompleted(for: animatableOpacity, perform: onAnimationCompleted)
    }
}

private extension NavigationStackView {
    func createStack() -> some View {
        ForEach(temporaryViews, id: \.id, content: createItem)
    }
}

private extension NavigationStackView {
    func createItem(_ item: AnyNavigatableView) -> some View {
        item
            .transition(.identity)
            .opacity(getOpacity(item))
            .offset(getOffset(item))
            .compositingGroup()
    }
}

// MARK: - Calculating Opacity
private extension NavigationStackView {
    func getOpacity(_ view: AnyNavigatableView) -> CGFloat {
        do {
            try checkOpacityPrerequisites(view)

            let isLastView = isLastView(view)
            let opacity = calculateOpacityValue(isLastView)
            return opacity
        } catch { return 0 }
    }
}
private extension NavigationStackView {
    func checkOpacityPrerequisites(_ view: AnyNavigatableView) throws {
        if !view.isOne(of: stack.views.last, temporaryViews.last, temporaryViews.isNextToLast) { throw "Opacity can concern the last or next to last element of the stack" }
    }
    func isLastView(_ view: AnyNavigatableView) -> Bool {
        let lastView = stack.transitionType == .push ? temporaryViews.last : stack.views.last
        return view == lastView
    }
    func calculateOpacityValue(_ isLastView: Bool) -> CGFloat {
        isLastView ? animatableOpacity : 1 - animatableOpacity
    }
}

// MARK: - Calculating Offset
private extension NavigationStackView {
    func getOffset(_ view: AnyNavigatableView) -> CGSize {
        do {
            try checkOffsetPrerequisites(view)

            let offsetSlideValue = calculateSlideOffsetValue(view)
            let offset = animatableOffset + offsetSlideValue
            let offsetX = calculateXOffsetValue(offset), offsetY = calculateYOffsetValue(offset)
            return .init(width: offsetX, height: offsetY)
        } catch { return .zero }
    }
}
private extension NavigationStackView {
    func checkOffsetPrerequisites(_ view: AnyNavigatableView) throws {
        if !stack.transitionAnimation.isOne(of: .horizontalSlide, .verticalSlide) { throw "Offset cannot be set for a non-slide type" }
        if !view.isOne(of: stack.views.last, temporaryViews.last, temporaryViews.isNextToLast) { throw "Offset can concern the last or next to last element of the stack" }
    }
    func calculateSlideOffsetValue(_ view: AnyNavigatableView) -> CGFloat {
        switch view == temporaryViews.last {
            case true: return stack.transitionType == .push ? 0 : maxOffsetValue
            case false: return stack.transitionType == .push ? -maxOffsetValue : 0
        }
    }
    func calculateXOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .horizontalSlide ? offset : 0 }
    func calculateYOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .verticalSlide ? offset : 0 }
}

// MARK: - On Transition Begin
private extension NavigationStackView {
    func onViewsChanged(_ views: [AnyNavigatableView]) {
        blockTransitions()
        updateTemporaryViews(views)
        resetOffsetAndOpacity()
        animateOffsetAndOpacityChange()
    }
}
private extension NavigationStackView {
    func blockTransitions() {
        NavigationManager.blockTransitions(true)
    }
    func updateTemporaryViews(_ views: [AnyNavigatableView]) {
        if stack.transitionType == .push { temporaryViews = views }
    }
    func resetOffsetAndOpacity() {
        let animatableOffsetFactor = stack.transitionType == .push ? 1.0 : -1.0

        animatableOffset = maxOffsetValue * animatableOffsetFactor
        animatableOpacity = 0
    }
    func animateOffsetAndOpacityChange() { withAnimation(animation) {
        animatableOffset = 0
        animatableOpacity = 1
    }}
}

// MARK: - On Transition End
private extension NavigationStackView {
    func onAnimationCompleted() {
        resetViewOnAnimationCompleted()
        unblockTransitions()
    }
}
private extension NavigationStackView {
    func unblockTransitions() {
        NavigationManager.blockTransitions(false)
    }
    func resetViewOnAnimationCompleted() {
        if stack.transitionType == .pop {
            temporaryViews = stack.views
            animatableOffset = -maxOffsetValue
        }
    }
}

// MARK: - Configurables
private extension NavigationStackView {
    var maxOffsetValue: CGFloat { [.horizontalSlide: UIScreen.width, .verticalSlide: UIScreen.height][stack.transitionAnimation] ?? 0 }
    var animation: Animation { stack.transitionAnimation == .no ? .easeInOut(duration: 0) : .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4) }
}
