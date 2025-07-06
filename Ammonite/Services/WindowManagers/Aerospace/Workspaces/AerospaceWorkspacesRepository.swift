//
//  AerospaceWorkspacesRepository.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Combine
import Factory

class AerospaceWorkspacesRepository {
    
    @Injected(\AmmoniteContainer.commandListener) var commandListener
    @Injected(\AmmoniteContainer.aerospaceInteractor) var aerospaceInteractor
    
    private var workspaceAliases: [String: String] = [:]
    private let workspacesStateSubject: CurrentValueSubject<WorkspacesState, Never>
    private var cancellable: AnyCancellable?

    init(config: Config) {
        self.workspaceAliases = config.workspaces.aliases
        let workspaces = config.workspaces.workspaces
        let currentIndex: Int? = if let current = config.workspaces.current {
            workspaces.firstIndex(of: current)
        } else {
            nil
        }
        let workspacesState = WorkspacesState(workspaces: workspaces, current: currentIndex)
        
        workspacesStateSubject = .init(workspacesState)
        
        self.cancellable = self.commandListener.commandPublisher.sink { [weak self] command in
            guard case let .workspaceChange(workspace) = command else { return }
            self?.onCurrentWorkspaceUpdated(workspace)
        }
    }
    
    func onCurrentWorkspaceUpdated(_ current: String) {
        guard let newIndex = workspacesState.workspaces.firstIndex(of: current) else { return }
        
        var state = workspacesState
        state.current = newIndex
        self.workspacesStateSubject.send(state)
    }
}

// MARK: - WorkspacesRepository

extension AerospaceWorkspacesRepository: WorkspacesRepository {
    
    var workspacesState: WorkspacesState { workspacesStateSubject.value }
    
    var workspacesStatePublisher: AnyPublisher<WorkspacesState, Never> {
        workspacesStateSubject.eraseToAnyPublisher()
    }
    
    func displayName(for workspace: String) -> String {
        workspaceAliases[workspace] ?? workspace
    }
}
