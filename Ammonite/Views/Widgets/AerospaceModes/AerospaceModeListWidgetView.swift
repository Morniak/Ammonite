//
//  AerospaceModeMenu.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import Foundation
import SwiftUI

struct AerospaceModeListWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    @State private var viewModel = AerospaceModesWidgetViewModel()

    let isMenu: Bool
    
    var config: AerospaceModesWidgetConfig {
        configManager.config.aerospace.modesWidget
    }
    
    var showSeparators: Bool {
        (config.showSeparatorsInMenu && isMenu) || (config.showSeparatorsInWidget && !isMenu)
    }

    var body: some View {
        ItemListView(
            items: viewModel.modes,
            style: isMenu ? config.menuStyle : config.widgetStyle,
            showSeparators: showSeparators,
            isSelected: viewModel.isModeSelected(_:),
            action: viewModel.switchMode(_:)
        )
    }
}
