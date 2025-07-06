//
//  WorkspacePickerMenu.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import SwiftUI

struct WorkspacesWidgetView: View {

    @EnvironmentObject var configManager: ConfigManager
    
    @State private var viewModel: WorkspacesWidgetViewModel

    init(isMenu: Bool) {
        self.viewModel = WorkspacesWidgetViewModel(isMenu: isMenu)
    }
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        ItemListView(
            items: viewModel.workspaces,
            style: viewModel.workspacesDisplayConfig.decorationStyle,
            showSeparators: viewModel.workspacesDisplayConfig.showSeparators,
            isSelected: viewModel.isCurrentWorkspace(_:),
            action: viewModel.switchToWorkspace(_:)
        )
    }
}
