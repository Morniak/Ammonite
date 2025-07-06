//
//  WorkspacesDisplayConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 30/06/2025.
//

import Foundation

struct WorkspacesDisplayConfig: Equatable {
    var titleStyle: WorkspaceTitleStyle = .name
    var decorationStyle: ItemListStyle = .box
    var showSeparators: Bool = false
    
    static var `default` = Self.init()
}

// MARK: - Decodable

extension WorkspacesDisplayConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case titleStyle
        case decorationStyle
        case showSeparators
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.titleStyle = try container.decodeIfPresent(WorkspaceTitleStyle.self, forKey: .titleStyle) ?? Self.default.titleStyle
        self.decorationStyle = try container.decodeIfPresent(ItemListStyle.self, forKey: .decorationStyle) ?? Self.default.decorationStyle
        self.showSeparators = try container.decodeIfPresent(Bool.self, forKey: .showSeparators) ?? Self.default.showSeparators
    }
}
