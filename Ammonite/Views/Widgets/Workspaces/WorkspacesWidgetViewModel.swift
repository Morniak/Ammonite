//
//  WorkspacesWidgetViewModel.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Factory
import Combine

@MainActor
@Observable
final class WorkspacesWidgetViewModel {
    @ObservationIgnored @Injected(\AmmoniteContainer.configManager) private var configManager
    @ObservationIgnored @Injected(\AmmoniteContainer.workspaceSwitcher) private var workspaceSwitcher
    @ObservationIgnored @Injected(\AmmoniteContainer.workspacesRepository) private var repository
    
    let isMenu: Bool
    
    var currentIndex: Int = 0
    var workspaces: [String] = []
    
    private var cancellable: AnyCancellable?
    private var workspaceConfig: WorkspacesConfig { configManager.config.workspaces }
    
    var workspacesDisplayConfig: WorkspacesDisplayConfig {
        isMenu ? workspaceConfig.menuDisplay : workspaceConfig.widgetDisplay
    }
    
    init(isMenu: Bool) {
        self.isMenu = isMenu
        
        cancellable = repository.workspacesStatePublisher.sink { [weak self] state in
            guard let self else { return }
            self.workspaces = state.workspaces.map(self.textForWorkspace(_:))
            self.currentIndex = state.current ?? 0
        }
    }
    
    func switchToWorkspace(_ workspaceIndex: Int) {
        workspaceSwitcher.switchToWorkspace(at: workspaceIndex)
    }
    
    func isCurrentWorkspace(_ workspaceIndex: Int) -> Bool {
        currentIndex == workspaceIndex
    }
    
    func textForWorkspace(_ workspace: String) -> String {
        switch workspacesDisplayConfig.titleStyle {
        case .index:
            guard let index = workspaceConfig.workspaces.firstIndex(of: workspace) else { return "?" }
            return "\(index + 1)"
        case .name:
            return workspaceConfig.aliases[workspace] ?? workspace
        }
    }
}
