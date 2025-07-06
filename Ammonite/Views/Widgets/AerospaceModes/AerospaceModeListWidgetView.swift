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
    
    var aerospaceConfig: AerospaceConfig {
        configManager.config.aerospace
    }
    
    var showSeparators: Bool {
        (aerospaceConfig.showSeparatorsInMenu && isMenu) || (aerospaceConfig.showSeparatorsInWidget && !isMenu)
    }

    var body: some View {
        ItemListView(
            items: viewModel.modes,
            style: isMenu ? aerospaceConfig.menuStyle : aerospaceConfig.widgetStyle,
            showSeparators: showSeparators,
            isSelected: viewModel.isModeSelected(_:),
            action: viewModel.switchMode(_:)
        )
    }
}
