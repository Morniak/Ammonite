//
//  WorkspaceTracker.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Combine

struct WorkspacesState {
    let workspaces: [String]
    var current: Int?
}

protocol WorkspacesRepository {
    var workspacesState: WorkspacesState { get }
    var workspacesStatePublisher: AnyPublisher<WorkspacesState, Never> { get }
    
    func displayName(for workspace: String) -> String
}
