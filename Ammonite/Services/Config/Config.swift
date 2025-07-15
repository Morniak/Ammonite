//
//  Config.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 16/06/2025.
//

import SwiftUI
import TOMLDecoder

struct Config: Equatable {
    let windowManager: WindowManager
    let workspaces: WorkspacesConfig
    let aerospace: AerospaceConfig
    let widgets: WidgetsConfig
    let appearance: AppearanceConfig
    
    static var `default` = Self.init(
        windowManager: .aerospace,
        workspaces: .default,
        aerospace: .default,
        widgets: .default,
        appearance: .default
    )
}

extension Config {
    init(rawConfig: RawConfig? = nil, default def: Config = .default) {
        self.windowManager = rawConfig?.windowManager ?? def.windowManager
        self.workspaces = rawConfig?.workspaces ?? def.workspaces
        self.aerospace = rawConfig?.aerospace ?? def.aerospace
        self.widgets = rawConfig?.widgets ?? def.widgets
        self.appearance = rawConfig?.appearance ?? def.appearance
    }
    
    // TODO: - Move to viewmodel
    func canPresentMenu(for widget: Widget) -> Bool {
        switch widget {
        case .currentWorkspaceIndex, .currentWorkspaceLetter, .workspaceGrid:
            return workspaces.workspaces.count > 1
        case .currentAerospaceMode:
            return aerospace.modesWidget.modes.count > 1
        case .storageSmall:
            return true
        case .digitalClock,
             .analogClock,
             .dateTime,
             .battery,
             .workspaces,
             .aerospaceModes,
             .network,
             .keyboardLayout,
             .separator,
             .workspaceNext,
             .workspacePrev,
             .none:
            return false
        }
    }
}

struct RawConfig: Decodable {
    let windowManager: WindowManager?
    let workspaces: WorkspacesConfig?
    let aerospace: AerospaceConfig?
    let widgets: WidgetsConfig?
    let appearance: AppearanceConfig?
}
