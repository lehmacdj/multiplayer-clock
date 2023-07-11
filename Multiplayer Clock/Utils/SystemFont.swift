//
//  SystemFont.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/10/23.
//

import SwiftUI

struct SystemFont: ViewModifier {
    @ScaledMetric var fontSize: CGFloat
    private let weight: Font.Weight

    init(size: CGFloat, relativeTo textStyle: Font.TextStyle, weight: Font.Weight = .regular) {
        _fontSize = ScaledMetric(wrappedValue: size, relativeTo: textStyle)
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize).weight(weight))
    }
}

extension View {
    func systemFont(
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        modifier(SystemFont(size: size, relativeTo: textStyle, weight: weight))
    }
}
