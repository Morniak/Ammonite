//
//  StorageSmallWidgetView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 02/07/2025.
//

import SwiftUI

struct StorageSmallWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    @State private var viewModel = StoragesWidgetViewModel()

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var imageName: String {
        viewModel.devices.isEmpty ? "externaldrive.badge.xmark" : "externaldrive"
    }
    
    var body: some View {
        HStack(spacing: 3) {
            if !viewModel.devices.isEmpty {
                Text("\(viewModel.devices.count)")
                    .font(appearance.font.font())
            }
            Image(systemName: imageName)
                .symbolRenderingMode(.hierarchical)
                .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                .font(appearance.font.resized(by: 2))
        }
        .foregroundStyle(viewModel.devices.isEmpty ? appearance.secondaryColor : appearance.primaryColor)
        .onAppear() { viewModel.onAppear() }
    }
}
