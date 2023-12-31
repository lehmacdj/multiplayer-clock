//
//  Multiplayer_ClockApp.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

@main
struct Multiplayer_ClockApp: App {
    @StateObject var settings = UserDefaultsPersistedSettings()

    var body: some Scene {
        WindowGroup {
            MainScreen(vm: RealtimeClockVM(settings: settings.eraseToAnySettings()))
            .environmentObject(settings.eraseToAnySettings())
            .environmentObject(settings.eraseToAnyWritableSettings())
        }
    }
}
