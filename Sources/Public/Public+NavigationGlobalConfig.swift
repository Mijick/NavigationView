//
//  Public+NavigationGlobalConfig.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public struct NavigationGlobalConfig { public init() {}
    // MARK: Navigation Gestures
    public var backGesturePosition: NavigationBackGesture.Position = .anywhere
    public var backGestureThreshold: CGFloat = 0.25

    // MARK: Others
    public var backgroundColour: Color = .clear
}
