//
//  NetworkMonitor.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import Network
import SwiftUI

final class NetworkMonitor: ObservableObject {
    @Published var isConnected = false
    @Published var isEthernet = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var symbolName: String {
        if !isConnected {
            return "wifi.slash"
        } else if isEthernet {
            return "cable.connector"
        } else {
            return "wifi"
        }
    }
    
    var connectionDescription: String {
        if !isConnected {
            return "Offline"
        } else if isEthernet {
            return "Ethernet"
        } else {
            return "Wi-Fi"
        }
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] (path: NWPath) in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                
                if path.usesInterfaceType(.wiredEthernet) {
                    self?.isEthernet = true
                } else {
                    self?.isEthernet = false
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
