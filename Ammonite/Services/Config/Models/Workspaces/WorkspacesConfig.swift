//
//  WorkspacesConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation

struct WorkspacesConfig: Equatable {
    
    let workspaces: [String]
    let current: String?
    let aliases: [String: String]
    let menuDisplay: WorkspacesDisplayConfig
    let widgetDisplay: WorkspacesDisplayConfig
    
    static var `default`: WorkspacesConfig = .init(
        workspaces: [],
        current: nil,
        aliases: [:],
        menuDisplay: .default,
        widgetDisplay: .default
    )
}

// MARK: - Decodable

extension WorkspacesConfig: Decodable {
    
    private enum CodingKeys: CodingKey {
        case workspaces
        case current
        case aliases
        case menuDisplay
        case widgetDisplay
        
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<WorkspacesConfig.CodingKeys> = try decoder.container(keyedBy: WorkspacesConfig.CodingKeys.self)
        self.workspaces = try container.decodeIfPresent([String].self, forKey: WorkspacesConfig.CodingKeys.workspaces) ?? Self.default.workspaces
        self.current = try container.decodeIfPresent(String.self, forKey: WorkspacesConfig.CodingKeys.current) ?? Self.default.current
        self.aliases = try container.decodeIfPresent([String: String].self, forKey: .aliases) ?? Self.default.aliases
        self.menuDisplay = try container.decodeIfPresent(WorkspacesDisplayConfig.self, forKey: .menuDisplay) ?? Self.default.menuDisplay
        self.widgetDisplay = try container.decodeIfPresent(WorkspacesDisplayConfig.self, forKey: .widgetDisplay) ?? Self.default.widgetDisplay
    }
}
