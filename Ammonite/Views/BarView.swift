//
//  BarView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation
import SwiftUI
import Factory

struct BarView: View {

    let alignment: Alignment

    @InjectedObservable(\AmmoniteContainer.widgetsManager) var widgetsManager
    @InjectedObject(\AmmoniteContainer.configManager) var configManager

    var widgets: [Widget] {
        alignment == .leading ? widgetsManager.leftBar : widgetsManager.rightBar
    }
    
    @State private var showMenuForWidget: Widget? = nil

    private var isMenuPresented: Binding<Bool> {
        Binding<Bool>(
            get: { showMenuForWidget != nil },
            set: { newValue in
                if !newValue {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showMenuForWidget = nil
                    }
                }
            }
        )
    }
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var notchSide: NotchSide {
        if appearance.edgeCutoutEnabled {
            return [.leading, .trailing]
        } else if alignment == .leading {
            return [.trailing]
        } else {
            return [.leading]
        }
    }
    
    var xOffset: CGFloat {
        guard appearance.edgeCutoutEnabled else { return 0 }
        return alignment == .leading ? appearance.outerPadding : -appearance.outerPadding
    }
    
    var leadingInnerPadding: CGFloat {
        if alignment == .leading && !appearance.edgeCutoutEnabled {
            appearance.innerPadding + appearance.outerPadding
        } else {
            appearance.innerPadding
        }
    }
    
    var trailingInnerPadding: CGFloat {
        if alignment == .trailing && !appearance.edgeCutoutEnabled {
            appearance.innerPadding + appearance.outerPadding
        } else {
            appearance.innerPadding
        }
    }
    
    var body: some View {
        HStack(spacing: appearance.itemsSpacing) {
            ForEach(widgets.indices, id: \.self) { index in
                WidgetView(widget: widgets[index], isInNotch: false, isMenu: false)
                    .fixedSize(horizontal: true, vertical: false)
                    .onTapGesture { _ in
                        let tappedWidget = self.widgets[index]
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if showMenuForWidget != nil && showMenuForWidget == tappedWidget {
                                showMenuForWidget = nil
                            } else {
                                showMenuForWidget = tappedWidget
                            }
                        }
                    }
            }
        }
        .padding(.vertical, 7)
        .frame(height: appearance.notchHeight)
        .padding(.leading, leadingInnerPadding)
        .padding(.trailing, trailingInnerPadding)
        .applyNotchEffect(
            side: notchSide,
            height: appearance.notchHeight,
            cornerRadius: appearance.notchCornerRadius,
            backgroundStyle: appearance.barBackgroundColor
        )
        .notchMenu(
            isPresented: isMenuPresented,
            alignment: alignment == .leading ? .trailing : .leading,
            content: {
                MenuView(widget: showMenuForWidget)
                    .padding(7)
                    .frame(height: appearance.notchHeight)
            }
        )
        .offset(x: xOffset)
    }
}
