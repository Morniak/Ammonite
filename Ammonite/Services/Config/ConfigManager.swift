//
//  ConfigManager.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 19/06/2025.
//

import Foundation
import SwiftUI
import TOMLDecoder

final class ConfigManager: ObservableObject {
    
    @Published private(set) var config: Config = .default
    @Published private(set) var initError: String?
    
    /// Keep track of how many time the config as been loaded
    private(set) var configLoadCounter: Int = 0
    
    private var fileWatchSource: DispatchSourceFileSystemObject?
    private var fileDescriptor: CInt = -1
    private var configFilePath: String?
    
    init() {
        loadOrCreateConfigIfNeeded()
    }
}

// MARK: - Updates

extension ConfigManager {
    func update(command: Command) {
//        switch command {
//        case let .workspaceChange(name):
//            config.workspaces.update(current: name)
//        case let .workspaceChangeIndex(index):
//            config.workspaces.update(currentIndex: index)
//        case let .workspaces(workspaces, focused):
//            config.workspaces.update(workspaces: workspaces, focused: focused)
//        case let .aerospaceMode(mode):
//            config.aerospace.currentMode = mode
//        case let .aerospaceModes(modes, currentMode: currentMode):
//            config.aerospace.modes = modes
//            
//            if let currentMode {
//                config.aerospace.currentMode = currentMode
//            }
//        case let .widget(.leftBar, widgets):
//            config.widgets.leftBar = widgets.filter { $0 != .none }
//        case let .widget(.leftNotch, widgets):
//            config.widgets.leftNotch = widgets.first
//        case let .widget(.rightNotch, widgets):
//            config.widgets.rightNotch = widgets.first
//        case let .widget(.rightBar, widgets):
//            config.widgets.rightBar = widgets.filter { $0 != .none }
//        }
    }
}

// MARK: - Config file

private extension ConfigManager {
    
    func loadOrCreateConfigIfNeeded() {
        let homePath = FileManager.default.homeDirectoryForCurrentUser.path
        let path1 = "\(homePath)/.\(Constants.appName.lowercased()).toml"
        let path2 = "\(homePath)/.config/\(Constants.appName.lowercased())/config.toml"
        var chosenPath: String?
        
        if FileManager.default.fileExists(atPath: path1) {
            chosenPath = path1
        } else if FileManager.default.fileExists(atPath: path2) {
            chosenPath = path2
        } else {
            do {
                try createDefaultConfig(at: path1)
                chosenPath = path1
            } catch {
                initError = "Error creating default config: \(error.localizedDescription)"
                print("Error when creating default config:", error)
                return
            }
        }
        
        if let path = chosenPath {
            configFilePath = path
            parseConfigFile(at: path)
            startWatchingFile(at: path)
        }
    }
    
    func parseConfigFile(at path: String) {
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let decoder = TOMLDecoder()

            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let rootToml = try decoder.decode(RawConfig.self, from: content)
            DispatchQueue.main.async {
                self.configLoadCounter += 1
                self.config = Config(rawConfig: rootToml)
            }
        } catch {
            DispatchQueue.main.async {
                // TODO: - Display error
                self.initError = "Error parsing TOML file: \(error.localizedDescription)"
                print("Error when parsing TOML file:", error)
            }
        }
    }
    
    func createDefaultConfig(at path: String) throws {
        try defaultAmmoniteConfig.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    func startWatchingFile(at path: String) {
        fileDescriptor = open(path, O_EVTONLY)
        if fileDescriptor == -1 { return }
        fileWatchSource = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor, eventMask: .write,
            queue: DispatchQueue.global())
        fileWatchSource?.setEventHandler { [weak self] in
            guard let self = self, let path = self.configFilePath else {
                return
            }
            self.parseConfigFile(at: path)
        }
        fileWatchSource?.setCancelHandler { [weak self] in
            if let fd = self?.fileDescriptor, fd != -1 {
                close(fd)
            }
        }
        fileWatchSource?.resume()
    }
}
