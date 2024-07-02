//
//  Public+SafeAreaEdges.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public enum SafeAreaEdges {
    case top
    case bottom
    case leading
    case trailing
    case all
}

// MARK: - Initialiser
extension SafeAreaEdges {
    init(_ value: Edge.Set) { switch value {
        case .top: self = .top
        case .bottom: self = .bottom
        case .leading: self = .leading
        case .trailing: self = .trailing
        case .all: self = .all
        default: self = .all
    }}
}
