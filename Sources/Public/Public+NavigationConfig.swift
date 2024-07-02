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
    func ignoresSafeArea(_ regions: SafeAreaRegions = .all, _ edges: SafeAreaEdges) -> Self { changing(path: \.ignoredSafeAreas, to: (regions, edges)) }

    /// Changes the background colour of the selected view
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Changes the gesture that can be used to move to the previous view
    func navigationBackGesture(_ value: NavigationBackGesture.Kind) -> Self { changing(path: \.navigationBackGesture, to: value) }
}

// MARK: - Internal
public struct NavigationConfig: Configurable {
    private(set) var ignoredSafeAreas: (regions: SafeAreaRegions, edges: SafeAreaEdges)? = nil
    private(set) var backgroundColour: Color? = nil
    private(set) var navigationBackGesture: NavigationBackGesture.Kind = .no
}
