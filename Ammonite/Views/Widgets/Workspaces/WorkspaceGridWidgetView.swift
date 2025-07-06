//
//  WorkspaceGridView 2.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//


import Foundation
import SwiftUI

struct WorkspaceGridWidgetView: View {
    let spacing: CGFloat = 3
    let dotSize: CGFloat = 4
    
    @EnvironmentObject var configManager: ConfigManager
    @State private var viewModel = WorkspacesWidgetViewModel(isMenu: false)

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    private var count: Int {
        min(9, max(0, viewModel.workspaces.count))
    }
    
    private var columns: Int {
        Int(ceil(sqrt(Double(count))))
    }
    
    private var rows: Int {
        Int(ceil(Double(count) / Double(columns)))
    }
    
    var body: some View {
        Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        
                        if index < count {
                            Circle()
                                .animation(.easeOut, value: viewModel.currentIndex)
                                .foregroundStyle(
                                    index == viewModel.currentIndex
                                        ? appearance.primaryColor
                                        : appearance.secondaryColor
                                )
                                .frame(width: dotSize, height: dotSize)
                        } else {
                            Color.clear.frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
        }
    }
}
