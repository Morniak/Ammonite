//
//  ItemListView.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 02/07/2025.
//

import SwiftUI

struct ItemListView: View {
    
    @EnvironmentObject var configManager: ConfigManager

    let items: [String]
    let style: ItemListStyle
    let showSeparators: Bool
    let isSelected: ((Int) -> Bool)
    let action: ((Int) -> Void)?

    var appearance: AppearanceConfig {
        configManager.config.appearance
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if showSeparators && index != 0 {
                    Divider()
                }
                
                Button {
                    action?(index)
                } label: {
                    switch style {
                    case .text:
                        Text(item)
                            .font(appearance.font.font())
                            .foregroundStyle(color(for: index))
                    case .box:
                        Text(item)
                            .font(appearance.font.resized(by: -2))
                            .padding(.horizontal, 4)
                            .box(shapeStyle: color(for: index))
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
    }
    
    func color(for itemIndex: Int) -> AnyShapeStyle {
        isSelected(itemIndex) ? appearance.primaryColor : appearance.secondaryColor
    }
}
