//
//  Public+NavigationConfig.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Content Customisation
public extension NavigationConfig {
    /// Ignores safe areas
    func ignoresSafeArea(_ edge: VerticalEdge.Set) -> Self { changing(path: \.ignoredSafeAreas, to: edge) }

    /// Changes the background colour of the selected view
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Changes the gesture that can be used to move to the previous view
    func navigationBackGesture(_ value: NavigationBackGesture) -> Self { changing(path: \.navigationBackGesture, to: value) }
}

// MARK: - Internal
public struct NavigationConfig: Configurable {
    private(set) var ignoredSafeAreas: VerticalEdge.Set? = nil
    private(set) var backgroundColour: Color? = nil
    private(set) var navigationBackGesture: NavigationBackGesture = .no
}
