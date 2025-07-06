//
//  PostNotification.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

func postCommandNotification(command: Command) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(command)
    guard let jsonString = String(data: data, encoding: .utf8) else {
        throw ValidationError("Failed to encode command as UTF8 string")
    }
    
    DistributedNotificationCenter.default().post(
        name: Notification.Name("AmmoniteCommand"),
        object: nil,
        userInfo: ["command": jsonString]
    )
}
