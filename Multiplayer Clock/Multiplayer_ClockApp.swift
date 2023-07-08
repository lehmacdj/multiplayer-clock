//
//  Multiplayer_ClockApp.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

@main
struct Multiplayer_ClockApp: App {
    @StateObject var settings = TransientSettings()

    var body: some Scene {
        WindowGroup {
            MainScreen(
                vm: FixedDecrementClockVM(
                    settings: settings,
                    decrement: .seconds(4)
                )
            )
            .environmentObject(settings)
        }
    }
}
