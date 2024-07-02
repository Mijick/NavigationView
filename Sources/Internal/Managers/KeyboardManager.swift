//
//  KeyboardManager.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import Combine

class KeyboardManager: ObservableObject {
    @Published private(set) var isActive: Bool = false
    private var subscription: [AnyCancellable] = []

    static let shared: KeyboardManager = .init()
    private init() { subscribeToKeyboardEvents() }
}

// MARK: - Hiding Keyboard
extension KeyboardManager {
    static func hideKeyboard() { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
}

// MARK: - Show / Hide Events
private extension KeyboardManager {
    func subscribeToKeyboardEvents() { Publishers.Merge(keyboardWillOpenPublisher, keyboardWillHidePublisher)
        .sink { self.isActive = $0 }
        .store(in: &subscription)
    }
}
private extension KeyboardManager {
    var keyboardWillOpenPublisher: Publishers.Map<NotificationCenter.Publisher, Bool> { NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { _ in true }
    }
    var keyboardWillHidePublisher: Publishers.Map<NotificationCenter.Publisher, Bool> { NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in false }
    }
}
