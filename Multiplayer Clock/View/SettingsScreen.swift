//
//  SettingsScreen.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var settings: AnyWritableSettings

    var body: some View {
        NavigationView {
            Form {
                Stepper(
                    "Player Count: \(settings.configuration.players.count)",
                    onIncrement: settings.addPlayer,
                    onDecrement: settings.removePlayer
                )
                Toggle("Separate player times?", isOn: $settings.playerTimesIndividuallyConfigurable)
                    .disabled(true)
                Toggle("Count past zero?", isOn: $settings.countPastZero)
                Toggle("Pause when backgrounding?", isOn: $settings.pauseClockWhenBackgrounding)
                Toggle("Show tenths of a second?", isOn: $settings.showTenthsOfASecond)

                Section {
                    if !settings.playerTimesIndividuallyConfigurable {
                        NavigationLink("All Players: \(settings.allPlayersTime.wrappedValue.formatted(.units(allowed: [.minutes, .seconds])))") {
                            DurationPicker(duration: settings.allPlayersTime)
                                .navigationTitle("Time for All Players")
                        }
                    } else {
                        Text("Separate player times not yet implemented")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(TransientSettings().eraseToAnyWritableSettings())
    }
}
