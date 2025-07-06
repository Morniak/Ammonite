//
//  main.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 23/06/2025.
//

import Foundation
import ArgumentParser

struct AmmoniteCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "ammonite",
        abstract: "CLI to control Ammonite app",
        subcommands: [
            WorkspaceChange.self,
            WorkspaceChangeIndex.self,
            Workspaces.self,
            AerospaceMode.self,
            AerospaceModes.self,
            SetWidget.self
        ]
    )
}

AmmoniteCLI.main()
