//
//  NotchView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 19/06/2025.
//

import Foundation
import SwiftUI
import Factory

struct NotchView: View {

    @EnvironmentObject var configManager: ConfigManager
    
    @InjectedObservable(\AmmoniteContainer.widgetsManager) var widgetsManager

    @State private var showLeadingMenu: Bool = false
    @State private var showTrailingMenu: Bool = false

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if !widgetsManager.isNotchEmpty {
                WidgetView(widget: widgetsManager.leftNotch, isInNotch: true, isMenu: false)
                    .frame(width: appearance.notchHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLeadingMenu.toggle()
                        }
                    }
            }
            
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: appearance.notchWidth)
            
            if !widgetsManager.isNotchEmpty {
                WidgetView(widget: widgetsManager.rightNotch, isInNotch: true, isMenu: false)
                    .frame(width: appearance.notchHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTrailingMenu.toggle()
                        }
                    }
            }
        }
        .padding(.vertical, 7)
        .frame(height: appearance.notchHeight)
        .applyNotchEffect(
            side: [.leading, .trailing],
            height: appearance.notchHeight,
            cornerRadius: appearance.notchCornerRadius,
            backgroundStyle: appearance.barBackgroundColor
        )
        .notchMenu(
            isPresented: $showLeadingMenu,
            alignment: .leading,
            content: {
                MenuView(widget: widgetsManager.leftNotch)
                    .padding(7)
                    .frame(height: appearance.notchHeight)
            }
        )
        .notchMenu(
            isPresented: $showTrailingMenu,
            alignment: .trailing,
            content: {
                MenuView(widget: widgetsManager.rightNotch)
                    .padding(7)
                    .frame(height: appearance.notchHeight)
            }
        )
    }
}
