//
//  Public+NavigationBackGesture.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


public enum NavigationBackGesture {}

// MARK: - Gesture Kind
extension NavigationBackGesture { public enum Kind {
    case no
    case drag
}}

// MARK: - Gesture Position
extension NavigationBackGesture { public enum Position {
    case edge
    case anywhere
}}
