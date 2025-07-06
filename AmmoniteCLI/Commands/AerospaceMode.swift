//
//  AerospaceMode.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

struct AerospaceMode: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Update the aerospace mode.")
    
    @Argument(help: "The Aerospace mode")
    var mode: String
    
    func run() throws {
        try postCommandNotification(command: .aerospaceMode(mode))
    }
}
