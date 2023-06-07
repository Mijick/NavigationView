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
    @State private var animatableOpacity: CGFloat = 1
    @State private var animatableOffset: CGFloat = 0
    @State private var animatableScale: CGFloat = 0
    private let config: NavigationConfig


    init(namespace: Namespace.ID, config: NavigationConfig) { self._temporaryViews = .init(initialValue: NavigationManager.shared.views); self.config = config; NavigationManager.setNamespace(namespace) }
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
            .scaleEffect(getScale(item))
            .background(getBackground(item))
            .transition(.identity)
            .opacity(getOpacity(item))
            .offset(getOffset(item))
            .compositingGroup()
    }
}

// MARK: - Getting Background
private extension NavigationStackView {
    func getBackground(_ item: AnyNavigatableView) -> Color { item.backgroundColour ?? config.backgroundColour }
}

// MARK: - Calculating Opacity
private extension NavigationStackView {
    func getOpacity(_ view: AnyNavigatableView) -> CGFloat {
        do {
            try checkOpacityPrerequisites(view)

            let isLastView = isLastView(view)
            let opacity = calculateOpacityValue(isLastView)
            let finalOpacity = calculateFinalOpacityValue(opacity)
            return finalOpacity
        } catch { return 0 }
    }
}
private extension NavigationStackView {
    func checkOpacityPrerequisites(_ view: AnyNavigatableView) throws {
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { throw "Opacity can concern the last or next to last element of the stack" }
    }
    func isLastView(_ view: AnyNavigatableView) -> Bool {
        let lastView = stack.transitionType == .push ? temporaryViews.last : stack.views.last
        return view == lastView
    }
    func calculateOpacityValue(_ isLastView: Bool) -> CGFloat {
        isLastView ? animatableOpacity : 1 - animatableOpacity
    }
    func calculateFinalOpacityValue(_ opacity: CGFloat) -> CGFloat {
        switch stack.transitionAnimation {
            case .no, .dissolve, .scale: return opacity
            case .horizontalSlide, .verticalSlide: return stack.transitionsBlocked ? 1 : opacity
        }
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
            let finalOffset = calculateFinalOffsetValue(view, offsetX, offsetY)
            return finalOffset
        } catch { return .zero }
    }
}
private extension NavigationStackView {
    func checkOffsetPrerequisites(_ view: AnyNavigatableView) throws {
        if !stack.transitionAnimation.isOne(of: .horizontalSlide, .verticalSlide) { throw "Offset cannot be set for a non-slide transition type" }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { throw "Offset can concern the last or next to last element of the stack" }
    }
    func calculateSlideOffsetValue(_ view: AnyNavigatableView) -> CGFloat {
        switch view == temporaryViews.last {
            case true: return stack.transitionType == .push ? 0 : maxOffsetValue
            case false: return stack.transitionType == .push ? -maxOffsetValue : 0
        }
    }
    func calculateXOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .horizontalSlide ? offset : 0 }
    func calculateYOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .verticalSlide ? offset : 0 }
    func calculateFinalOffsetValue(_ view: AnyNavigatableView, _ offsetX: CGFloat, _ offsetY: CGFloat) -> CGSize {
        switch view == temporaryViews.last {
            case true: return .init(width: offsetX, height: offsetY)
            case false: return .init(width: max(offsetX, -maxXOffsetValueWhileRemoving), height: 0)
        }
    }
}

// MARK: - Calculating Scale
private extension NavigationStackView {
    func getScale(_ view: AnyNavigatableView) -> CGFloat {
        do {
            try checkScalePrerequisites(view)

            let scaleValue = calculateScaleValue(view)
            let finalScale = calculateFinalScaleValue(scaleValue)
            return finalScale
        } catch { return 1 }
    }
}
private extension NavigationStackView {
    func checkScalePrerequisites(_ view: AnyNavigatableView) throws {
        if !stack.transitionAnimation.isOne(of: .scale) { throw "Scale cannot be set for a non-scale transition type" }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { throw "Scale can concern the last or next to last element of the stack" }
    }
    func calculateScaleValue(_ view: AnyNavigatableView) -> CGFloat {
        switch view == temporaryViews.last {
            case true: return stack.transitionType == .push ? 1 - scaleFactor + animatableScale : 1 - animatableScale
            case false: return stack.transitionType == .push ? 1 + animatableScale : 1 + scaleFactor - animatableScale
        }
    }
    func calculateFinalScaleValue(_ scaleValue: CGFloat) -> CGFloat { stack.transitionsBlocked ? scaleValue : 1 }
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
        switch stack.transitionType {
            case .push: temporaryViews = views
            case .pop: temporaryViews = views + [temporaryViews.last].compactMap { $0 }
        }
    }
    func resetOffsetAndOpacity() {
        let animatableOffsetFactor = stack.transitionType == .push ? 1.0 : -1.0

        animatableOffset = maxOffsetValue * animatableOffsetFactor
        animatableOpacity = 0
        animatableScale = 0
    }
    func animateOffsetAndOpacityChange() { withAnimation(animation) {
        animatableOffset = 0
        animatableOpacity = 1
        animatableScale = scaleFactor
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
    var scaleFactor: CGFloat { 0.33 }
    var maxXOffsetValueWhileRemoving: CGFloat { UIScreen.width * 0.2 }
    var maxOffsetValue: CGFloat { [.horizontalSlide: UIScreen.width, .verticalSlide: UIScreen.height][stack.transitionAnimation] ?? 0 }
    var animation: Animation { stack.transitionAnimation == .no ? .easeInOut(duration: 0) : .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4) }
}
