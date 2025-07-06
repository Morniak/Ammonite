//
//  WorkspaceChangeIndex.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

struct WorkspaceChangeIndex: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Update the focused workspace by its index.")
    
    @Argument(help: "The workspace index")
    var index: Int
    
    func run() throws {
        guard index > 0 else {
            throw ValidationError("Expected non-negative value for 'workspace_change_index' command.")
        }
        
        try postCommandNotification(command: .workspaceChangeIndex(index))
    }
}
