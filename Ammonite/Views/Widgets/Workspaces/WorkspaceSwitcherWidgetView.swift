//
//  WorkspaceSwitcher.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI
import Factory

struct WorkspaceSwitcherWidgetView: View {

    let isSwitchNext: Bool

    @EnvironmentObject var configManager: ConfigManager

    @Injected(\AmmoniteContainer.workspaceSwitcher) var workspaceSwitcher
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var systemImage: String {
        isSwitchNext ? "arrowshape.right.fill" : "arrowshape.left.fill"
    }

    var body: some View {
        Button(action: onButtonTapped) {
            Image(systemName: systemImage)
                .symbolRenderingMode(.hierarchical)
                .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                .font(appearance.font.resized(by: 3))
                .foregroundStyle(appearance.primaryColor)
        }
        .buttonStyle(.scale)
    }
    
    func onButtonTapped() {
        if isSwitchNext {
            workspaceSwitcher.switchNext(wrapAround: false)
        } else {
            workspaceSwitcher.switchPrevious(wrapAround: false)
        }
    }
}
