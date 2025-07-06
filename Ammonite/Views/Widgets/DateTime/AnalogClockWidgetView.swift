//
//  ClockWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation
import SwiftUI

struct AnalogClockWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        TimelineView(.everyMinute) { context in
            let date = context.date
            
            ZStack {
                Circle()
                    .stroke(appearance.primaryColor, lineWidth: 2)
                    .frame(width: 16, height: 16)
                
                ClockHand(length: 4, lineWidth: 1, color: appearance.primaryColor, angle: hourAngle(from: date))
                ClockHand(length: 6, lineWidth: 1, color: appearance.primaryColor, angle: minuteAngle(from: date))
            }
            .frame(width: 16, height: 16)
        }
    }
    
    private func hourAngle(from date: Date) -> Angle {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = Double(components.hour ?? 0) .truncatingRemainder(dividingBy: 12)
        let minute = Double(components.minute ?? 0)
        return Angle.degrees((hour / 12.0) * 360 + (minute / 60.0) * 30)
    }
    
    private func minuteAngle(from date: Date) -> Angle {
        let minute = Double(Calendar.current.component(.minute, from: date))
        return Angle.degrees(minute / 60 * 360)
    }
    
    private func secondAngle(from date: Date) -> Angle {
        let second = Double(Calendar.current.component(.second, from: date))
        return Angle.degrees(second / 60 * 360)
    }
}

private struct ClockHand: View {
    let length: CGFloat
    let lineWidth: CGFloat
    let color: AnyShapeStyle
    let angle: Angle
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: lineWidth, height: length)
            .offset(y: -length / 2)
            .rotationEffect(angle)
    }
}
