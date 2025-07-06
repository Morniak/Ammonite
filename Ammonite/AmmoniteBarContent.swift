//
//  AmmoniteBarContent.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 03/07/2025.
//

import SwiftUI
import Factory

struct AmmoniteBarContent: View {
    
    @InjectedObservable(\AmmoniteContainer.widgetsManager) var widgetsManager

    var body: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .center) {
                if !widgetsManager.leftBar.isEmpty {
                    BarView(alignment: .leading)
                        .fixedSize()
                }

                Spacer()

                if !widgetsManager.rightBar.isEmpty {
                    BarView(alignment: .trailing)
                        .fixedSize()
                }
            }
            .frame(maxWidth: .infinity)
            
            NotchView()
        }
        .frame(maxWidth: .infinity)
    }
}
