//
//  NavigatableView.swift of Navigattie
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol NavigatableView: View {
    /// OPTIONAL: Changes the background colour of the selected view
    var backgroundColour: Color? { get }
}

// MARK: - Internals
extension NavigatableView {
    var id: String { .init(describing: Self.self) }
}
