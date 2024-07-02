//
//  ScreenManager.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

class ScreenManager: ObservableObject {
    @Published var size: CGSize = .init()
    @Published var safeArea: UIEdgeInsets = .init()

    static let shared: ScreenManager = .init()
    private init() {}
}

// MARK: - Updating Dimensions
extension ScreenManager {
    static func update(_ reader: GeometryProxy) {
        shared.size.height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        shared.size.width = reader.size.width + reader.safeAreaInsets.leading + reader.safeAreaInsets.trailing

        shared.safeArea.top = reader.safeAreaInsets.top
        shared.safeArea.bottom = reader.safeAreaInsets.bottom
        shared.safeArea.left = reader.safeAreaInsets.leading
        shared.safeArea.right = reader.safeAreaInsets.trailing
    }
}

// MARK: - Getting Value For Safe Area
extension ScreenManager {
    func getSafeAreaValue(for edge: Edge.Set) -> CGFloat { switch edge {
        case .top: safeArea.top
        case .bottom: safeArea.bottom
        case .leading: safeArea.left
        case .trailing: safeArea.right
        default: 0
    }}
}
