//
//  BatteryWidgetView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import SwiftUI
import Foundation

struct BatteryWidgetView: View {

    @EnvironmentObject var configManager: ConfigManager
    @ObservedObject var batteryInfo = BatteryInfo()
    
    let isInNotch: Bool
    
    var config: BatteryWidgetConfig {
        configManager.config.widgets.battery
    }
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        HStack(spacing: 3) {
            if config.showPercentage && !isInNotch {
                Text(String(format: "%.0f%%", batteryInfo.level * 100))
                    .contentTransition(.numericText())
                    .font(appearance.font.font())
            }
            
            Image(systemName: batterySymbolName(level: batteryInfo.level, isCharging: batteryInfo.isCharging))
                .symbolRenderingMode(.hierarchical)
                .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                .font(appearance.font.resized(by: 3))
        }
        .foregroundStyle(batteryColor(for: batteryInfo.level))
    }
    
    private func batterySymbolName(level: CGFloat, isCharging: Bool) -> String {
        if isCharging {
            return "battery.100percent.bolt"
        }
        
        return switch Int(level * 100) {
        case 95...100:
            "battery.100percent"
        case 75..<95:
            "battery.75percent"
        case 50..<75:
            "battery.50percent"
        case 25..<50:
            "battery.25percent"
        default:
            "battery.0percent"
        }
    }
    
    private func batteryColor(for level: CGFloat) -> AnyShapeStyle {
        guard !config.isMonochrome else {
            return configManager.config.appearance.primaryColor
        }

        let color = switch level {
        case ..<0.2:
            config.lowLevelColor
        case ..<0.5:
            config.mediumLevelColor
        default:
            config.highLevelColor
        }
        
        return AnyShapeStyle(Color(hex: color))
    }
}
