//
//  BatteryWidgetConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation

struct BatteryWidgetConfig: Equatable {
    var showPercentage: Bool = false
    var isMonochrome: Bool = false
    var lowLevelColor: String = "#FF0000B3"
    var mediumLevelColor: String = "#FFFF00B3"
    var highLevelColor: String = "#00FF00B3"
    
    static let `default`: BatteryWidgetConfig = .init()
}

// MARK: - Decodable

extension BatteryWidgetConfig: Decodable {
    private enum CodingKeys: CodingKey {
        case showPercentage
        case isMonochrome
        case lowLevelColor
        case mediumLevelColor
        case highLevelColor
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<BatteryWidgetConfig.CodingKeys> = try decoder.container(keyedBy: BatteryWidgetConfig.CodingKeys.self)
        self.showPercentage = try container.decodeIfPresent(Bool.self, forKey: .showPercentage) ?? Self.default.showPercentage
        self.isMonochrome = try container.decodeIfPresent(Bool.self, forKey: BatteryWidgetConfig.CodingKeys.isMonochrome) ?? Self.default.isMonochrome
        self.lowLevelColor = try container.decodeIfPresent(String.self, forKey: BatteryWidgetConfig.CodingKeys.lowLevelColor) ?? Self.default.lowLevelColor
        self.mediumLevelColor = try container.decodeIfPresent(String.self, forKey: BatteryWidgetConfig.CodingKeys.mediumLevelColor) ?? Self.default.mediumLevelColor
        self.highLevelColor = try container.decodeIfPresent(String.self, forKey: BatteryWidgetConfig.CodingKeys.highLevelColor) ?? Self.default.highLevelColor
    }
}
