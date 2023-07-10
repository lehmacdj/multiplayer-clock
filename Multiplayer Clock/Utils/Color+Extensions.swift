//
//  Color+Extensions.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import SwiftUI

extension Color {
    func saturation(_ saturationAdjustment: Double) -> Color {
        assert(saturationAdjustment >= 0 && saturationAdjustment <= 1)
        let uiColor = UIColor(self)
        var (h, s, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(hue: h, saturation: s * saturationAdjustment, brightness: b).opacity(a)
    }

    func brightness(_ brightnessAdjustment: Double) -> Color {
        assert(brightnessAdjustment >= 0 && brightnessAdjustment <= 1)
        let uiColor = UIColor(self)
        var (h, s, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(hue: h, saturation: s, brightness: b * brightnessAdjustment).opacity(a)
    }
}
