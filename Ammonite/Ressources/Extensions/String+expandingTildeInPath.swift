//
//  String+expandingTildeInPath.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 23/06/2025.
//

import Foundation

extension String {
    func expandingTildeInPath() -> String? {
        return NSString(string: self).expandingTildeInPath
    }
}
