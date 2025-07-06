//
//  StorageDeviceWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI
import Factory

struct StoragesWidgetView: View {
    
    @EnvironmentObject var configManager: ConfigManager
    @State private var viewModel = StoragesWidgetViewModel()

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var imageName: String {
        viewModel.devices.isEmpty ? "externaldrive.badge.xmark" : "externaldrive"
    }
    
    var body: some View {
//        HStack(spacing: 4) {
//            if viewModel.selectedDevice != nil {
//                Button(action: {
//                    viewModel.ejectSelectedDevice()
//                }) {
//                    Image(systemName: "eject.circle.fill")
//                        .symbolRenderingMode(.hierarchical)
//                        .contentTransition(.symbolEffect(.replace, options: .speed(2)))
//                        .font(appearance.font.resized(by: 2))
//                }
//                .buttonStyle(.plain)
//                .font(appearance.font.font())
//                .foregroundStyle(appearance.primaryColor)
//            }

            ItemListView(
                items: viewModel.devices,
                style: configManager.config.widgets.storageDevices.style,
                showSeparators: configManager.config.widgets.storageDevices.showSeparators,
                isSelected: viewModel.isDeviceSelected(_:),
                action: viewModel.onDeviceSelected(_:)
            )
//        }
        .onAppear(perform: viewModel.onAppear)
    }
}
