//
//  Widget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 20/06/2025.
//

enum Widget: String, Codable, CaseIterable, Equatable {
    
    // MARK: - Notch Widgets

    case digitalClock = "digital-clock"
    case analogClock = "analog-clock"
    case currentWorkspaceIndex = "current-workspace-index"
    case currentWorkspaceLetter = "current-workspace-letter"
    case workspaceGrid = "workspace-grid"
    case currentAerospaceMode = "current-aerospace-mode"
    case battery
    case network
    case keyboardLayout = "keyboard-layout"
    case workspaceNext = "workspace-next"
    case workspacePrev = "workspace-prev"
    case storageSmall = "storage-small"

    // TODO: - Add aerospaceLayout once aerospace have a layout callback

    // MARK: - Bar widgets
    
    case dateTime = "date-time"
    case workspaces = "workspaces"
    case aerospaceModes = "aerospace-modes"
    case separator

    // MARK: - Others
    
    /// Used by the CLI to remove widgets
    case none
}

// MARK: - Helpers

extension Widget {
    static var notchWidgets: [Widget] = [
        .digitalClock,
        .analogClock,
        .currentWorkspaceIndex,
        .currentWorkspaceLetter,
        .workspaceGrid,
        .currentAerospaceMode,
        .battery,
        .network,
        .keyboardLayout,
        .workspaceNext,
        .workspacePrev,
        .storageSmall
    ]
    
    static var barWidgets: [Widget] = Self.allCases.filter { $0 != .none }
    
    var isAllowedInNotch: Bool {
        Self.notchWidgets.contains(self)
    }
    
    var isStorage: Bool {
        self == .storageSmall
    }
}
