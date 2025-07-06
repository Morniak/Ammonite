//
//  StorageDevicesMonitorWidgetConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 06/07/2025.
//

import Foundation

struct StorageDevicesMonitorWidgetConfig: Equatable {
    let style: ItemListStyle
    let showSeparators: Bool
    
    static var `default` = StorageDevicesMonitorWidgetConfig(style: .box, showSeparators: false)
}

// MARK: - Decodable

extension StorageDevicesMonitorWidgetConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case style
        case showSeparators
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.style = try container.decodeIfPresent(ItemListStyle.self, forKey: CodingKeys.style) ?? Self.default.style
        self.showSeparators = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.showSeparators) ?? Self.default.showSeparators
    }
}
