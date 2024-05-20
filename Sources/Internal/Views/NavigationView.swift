//
//  NavigationView.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct NavigationView: View {
    @ObservedObject private var stack: NavigationManager = .shared
    @ObservedObject private var screenManager: ScreenManager = .shared
    @State private var temporaryViews: [AnyNavigatableView] = []
    @State private var animatableOpacity: CGFloat = 1
    @State private var animatableOffset: CGFloat = 0
    @State private var animatableRotation: CGFloat = 0
    @State private var animatableScale: CGFloat = 0
    private let config: NavigationGlobalConfig


    init(rootView: some NavigatableView, config: NavigationGlobalConfig?) {
        NavigationManager.setRoot(rootView)

        self.config = config ?? .init()
        self._temporaryViews = .init(initialValue: NavigationManager.shared.views)
    }
    var body: some View {
        ZStack { ForEach(temporaryViews, id: \.id, content: createItem) }
            .ignoresSafeArea(.container)
            .onChange(of: stack.views, perform: onViewsChanged)
            .onAnimationCompleted(for: animatableOpacity, perform: onAnimationCompleted)
    }
}
private extension NavigationView {
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
private extension NavigationView {
    func getTopPadding(_ item: AnyNavigatableView) -> CGFloat { switch getConfig(item).ignoredSafeAreas {
        case .some(let edges) where edges.isOne(of: .top, .all): 0
        default: screenManager.safeArea.top
    }}
    func getBottomPadding(_ item: AnyNavigatableView) -> CGFloat { switch getConfig(item).ignoredSafeAreas {
        case .some(let edges) where edges.isOne(of: .bottom, .all): 0
        default: screenManager.safeArea.bottom
    }}
    func getBackground(_ item: AnyNavigatableView) -> Color { getConfig(item).backgroundColour ?? config.backgroundColour }
    func getConfig(_ item: AnyNavigatableView) -> NavigationConfig { item.configure(view: .init()) }
}

// MARK: - Calculating Opacity
private extension NavigationView {
    func getOpacity(_ view: AnyNavigatableView) -> CGFloat { guard canCalculateOpacity(view) else { return 0 }
        let isLastView = isLastView(view)
        let opacity = calculateOpacityValue(isLastView)
        let finalOpacity = calculateFinalOpacityValue(opacity)
        return finalOpacity
    }
}
private extension NavigationView {
    func canCalculateOpacity(_ view: AnyNavigatableView) -> Bool {
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { return false }
        return true
    }
    func isLastView(_ view: AnyNavigatableView) -> Bool {
        let lastView = stack.transitionType == .push ? temporaryViews.last : stack.views.last
        return view == lastView
    }
    func calculateOpacityValue(_ isLastView: Bool) -> CGFloat {
        isLastView ? animatableOpacity : 1 - animatableOpacity
    }
    func calculateFinalOpacityValue(_ opacity: CGFloat) -> CGFloat { switch stack.transitionAnimation {
        case .no, .dissolve, .scale: opacity
        case .horizontalSlide, .verticalSlide, .cubeRotation: stack.transitionsBlocked ? 1 : opacity
    }}
}

// MARK: - Calculating Offset
private extension NavigationView {
    func getOffset(_ view: AnyNavigatableView) -> CGSize { guard canCalculateOffset(view) else { return .zero }
        let offsetSlideValue = calculateSlideOffsetValue(view)
        let offset = animatableOffset + offsetSlideValue
        let offsetX = calculateXOffsetValue(offset), offsetY = calculateYOffsetValue(offset)
        let finalOffset = calculateFinalOffsetValue(view, offsetX, offsetY)
        return finalOffset
    }
}
private extension NavigationView {
    func canCalculateOffset(_ view: AnyNavigatableView) -> Bool {
        if !stack.transitionAnimation.isOne(of: .horizontalSlide, .verticalSlide) { return false }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { return false }
        return true
    }
    func calculateSlideOffsetValue(_ view: AnyNavigatableView) -> CGFloat { switch view == temporaryViews.last {
        case true: stack.transitionType == .push ? 0 : maxOffsetValue
        case false: stack.transitionType == .push ? -maxOffsetValue : 0
    }}
    func calculateXOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .horizontalSlide ? offset : 0 }
    func calculateYOffsetValue(_ offset: CGFloat) -> CGFloat { stack.transitionAnimation == .verticalSlide ? offset : 0 }
    func calculateFinalOffsetValue(_ view: AnyNavigatableView, _ offsetX: CGFloat, _ offsetY: CGFloat) -> CGSize { switch view == temporaryViews.last {
        case true: .init(width: offsetX, height: offsetY)
        case false: .init(width: max(offsetX, -maxXOffsetValueWhileRemoving), height: 0)
    }}
}

// MARK: - Calculating Scale
private extension NavigationView {
    func getScale(_ view: AnyNavigatableView) -> CGFloat { guard canCalculateScale(view) else { return 1 }
        let scaleValue = calculateScaleValue(view)
        let finalScale = calculateFinalScaleValue(scaleValue)
        return finalScale
    }
}
private extension NavigationView {
    func canCalculateScale(_ view: AnyNavigatableView) -> Bool {
        if !stack.transitionAnimation.isOne(of: .scale) { return false }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { return false }
        return true
    }
    func calculateScaleValue(_ view: AnyNavigatableView) -> CGFloat { switch view == temporaryViews.last {
        case true: stack.transitionType == .push ? 1 - scaleFactor + animatableScale : 1 - animatableScale
        case false: stack.transitionType == .push ? 1 + animatableScale : 1 + scaleFactor - animatableScale
    }}
    func calculateFinalScaleValue(_ scaleValue: CGFloat) -> CGFloat { stack.transitionsBlocked ? scaleValue : 1 }
}

// MARK: - Calculating Rotation
private extension NavigationView {
    func getRotationAngle(_ view: AnyNavigatableView) -> Angle { guard canCalculateRotation(view) else { return .zero }
        let angle = calculateRotationAngleValue(view)
        return angle
    }
    func getRotationAnchor(_ view: AnyNavigatableView) -> UnitPoint { switch view == temporaryViews.last {
        case true: .trailing
        case false: .leading
    }}
    func getRotationTranslation(_ view: AnyNavigatableView) -> CGFloat { guard canCalculateRotation(view) else { return 0 }
        let rotationTranslation = calculateRotationTranslationValue(view)
        return rotationTranslation
    }
    func getRotationAxis() -> (x: CGFloat, y: CGFloat, z: CGFloat) { (x: 0, y: 1, z: 0) }
    func getRotationPerspective() -> CGFloat { 1.8 }
}
private extension NavigationView {
    func canCalculateRotation(_ view: AnyNavigatableView) -> Bool {
        if !stack.transitionAnimation.isOne(of: .cubeRotation) { return false }
        if !view.isOne(of: temporaryViews.last, temporaryViews.nextToLast) { return false }
        return true
    }
    func calculateRotationAngleValue(_ view: AnyNavigatableView) -> Angle { switch view == temporaryViews.last {
        case true: .degrees(90 + -animatableRotation * 90)
        case false: .degrees(-animatableRotation * 90)
    }}
    func calculateRotationTranslationValue(_ view: AnyNavigatableView) -> CGFloat { switch view == temporaryViews.last {
        case true: screenManager.size.width - (animatableRotation * screenManager.size.width)
        case false: -1 * (animatableRotation * screenManager.size.width)
    }}
}

// MARK: - Animation
private extension NavigationView {
    func getAnimation() -> Animation { switch stack.transitionAnimation {
        case .no: .easeInOut(duration: 0)
        case .scale, .dissolve, .horizontalSlide, .verticalSlide: .spring(duration: 0.36, bounce: 0, blendDuration: 0.1)
        case .cubeRotation: .easeOut(duration: 0.52)
    }}
}

// MARK: - On Transition Begin
private extension NavigationView {
    func onViewsChanged(_ views: [AnyNavigatableView]) {
        blockTransitions()
        updateTemporaryViews(views)
        resetOffsetAndOpacity()
        animateOffsetAndOpacityChange()
    }
}
private extension NavigationView {
    func blockTransitions() {
        NavigationManager.blockTransitions(true)
    }
    func updateTemporaryViews(_ views: [AnyNavigatableView]) { switch stack.transitionType {
        case .push: temporaryViews = views
        case .pop: temporaryViews = views + [temporaryViews.last].compactMap { $0 }
    }}
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
private extension NavigationView {
    func onAnimationCompleted() {
        resetViewOnAnimationCompleted()
        unblockTransitions()
    }
}
private extension NavigationView {
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
private extension NavigationView {
    var scaleFactor: CGFloat { 0.38 }
    var maxXOffsetValueWhileRemoving: CGFloat { screenManager.size.width * 0.33 }
    var maxOffsetValue: CGFloat { [.horizontalSlide: screenManager.size.width, .verticalSlide: screenManager.size.height][stack.transitionAnimation] ?? 0 }
}
