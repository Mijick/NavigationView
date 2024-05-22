//
//  Array++.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) { if prerequisite {
        append(newElement)
    }}
    @inlinable mutating func removeLastExceptFirst() { if count > 1 {
        removeLast()
    }}
    @inlinable mutating func removeAllExceptFirst() { if count > 1 {
        removeLast(count - 1)
    }}
    @inlinable mutating func removeLastTo(elementWhere predicate: (Element) throws -> Bool) rethrows { if let index = try lastIndex(where: predicate) {
        removeLast(count - index - 1)
    }}
}
extension Array {
    var nextToLast: Element? { count >= 2 ? self[count - 2] : nil }
}


// MARK: - Equatable Elements
extension Array where Element: Equatable {
    func appendingAsFirstAndRemovingDuplicates(_ newElement: Element) -> [Element] {
        var elements = self

        elements.removeAll(where: { $0 == newElement })
        elements[0] = newElement

        return elements
    }
}
