//
//  Command.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 23/06/2025.
//

enum Command: Codable {
    case workspaceChange(String)
    case workspaceChangeIndex(Int)
    case workspaces([String], focused: String?)
    case aerospaceMode(String)
    case aerospaceModes([String], currentMode: String?)
    case widget(WidgetPosition, [Widget])
}
