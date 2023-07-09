//
//  ContentView.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct MainScreen<VM: ClockVM>: View {
    @StateObject var vm: VM

    @State private var resetWarningPresented = false
    @State private var isShowingSettings = false

    @ViewBuilder
    var controls: some View {
        Group {
            switch vm.state {
            case .unstarted:
                HStack {
                    IconButton(icon: .gear) { isShowingSettings = true }
                }
            case .running:
                HStack {
                    IconButton(icon: .pause, action: vm.pause)
                }
            case .paused:
                HStack {
                    IconButton(icon: .reset) { resetWarningPresented = true }
                    IconButton(icon: .gear) { isShowingSettings = true }
                }
            case .finished:
                HStack {
                    IconButton(icon: .reset) { resetWarningPresented = true }
                    IconButton(icon: .gear) { isShowingSettings = true }
                }
            }
        }
        .alert("Reset Clock?", isPresented: $resetWarningPresented) {
            Button("Reset", role: .destructive, action: vm.reset)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsScreen()
        }
    }

    var body: some View {
        VStack {
            controls
            ForEach(vm.players) { player in
                if (player.id == vm.currentPlayer) {
                    Text("\(player.time.description)")
                        .font(.largeTitle)
                } else {
                    Text("\(player.time.description)")
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
