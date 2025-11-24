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
                Section {
                    Stepper(
                        "Player Count: \(settings.configuration.players.count)",
                        onIncrement: settings.addPlayer,
                        onDecrement: settings.removePlayer
                    )
                    Toggle("Count past zero?", isOn: $settings.countPastZero)
                    Toggle("Pause when backgrounding?", isOn: $settings.pauseClockWhenBackgrounding)
                    Toggle("Show tenths of a second?", isOn: $settings.showTenthsOfASecond)
                }

                Section {
                    Toggle("Different times for each player?", isOn: $settings.playerTimesIndividuallyConfigurable)
                    if !settings.playerTimesIndividuallyConfigurable {
                        NavigationLink("All Players: \(settings.allPlayersTime.wrappedValue.formatted(.units(allowed: [.minutes, .seconds])))") {
                            DurationPicker(duration: settings.allPlayersTime)
                                .navigationTitle("Time for All Players")
                        }
                    } else {
                        multiplayerTimeSelector
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    @ViewBuilder
    var multiplayerTimeSelector: some View {
        ForEach(Array(settings.playerTimes.enumerated()), id: \.0) { (index, time) in
            let player = "Player \(index + 1)"
            NavigationLink("\(player): \(time.wrappedValue.formatted(.units(allowed: [.minutes, .seconds])))") {
                DurationPicker(duration: time)
                    .navigationTitle("\(player)'s Time")
            }
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(TransientSettings().eraseToAnyWritableSettings())
    }
}
