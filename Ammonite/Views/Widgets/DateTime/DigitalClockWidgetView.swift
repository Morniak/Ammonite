//
//  TimeWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 20/06/2025.
//

import Foundation
import SwiftUI

struct DigitalClockWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        TimelineView(.everyMinute) { context in
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: context.date)
            
            VStack(spacing: 0) {
                if let hour = timeComponents.hour {
                    Text("\(hour)")
                }
                Divider()
                    .padding(.horizontal, 5)
                if let minute = timeComponents.minute {
                    Text("\(minute)")
                }
            }
            .font(appearance.font.resized(by: -2))
            .fontDesign(.monospaced)
            .lineSpacing(0)
            .foregroundStyle(appearance.primaryColor)
        }
    }
}
