//
//  NavigatableView++.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension NavigatableView {
    func implementNavigationView(config: NavigationConfig? = nil) -> some View { NavigationView(rootView: self, config: config) }
}
