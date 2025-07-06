//
//  WorkspaceChange.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

struct WorkspaceChange: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Update the focused workspace by its name.")
    
    @Argument(help: "The workspace name")
    var workspaceName: String
    
    func run() throws {
        guard !workspaceName.isEmpty else {
            throw ValidationError("Expected non-empty value for 'workspace_change' command.")
        }
        
        try postCommandNotification(command: .workspaceChange(workspaceName))
    }
}
