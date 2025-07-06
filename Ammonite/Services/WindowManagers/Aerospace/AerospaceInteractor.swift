//
//  AerospaceProvider.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 19/06/2025.
//

import Foundation
import Combine
import Factory

class AerospaceInteractor {
    enum Error: Swift.Error {
        case failedToReadOutput
        case expectedOutput
    }
    
    @Injected(\AmmoniteContainer.configManager) private var configManager
        
    // MARK: - Commands

    func switchToWorkspace(workspace: String) async throws {
        try await run(arguments: ["workspace", "--fail-if-noop", workspace], isExpectingOutput: false)
    }
    
    func switchToMode(mode: String) async throws {
        try await run(arguments: ["mode", mode], isExpectingOutput: false)
    }
}

// MARK: - Helpers

private extension AerospaceInteractor {
    @discardableResult
    func run(arguments: [String], isExpectingOutput: Bool = true) async throws -> Data? {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: configManager.config.aerospace.path)
        process.arguments = arguments
        process.standardOutput = pipe
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                try process.run()
                process.waitUntilExit()
                
                guard isExpectingOutput else {
                    return continuation.resume(returning: nil)
                }

                guard let data = try pipe.fileHandleForReading.readToEnd() else {
                    continuation.resume(throwing: Error.failedToReadOutput)
                    return
                }

                continuation.resume(returning: data)
            }
        }
    }
}

//extension AerospaceInteractor {
//
//    func fetchCurrentMode() async throws -> String {
//        guard let data = try await run(arguments: ["list-modes", "--current"]) else { throw Error.expectedOutput }
//        guard let name = String(data: data, encoding: .utf8) else { throw Error.failedToReadOutput }
//        return name
//    }
//
//    func fetchModes() async throws -> [String] {
//        guard let data = try await run(arguments: ["list-modes"]) else { throw Error.expectedOutput }
//        guard let str = String(data: data, encoding: .utf8) else { throw Error.failedToReadOutput }
//        return str.split(separator: "\n").map { String($0) }
//    }
//
//    func fetchSpaces() async throws -> [Workspace] {
//        let arguments = ["list-workspaces", "--monitor", "focused", "--format", "%{workspace}%{workspace-is-focused}", "--json"]
//        guard let data = try await run(arguments: arguments) else { throw Error.expectedOutput }
//        let jsonDecoder = JSONDecoder()
//        return try jsonDecoder.decode([Workspace].self, from: data)
//    }
//
//    func fetchCurrentSpace() async throws -> String {
//        guard let data = try await run(arguments: ["list-workspaces", "--focused"]) else { throw Error.expectedOutput }
//        guard let name = String(data: data, encoding: .utf8) else { throw Error.failedToReadOutput }
//        return name
//    }
//}
