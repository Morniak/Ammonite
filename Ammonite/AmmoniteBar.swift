//
//  BarView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 16/06/2025.
//

import Foundation
import SwiftUI
import Combine
import Factory

// MARK: - View

struct AmmoniteBar: View {

    let container = AmmoniteContainer()

    @InjectedObject(\AmmoniteContainer.configManager) var configManager

    @State private var rootID = UUID()

    var body: some View {
        AmmoniteBarContent()
            .environmentObject(configManager)
            .id(rootID)
            .onChange(of: configManager.config) { old, new in
                if container.onConfigChanged(old: old, new: new) {
                    rootID = UUID()
                }
            }
    }
}
