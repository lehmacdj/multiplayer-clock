//
//  ContentView.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct MainScreen<VM: ClockVM>: View {
    @StateObject var vm: VM

    var body: some View {
        VStack {
            ClockControls(state: vm.state, play: vm.play, pause: vm.pause, reset: vm.reset)
            ForEach(vm.players) { player in
                if (player.id == vm.currentPlayer) {
                    DurationLabel(duration: player.time)
                        .foregroundColor(.accentColor)
                } else {
                    DurationLabel(duration: player.time)
                }
            }
            .onTapGesture {
                switch vm.state {
                case .unstarted, .paused:
                    vm.play()
                case .running:
                    vm.switchToNextPlayer()
                case .finished:
                    break
                }
            }
        }
        .padding()
        .preventsDeviceSleeping()
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var settings = TransientSettings()

    static var previews: some View {
        MainScreen(
            vm: FixedDecrementClockVM(
                settings: settings.eraseToAnySettings(),
                decrement: .seconds(7)
            )
        )
        .environmentObject(settings.eraseToAnySettings())
        .environmentObject(settings.eraseToAnyWritableSettings())
    }
}
