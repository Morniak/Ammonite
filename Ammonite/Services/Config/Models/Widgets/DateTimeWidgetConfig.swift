//
//  DateTimeConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation

struct DateTimeWidgetConfig: Equatable {
    var format: String? = nil
    var locale: Locale? = nil
    
    // Since both format and locale depend on user settings there is no universal default value.
    private static var `default`: Self = .init()
}

// MARK: - Decodable

extension DateTimeWidgetConfig: Decodable {
    private enum CodingKeys: CodingKey {
        case format
        case locale
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<Self.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.format = try container.decodeIfPresent(String.self, forKey: .format)
        
        if let localeStr = try container.decodeIfPresent(String.self, forKey: .locale) {
            locale = Locale(identifier: localeStr)
        } else {
            locale = nil
        }
    }
}
