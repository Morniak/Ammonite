//
//  DIContainer.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 03/07/2025.
//

import Factory

public final class AmmoniteContainer: SharedContainer {
    @TaskLocal public static var shared = AmmoniteContainer()
    public let manager = ContainerManager()
    
    @discardableResult
    func onConfigChanged(old: Config, new: Config) -> Bool {
        return false
//        switch config.windowManager {
//        case .yabai:
//            return true
//        case .aerospace:
//            return true
//        }
    }
}
