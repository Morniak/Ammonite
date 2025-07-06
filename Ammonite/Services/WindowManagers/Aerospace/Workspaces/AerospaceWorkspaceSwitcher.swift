//
//  AerospaceWorkspacesSwitcher.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Factory

class AerospaceWorkspaceSwitcher {
    @Injected(\AmmoniteContainer.aerospaceInteractor) var aerospaceInteractor
    @Injected(\AmmoniteContainer.aerospaceWorkspacesRepository) var workspacesRepository
}

// MARK: - WorkspaceSwitcher

extension AerospaceWorkspaceSwitcher: WorkspaceSwitcher {
    func switchToWorkspace(_ workspace: String) {
        Task {
            do {
                try await aerospaceInteractor.switchToWorkspace(workspace: workspace)
                workspacesRepository.onCurrentWorkspaceUpdated(workspace)
            } catch {
                print(error)
            }
        }
    }
    
    func switchToWorkspace(at index: Int) {
        guard let workspace = workspacesRepository.workspacesState.workspaces[safe: index] else { return }
        self.switchToWorkspace(workspace)
    }
    
    func switchNext(wrapAround: Bool) {
        guard var index = workspacesRepository.workspacesState.current else {
            switchToWorkspace(at: 0)
            return
        }
        
        let workspaces = workspacesRepository.workspacesState.workspaces
        
        if index == workspaces.count - 1 {
            index = wrapAround ? 0 : index
        } else {
            index = index + 1
        }
        
        switchToWorkspace(at: index)
    }
    
    func switchPrevious(wrapAround: Bool) {
        guard var index = workspacesRepository.workspacesState.current else {
            switchToWorkspace(at: 0)
            return
        }
        
        let workspaces = workspacesRepository.workspacesState.workspaces
        
        if index == 0 {
            index = wrapAround ? workspaces.count - 1 : index
        } else {
            index = index - 1
        }
        
        switchToWorkspace(at: index)
    }
}
