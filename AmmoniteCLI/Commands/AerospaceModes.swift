//
//  AerospaceModes.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

struct AerospaceModes: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Update the list of available Aerospace modes.")
    
    @Argument(help: "The Aerospaces modes")
    var modes: [String]
    
    @Option(name: .shortAndLong, help: "The current Aerospace mode")
    var current: String?
    
    func run() throws {
        try postCommandNotification(command: .aerospaceModes(modes, currentMode: current))
    }
}
