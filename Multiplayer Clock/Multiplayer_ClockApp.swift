//
//  Multiplayer_ClockApp.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

@main
struct Multiplayer_ClockApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen(
                vm: FixedDecrementClockVM(
                    configuration: .init(playerCount: 4, time: .seconds(30)),
                    decrement: .seconds(4)
                )
            )
        }
    }
}
