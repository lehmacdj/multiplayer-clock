//
//  ViewModifiers.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct PreventsDeviceSleeping: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

extension View {
    func preventsDeviceSleeping() -> some View {
        modifier(PreventsDeviceSleeping())
    }
}
