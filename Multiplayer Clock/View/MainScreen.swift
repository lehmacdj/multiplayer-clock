//
//  ContentView.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct MainScreen<VM: ClockVM>: View {
    @StateObject var vm: VM
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var settings: AnySettings

    var body: some View {
        ZStack {
            TimeDisplay(
                active: vm.currentPlayer,
                durations: vm.players.map(\.time),
                state: vm.state
            ) {
                ClockControls(state: vm.state, play: vm.play, pause: vm.pause, reset: vm.reset)
            } action: {
                switch vm.state {
                case .unstarted, .paused:
                    vm.play()
                case .running:
                    vm.switchToNextPlayer()
                case .finished:
                    break
                }
            }
            .ignoresSafeArea()
            .preventsDeviceSleeping()
            .onChange(of: scenePhase) {
                if $0 == .background && settings.pauseClockWhenBackgrounding {
                    vm.pause()
                }
            }
        }
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
