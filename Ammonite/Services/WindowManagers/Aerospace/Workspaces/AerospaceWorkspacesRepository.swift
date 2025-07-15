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
    @Injected(\AmmoniteContainer.configManager) var configManager
    
    private var workspaceAliases: [String: String] = [:]
    private let workspacesStateSubject = CurrentValueSubject<WorkspacesState, Never>(.init(workspaces: []))
    private var cancellables = Set<AnyCancellable>()

    init() {
        updateState(for: configManager.config.workspaces)

        self.commandListener.commandPublisher
            .sink { [weak self] command in
                guard case let .workspaceChange(workspace) = command else { return }
                self?.onCurrentWorkspaceUpdated(workspace)
            }
            .store(in: &cancellables)
        
        self.configManager.$config
            .map(\.workspaces)
            .removeDuplicates()
            .sink { [weak self] config in self?.updateState(for: config) }
            .store(in: &cancellables)
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

// MARK: - Private methods

private extension AerospaceWorkspacesRepository {
    func updateState(for config: WorkspacesConfig) {
        self.workspaceAliases = config.aliases
        let workspaces = config.workspaces
        let currentIndex: Int? = if let current = config.current {
            workspaces.firstIndex(of: current)
        } else {
            nil
        }
        let workspacesState = WorkspacesState(workspaces: workspaces, current: currentIndex)
        
        workspacesStateSubject.send(workspacesState)
    }
}
