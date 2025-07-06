//
//  Array+safe.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 30/06/2025.
//

import Foundation

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
