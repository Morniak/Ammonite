//
//  AerospaceConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation

struct AerospaceConfig: Equatable {
    var path: String = Self.defaultAerospacePath
    var modesWidget: AerospaceModesWidgetConfig = .default

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
        case modesWidget
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decodeIfPresent(String.self, forKey: CodingKeys.path) ?? Self.default.path
        self.modesWidget = try container.decodeIfPresent(AerospaceModesWidgetConfig.self, forKey: .modesWidget) ?? Self.default.modesWidget
    }
}
