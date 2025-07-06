//
//  DateTimeWidgetView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation
import SwiftUI

struct DateTimeWidgetView: View {

    @EnvironmentObject var configManager: ConfigManager

    private static let formatter = DateFormatter()
    
    var config: DateTimeWidgetConfig? {
        configManager.config.widgets.dateTime
    }

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }

    var body: some View {
        TimelineView(.everyMinute) { context in
            Text(formattedDate(from: context.date))
        }
        .font(appearance.font.font())
        .foregroundStyle(appearance.primaryColor)
    }
    
    private func formattedDate(from date: Date) -> String {
        if let format = config?.format {
            Self.formatter.dateFormat = format
        } else {
            Self.formatter.dateStyle = .medium
        }
        
        Self.formatter.locale = config?.locale ?? .current

        return Self.formatter.string(from: date)
    }
}
