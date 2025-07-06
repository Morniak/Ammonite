//
//  AerospaceConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation

struct AerospaceConfig: Equatable {
    
    var path: String = Self.defaultAerospacePath
    var currentMode: String = "main"
    var modes: [String] = ["main"]
    var modeIcons: [String: String] = ["main":"circle"]
    var menuStyle: ItemListStyle = .box
    var widgetStyle: ItemListStyle = .box
    var showSeparatorsInMenu: Bool = false
    var showSeparatorsInWidget: Bool = false
    
    static var defaultAerospacePath: String {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/aerospace") {
            "/opt/homebrew/bin/aerospace"
        } else if FileManager.default.fileExists(atPath: "/usr/local/bin/aerospace") {
            "/usr/local/bin/aerospace"
        } else {
            "/opt/homebrew/bin/aerospace"
        }
    }
    
    static var `default` = Self.init()
}

// MARK: - Decoder

extension AerospaceConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case path
        case currentMode
        case modes
        case modeIcons
        case menuStyle
        case widgetStyle
        case showSeparatorsInMenu
        case showSeparatorsInWidget
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decodeIfPresent(String.self, forKey: CodingKeys.path) ?? Self.default.path
        self.currentMode = try container.decodeIfPresent(String.self, forKey: CodingKeys.currentMode) ?? Self.default.currentMode
        self.modes = try container.decodeIfPresent([String].self, forKey: CodingKeys.modes) ?? Self.default.modes
        self.modeIcons = try container.decodeIfPresent([String: String].self, forKey: .modeIcons) ?? Self.default.modeIcons
        self.menuStyle = try container.decodeIfPresent(ItemListStyle.self, forKey: .menuStyle) ?? Self.default.menuStyle
        self.widgetStyle = try container.decodeIfPresent(ItemListStyle.self, forKey: .widgetStyle) ?? Self.default.widgetStyle
        self.showSeparatorsInMenu = try container.decodeIfPresent(Bool.self, forKey: .showSeparatorsInMenu) ?? Self.default.showSeparatorsInMenu
        self.showSeparatorsInWidget = try container.decodeIfPresent(Bool.self, forKey: .showSeparatorsInWidget) ?? Self.default.showSeparatorsInWidget
    }
}
