//
//  NotchEffectModifier.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 25/06/2025.
//

import Foundation
import SwiftUI

struct NotchSide: OptionSet {
    let rawValue: UInt
    
    static let leading = NotchSide(rawValue: 1 << 0)
    static let trailing = NotchSide(rawValue: 1 << 1)
}

struct NotchEffectModifier: ViewModifier {
    
    static var outerNotchElementWidth: CGFloat = 5
    
    var side: NotchSide
    var height: CGFloat
    var cornerRadius: CGFloat
    var backgroundStyle: AnyShapeStyle
    
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            
            if side.contains(.leading) {
                ZStack {
                    Rectangle()
                    UnevenRoundedRectangle(topTrailingRadius: Self.outerNotchElementWidth, style: .circular)
                        .foregroundStyle(.black)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                .frame(width: 5, height: height)
                .foregroundStyle(backgroundStyle)
            }
            
            content
                .background(backgroundStyle)
                .mask {
                    if side.contains([.leading, .trailing]) {
                        UnevenRoundedRectangle(bottomLeadingRadius: cornerRadius, bottomTrailingRadius: cornerRadius)
                    } else if side.contains(.leading) {
                        UnevenRoundedRectangle(bottomLeadingRadius: cornerRadius, topTrailingRadius: cornerRadius)
                    } else if side.contains(.trailing) {
                        UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomTrailingRadius: cornerRadius)
                    }
                }
            
            if side.contains(.trailing) {
                ZStack {
                    Rectangle()
                    UnevenRoundedRectangle(topLeadingRadius: Self.outerNotchElementWidth)
                        .foregroundStyle(.black)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                .frame(width: 5, height: height)
                .foregroundStyle(backgroundStyle)
            }
        }
    }
}

extension View {
    func applyNotchEffect(side: NotchSide, height: CGFloat, cornerRadius: CGFloat, backgroundStyle: AnyShapeStyle) -> some View {
        self.modifier(NotchEffectModifier(side: side, height: height, cornerRadius: cornerRadius, backgroundStyle: backgroundStyle))
    }
}
