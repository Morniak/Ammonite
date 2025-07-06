//
//  NotchWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 20/06/2025.
//

import Foundation
import SwiftUI

struct WidgetView: View {
    
    let widget: Widget?
    let isInNotch: Bool
    let isMenu: Bool
    
    var body: some View {
        switch widget {
        case .some(.none), Optional.none:
            Color.clear
        case _ where !widget!.isAllowedInNotch && isInNotch:
            Color.clear
        case .separator:
            Divider()
        case .digitalClock:
            DigitalClockWidgetView()
        case .analogClock:
            AnalogClockWidgetView()
        case .currentWorkspaceIndex:
            CurrentWorkspaceWidgetView(showIndex: true)
        case .currentWorkspaceLetter:
            CurrentWorkspaceWidgetView(showIndex: false)
        case .workspaceGrid:
            WorkspaceGridWidgetView()
        case .currentAerospaceMode:
            AerospaceModeWidgetView()
        case .battery:
            BatteryWidgetView(isInNotch: isInNotch)
        case .dateTime:
            DateTimeWidgetView()
        case .workspaces:
            WorkspacesWidgetView(isMenu: isMenu)
        case .aerospaceModes:
            AerospaceModeListWidgetView(isMenu: isMenu)
        case .network:
            NetworkWidget()
        case .keyboardLayout:
            KeyboardLayoutWidget()
        case .workspaceNext:
            WorkspaceSwitcherWidgetView(isSwitchNext: true)
        case .workspacePrev:
            WorkspaceSwitcherWidgetView(isSwitchNext: false)
        case .storageSmall:
            StorageSmallWidgetView()
        }
    }
}
