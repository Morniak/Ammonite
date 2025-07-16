//
//  ThemeConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import Foundation
import SwiftUI
import AppKit

struct AppearanceConfig: Equatable {
    
    var notchWidth: CGFloat = 184
    var notchHeight: CGFloat = 32
    var notchCornerRadius: CGFloat = 10
    
    var outerPadding: CGFloat = 10
    var innerPadding: CGFloat = 10
    var itemsSpacing: CGFloat = 6
    var edgeCutoutEnabled: Bool = false
        
    var _primaryColor: String = Self.defaultValue.primaryColor
    var primaryColor: AnyShapeStyle { .fromString(_primaryColor) }

    var _secondaryColor: String = Self.defaultValue.secondaryColor
    var secondaryColor: AnyShapeStyle { .fromString(_secondaryColor) }
    
    var _barBackgroundColor: String = Self.defaultValue.barBackgroundColor
    var barBackgroundColor: AnyShapeStyle { .fromString(_barBackgroundColor) }

    var _menuBackgroundColor: String = Self.defaultValue.menuBackgroundColor
    var menuBackgroundColor: AnyShapeStyle { .fromString(_menuBackgroundColor) }
    
    var font: AppFontConfig = .default

    static let defaultValue = (
        primaryColor: "#FFFFFFB3",
        secondaryColor: "#FFFFFF4D",
        barBackgroundColor: "ultra-thick material",
        menuBackgroundColor: "regular material"
    )
    
    static var `default` = AppearanceConfig()
}

// MARK: - Decodable

extension AppearanceConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case notchWidth
        case notchHeight
        case notchCornerRadius
        case outerPadding
        case innerPadding
        case itemsSpacing
        case edgeCutoutEnabled
        case primaryColor
        case secondaryColor
        case barBackgroundColor
        case menuBackgroundColor
        case font
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<AppearanceConfig.CodingKeys> = try decoder.container(keyedBy: AppearanceConfig.CodingKeys.self)
        self.notchWidth = try container.decodeIfPresent(CGFloat.self, forKey: .notchWidth) ?? Self.default.notchWidth
        self.notchHeight = try container.decodeIfPresent(CGFloat.self, forKey: .notchHeight) ?? Self.default.notchHeight
        self.notchCornerRadius = try container.decodeIfPresent(CGFloat.self, forKey: .notchCornerRadius) ?? Self.default.notchCornerRadius
        self.outerPadding = try container.decodeIfPresent(CGFloat.self, forKey: .outerPadding) ?? Self.default.outerPadding
        self.innerPadding = try container.decodeIfPresent(CGFloat.self, forKey: .innerPadding) ?? Self.default.innerPadding
        self.itemsSpacing = try container.decodeIfPresent(CGFloat.self, forKey: .itemsSpacing) ?? Self.default.itemsSpacing
        self.edgeCutoutEnabled = try container.decodeIfPresent(Bool.self, forKey: .edgeCutoutEnabled) ?? Self.default.edgeCutoutEnabled
        self._primaryColor = try container.decodeIfPresent(String.self, forKey: .primaryColor) ?? Self.defaultValue.primaryColor
        self._secondaryColor = try container.decodeIfPresent(String.self, forKey: .secondaryColor) ?? Self.defaultValue.secondaryColor
        self._barBackgroundColor = try container.decodeIfPresent(String.self, forKey: .barBackgroundColor) ?? Self.defaultValue.barBackgroundColor
        self._menuBackgroundColor = try container.decodeIfPresent(String.self, forKey: .menuBackgroundColor) ?? Self.defaultValue.menuBackgroundColor
        self.font = try container.decodeIfPresent(AppFontConfig.self, forKey: .font) ?? Self.default.font
    }
}

// MARK: - Helpers

extension AppearanceConfig {
    static var stringToMaterials: [String: any ShapeStyle] = [
        "ultra-thin material": .ultraThinMaterial,
        "thin material": .thinMaterial,
        "regular material": .regularMaterial,
        "thick material": .thickMaterial,
        "ultra-thick material": .ultraThickMaterial,
    ]
}

private extension AnyShapeStyle {
    static func fromString(_ str: String) -> AnyShapeStyle {
        if let material = AppearanceConfig.stringToMaterials[str] {
            AnyShapeStyle(material)
        } else {
            AnyShapeStyle(Color(hex: str))
        }
    }
}
