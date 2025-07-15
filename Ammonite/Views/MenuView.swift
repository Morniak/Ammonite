//
//  MenuView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import Foundation
import SwiftUI
import Factory

struct MenuView: View {
    
    @EnvironmentObject var configManager: ConfigManager

    let widget: Widget?
    
    var body: some View {
        if let widget, configManager.config.canPresentMenu(for: widget) {
            switch widget {
            case .workspaceGrid, .currentWorkspaceIndex, .currentWorkspaceLetter:
                WorkspacesWidgetView(isMenu: true)
            case .currentAerospaceMode:
                AerospaceModeListWidgetView(isMenu: true)
            case .storage where AmmoniteContainer.shared.storageDevicesMonitor().devices.count > 0:
                StoragesWidgetView()
            default:
                EmptyView()
            }
        }
    }
}
