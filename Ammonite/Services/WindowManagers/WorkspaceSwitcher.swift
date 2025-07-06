//
//  Workspace.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import SwiftUI

protocol WorkspaceSwitcher: AnyObject {
    func switchToWorkspace(_ workspace: String)
    func switchToWorkspace(at index: Int)
    func switchNext(wrapAround: Bool)
    func switchPrevious(wrapAround: Bool)
}
