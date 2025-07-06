//
//  Workspaces.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

struct Workspaces: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Update the existing workspaces (and optionally the focused one).")
    
    @Argument(help: "The workspace list")
    var workspaces: [String]
    
    @Option(name: .shortAndLong, help: "The focused workspace")
    var focused: String?
    
    func run() throws {
        try postCommandNotification(command: .workspaces(workspaces, focused: focused))
    }
}
