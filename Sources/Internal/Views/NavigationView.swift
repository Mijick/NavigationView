//
//  NavigationView.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct NavigationView: View {
    private let config: NavigationGlobalConfig


    init(rootView: some NavigatableView, config: NavigationGlobalConfig?) { self.config = config ?? .init(); NavigationManager.setRoot(rootView) }
    var body: some View { NavigationStackView(config: config) }
}
