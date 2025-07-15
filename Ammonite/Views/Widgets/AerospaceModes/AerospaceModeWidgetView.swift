//
//  AerospaceModeWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 20/06/2025.
//

import Foundation
import SwiftUI

struct AerospaceModeWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    @State private var viewModel = AerospaceModesWidgetViewModel()

    var aerospaceConfig: AerospaceConfig {
        configManager.config.aerospace
    }
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        if let systemImage = aerospaceConfig.modesWidget.icons[viewModel.current] {
            Image(systemName: systemImage)
                .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                .foregroundStyle(appearance.primaryColor)
                .frame(alignment: .center)
                .font(appearance.font.resized(by: 4))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(appearance.primaryColor)
                
                Text(viewModel.current.prefix(1).uppercased())
                    .frame(alignment: .center)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            .font(appearance.font.resized(by: 1))
            .aspectRatio(1, contentMode: .fit)
        }
    }
}
