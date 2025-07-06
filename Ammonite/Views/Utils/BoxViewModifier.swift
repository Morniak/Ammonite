//
//  BoxViewModifier.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI

struct BoxViewModifier: ViewModifier {
    let shapeStyle: AnyShapeStyle
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                .foregroundStyle(shapeStyle)
            
            content
                .blendMode(.destinationOut)
        }
        .compositingGroup()
    }
}

extension View {
    func box(shapeStyle: AnyShapeStyle) -> some View {
        self.modifier(BoxViewModifier(shapeStyle: shapeStyle))
    }
}
