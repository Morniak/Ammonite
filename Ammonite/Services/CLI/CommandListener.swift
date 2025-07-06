//
//  AmmoniteCommandListener.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 23/06/2025.
//

import Foundation
import Combine

final class CommandListener {
    
    private let commandSubject = PassthroughSubject<Command, Never>()
    
    var commandPublisher: AnyPublisher<Command, Never> {
        commandSubject.eraseToAnyPublisher()
    }
    
    init() {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDistributedCenter(),
            UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            { (center, observer, name, object, userInfo) in
                guard let name = name?.rawValue as String? else { return }
                let receiver = Unmanaged<CommandListener>.fromOpaque(observer!).takeUnretainedValue()
                receiver.handleNotification(name: name, userInfo: userInfo as? [AnyHashable: Any])
            },
            "AmmoniteCommand" as CFString,
            nil,
            .deliverImmediately
        )
    }
    
    deinit {
        CFNotificationCenterRemoveEveryObserver(
            CFNotificationCenterGetDistributedCenter(),
            UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
    }
    
    func handleNotification(name: String, userInfo: [AnyHashable: Any]?) {
        guard let userInfo = userInfo,
              let jsonString = userInfo["command"] as? String,
              let jsonData = jsonString.data(using: .utf8) else { return }
        
        let decoder = JSONDecoder()
        
        do {
            let command = try decoder.decode(Command.self, from: jsonData)
            commandSubject.send(command)
        } catch {
            print("Failed to decode command: \(error)")
        }
    }
}
