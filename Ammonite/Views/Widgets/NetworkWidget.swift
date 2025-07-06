//
//  NetworkWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI

struct NetworkWidget: View {
    
    @EnvironmentObject var configManager: ConfigManager
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }

    @StateObject private var monitor = NetworkMonitor()
    
    var body: some View {
        Image(systemName: monitor.isConnected ? monitor.symbolName : "wifi.slash")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(
                monitor.isConnected
                    ? appearance.primaryColor
                    : appearance.secondaryColor
            )
            .font(appearance.font.resized(by: 2))
            .onAppear {
                monitor.startMonitoring()
            }
            .onDisappear {
                monitor.stopMonitoring()
            }
    }
}
