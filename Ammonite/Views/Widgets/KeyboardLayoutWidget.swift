//
//  KeyboardLayoutWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI

struct KeyboardLayoutWidget: View {
    @EnvironmentObject var configManager: ConfigManager
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    @StateObject private var monitor = KeyboardLayoutMonitor()
    
    var body: some View {
        Button(action: {
            monitor.cycleToNextLayout()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "keyboard")
                    .symbolRenderingMode(.hierarchical)
                    .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                    .font(appearance.font.resized(by: 2))

                Text(monitor.currentLayoutName)
            }
        }
        .buttonStyle(.plain)
        .font(appearance.font.font())
        .foregroundStyle(appearance.primaryColor)
        .onAppear {
            monitor.updateCurrentLayout()
        }
    }
}
