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
    @Namespace var namespace

    init(rootView: some NavigatableView) { NavigationManager.setRoot(rootView) }
    var body: some View { NavigationStackView(namespace: namespace) }
}
