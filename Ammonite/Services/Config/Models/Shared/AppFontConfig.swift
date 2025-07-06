//
//  AppFontConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 30/06/2025.
//

import Foundation
import SwiftUI

struct AppFontConfig {
    private(set) var name: String?
    private(set) var size: CGFloat = 12
    
    static var `default` = AppFontConfig()
    
    func font(size: CGFloat? = nil) -> Font {
        if let name {
            return Font.custom(name, size: size ?? self.size)
        } else {
            return .system(size: size ?? self.size, weight: .bold, design: .monospaced)
        }
    }
    
    func resized(by delta: CGFloat) -> Font {
        let newSize = size + delta
        return font(size: newSize)
    }
    
    func scaled(by factor: CGFloat) -> Font {
        let newSize = size * factor
        return font(size: newSize)
    }
}

// MARK: - Decodable

extension AppFontConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case name
        case size
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<AppFontConfig.CodingKeys> = try decoder.container(keyedBy: AppFontConfig.CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? Self.default.name
        self.size = try container.decodeIfPresent(CGFloat.self, forKey: .size) ?? Self.default.size
    }
}


