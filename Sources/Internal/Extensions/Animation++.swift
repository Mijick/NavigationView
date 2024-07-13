//
//  Animation++.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension Animation {
    static func keyboard(withDelay: Bool) -> Animation { .easeOut(duration: 0.25).delay(withDelay ? 0.1 : 0) }
}
