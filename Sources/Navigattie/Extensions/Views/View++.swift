//
//  View++.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension View {
    @ViewBuilder func matchedGeometryEffect(id: String, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View {
        if let namespace = NavigationManager.shared.namespace { matchedGeometryEffect(id: id, in: namespace, properties: properties, anchor: anchor, isSource: isSource) }
        else { self }
    }
}

extension View {
    func modify<V: View>(_ builder: (Self) -> V) -> some View { builder(self) }
}
