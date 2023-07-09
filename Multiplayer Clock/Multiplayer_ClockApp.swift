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
//            PartitionedRectangle(
//                angles: [.radians(0), .radians(.pi / 2), .radians(4 * .pi / 3)],
//                colors: [.red, .green, .blue]
//            )
            MainScreen(
                vm: FixedDecrementClockVM(
                    settings: settings.eraseToAnySettings(),
                    decrement: .seconds(4)
                )
            )
            .environmentObject(settings.eraseToAnySettings())
            .environmentObject(settings.eraseToAnyWritableSettings())
        }
    }
}
