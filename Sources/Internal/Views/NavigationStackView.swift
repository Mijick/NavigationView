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
    @State private var animatableRotation: CGFloat = 0
    @State private var animatableScale: CGFloat = 0
    private let config: NavigationGlobalConfig


    init(config: NavigationGlobalConfig) { self._temporaryViews = .init(initialValue: NavigationManager.shared.views); self.config = config }
    var body: some View {
        ZStack(content: createStack)
            .ignoresSafeArea(.container)
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
            .padding(.top, getTopPadding(item))
            .padding(.bottom, getBottomPadding(item))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(getBackground(item))
            .transition(.identity)
            .opacity(getOpacity(item))
            .scaleEffect(getScale(item))
            .offset(getOffset(item))
            .offset(x: getRotationTranslation(item))
            .rotation3DEffect(getRotationAngle(item), axis: getRotationAxis(), anchor: getRotationAnchor(item), perspective: getRotationPerspective())
            .compositingGroup()
    }
}

// MARK: - Local Configurables
private extension NavigationStackView {
    func getTopPadding(_ item: AnyNavigatableView) -> CGFloat {
        switch getConfig(item).ignoredSafeAreas {
            case .some(let edges) where edges.isOne(of: .top, .all): return 0
            default: return UIScreen.safeArea.top
        }
    }
    func getBottomPadding(_ item: AnyNavigatableView) -> CGFloat {
        switch getConfig(item).ignoredSafeAreas {
            case .some(let edges) where edges.isOne(of: .bottom, .all): return 0
            default: return UIScreen.safeArea.bottom
        }
    }
    func getBackground(_ item: AnyNavigatableView) -> Color { getConfig(item).backgroundColour ?? config.backgroundColour }
    func getConfig(_ item: AnyNavigatableView) -> NavigationConfig { item.configure(view: .init()) }
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
            case .horizontalSlide, .verticalSlide, .cubeRotation: return stack.transitionsBlocked ? 1 : opacity
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

// MARK: - Calculating Rotation
private extension NavigationStackView {
    func getRotationAngle(_ view: AnyNavigatableView) -> Angle {
        do {
            try checkRotationPrerequisites(view)

            let angle = calculateRotationAngleValue(view)
            return angle
        } catch { return .zero }
    }
    func getRotationAnchor(_ view: AnyNavigatableView) -> UnitPoint {
        switch view == temporaryViews.last {
            case true: return .trailing
            case false: return .leading
        }
    }
    func getRotationTranslation(_ view: AnyNavigatableView) -> CGFloat {
        do {
            try checkRotationPrerequisites(view)

            let rotationTranslation = calculateRotationTranslationValue(view)
            return rotationTranslation
        } catch {
            return 0
        }
    }
    func getRotationAxis() -> (x: CGFloat, y: CGFloat, z: CGFloat) { (x: 0, y: 1, z: 0) }
    func getRotationPerspective() -> CGFloat { 1.8 }
}
private extension NavigationStackView {
    func checkRotationPrerequisites(_ view: AnyNavigatableView) throws {
        if !stack.transitionAnimation.isOne(of: .cubeRotation) { throw "Rotation cannot be set for a non-rotation transition type" }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { throw "Rotation can concern the last or next to last element of the stack" }
    }
    func calculateRotationAngleValue(_ view: AnyNavigatableView) -> Angle {
        switch view == temporaryViews.last {
            case true: return .degrees(90 - (animatableRotation * 90))
            case false: return .degrees(-(animatableRotation * 90))
        }
    }
    func calculateRotationTranslationValue(_ view: AnyNavigatableView) -> CGFloat {
        switch view == temporaryViews.last {
            case true: return UIScreen.width - (animatableRotation * UIScreen.width)
            case false: return -1 * (animatableRotation * UIScreen.width)
        }
    }
}

// MARK: - Animation
private extension NavigationStackView {
    func getAnimation() -> Animation {
        switch stack.transitionAnimation {
            case .no: return .easeInOut(duration: 0)
            case .scale, .dissolve, .horizontalSlide, .verticalSlide: return .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.4)
            case .cubeRotation: return .easeOut(duration: 0.6)
        }
    }
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
        animatableRotation = stack.transitionType == .push ? 0 : 1
        animatableScale = 0
    }
    func animateOffsetAndOpacityChange() { withAnimation(getAnimation()) {
        animatableOffset = 0
        animatableOpacity = 1
        animatableRotation = 1 - animatableRotation
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
            animatableRotation = 1
        }
    }
}

// MARK: - Configurables
private extension NavigationStackView {
    var scaleFactor: CGFloat { 0.38 }
    var maxXOffsetValueWhileRemoving: CGFloat { UIScreen.width * 0.33 }
    var maxOffsetValue: CGFloat { [.horizontalSlide: UIScreen.width, .verticalSlide: UIScreen.height][stack.transitionAnimation] ?? 0 }
}
