//
//  NotchMenuModifier.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import Foundation
import SwiftUI

struct NotchMenuModifier<MenuContent: View>: ViewModifier {
    
    @EnvironmentObject var configManager: ConfigManager

    let isPresented: Binding<Bool>
    let alignment: Alignment
    let menuContent: () -> MenuContent
    
    @State private var menuContentWidth: CGFloat = 0
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }

    func body(content: Content) -> some View {
        content
            .background(alignment: alignment) {
                HStack(spacing: 0) {
                    if alignment == .leading {
                        self.menuContent()
                            .fixedSize()
                            .readSize { size in
                                menuContentWidth = size.width
                            }
                        Color.clear
                            .frame(width: appearance.notchCornerRadius)
                    } else {
                        Color.clear
                            .frame(width: appearance.notchCornerRadius)
                        self.menuContent()
                            .fixedSize()
                            .readSize { size in
                                menuContentWidth = size.width
                            }
                    }
                }
                .frame(height: appearance.notchHeight)
                .applyNotchEffect(
                    side: alignment == .leading ? .leading : .trailing,
                    height: appearance.notchHeight,
                    cornerRadius: appearance.notchCornerRadius,
                    backgroundStyle: appearance.menuBackgroundColor
                )
                .alignmentGuide(alignment == .leading ? .leading : .trailing) {
                    alignment == .leading ? $0[.trailing] : $0[.leading]
                }
                .offset(
                    x: alignment == .leading
                    ? NotchEffectModifier.outerNotchElementWidth + appearance.notchCornerRadius
                    : -(NotchEffectModifier.outerNotchElementWidth + appearance.notchCornerRadius)
                )
                .offset(
                    x: isPresented.wrappedValue ? 0 :
                        (alignment == .leading ? menuContentWidth : -menuContentWidth)
                )
                .animation(.easeInOut(duration: 0.3), value: isPresented.wrappedValue)
                // When the menu is hidden, make sure it does not stick out on the other side
                .mask {
                    Rectangle()
                        .padding(.horizontal, -(NotchEffectModifier.outerNotchElementWidth + appearance.notchCornerRadius))
                }
            }
    }
}

extension View {
    func notchMenu<MenuContent: View>(
        isPresented: Binding<Bool>,
        alignment: Alignment,
        content: @escaping () -> MenuContent
    ) -> some View {
        self.modifier(NotchMenuModifier(
            isPresented: isPresented,
            alignment: alignment,
            menuContent: content
        ))
    }
}
