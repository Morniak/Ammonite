//
//  AerospaceModeWidgetConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 15/07/2025.
//

struct AerospaceModesWidgetConfig: Equatable {
    var current: String = "main"
    var modes: [String] = ["main"]
    var icons: [String: String] = ["main":"circle"]
    var menuStyle: ItemListStyle = .box
    var widgetStyle: ItemListStyle = .box
    var showSeparatorsInMenu: Bool = false
    var showSeparatorsInWidget: Bool = false

    static var `default` = Self.init()
}

// MARK: - Decoder

extension AerospaceModesWidgetConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case path
        case current
        case modes
        case icons
        case menuStyle
        case widgetStyle
        case showSeparatorsInMenu
        case showSeparatorsInWidget
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.current = try container.decodeIfPresent(String.self, forKey: CodingKeys.current) ?? Self.default.current
        self.modes = try container.decodeIfPresent([String].self, forKey: CodingKeys.modes) ?? Self.default.modes
        self.icons = try container.decodeIfPresent([String: String].self, forKey: .icons) ?? Self.default.icons
        self.menuStyle = try container.decodeIfPresent(ItemListStyle.self, forKey: .menuStyle) ?? Self.default.menuStyle
        self.widgetStyle = try container.decodeIfPresent(ItemListStyle.self, forKey: .widgetStyle) ?? Self.default.widgetStyle
        self.showSeparatorsInMenu = try container.decodeIfPresent(Bool.self, forKey: .showSeparatorsInMenu) ?? Self.default.showSeparatorsInMenu
        self.showSeparatorsInWidget = try container.decodeIfPresent(Bool.self, forKey: .showSeparatorsInWidget) ?? Self.default.showSeparatorsInWidget
    }
}
