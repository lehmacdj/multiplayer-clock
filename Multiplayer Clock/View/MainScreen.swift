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

    @ViewBuilder
    var controls: some View {
        Group {
            switch vm.state {
            case .unstarted:
                HStack {
                    IconButton(icon: .gear)
                }
            case .running:
                HStack {
                    IconButton(icon: .pause, action: vm.pause)
                }
            case .paused:
                HStack {
                    IconButton(icon: .reset, action: { resetWarningPresented = true })
                    IconButton(icon: .gear)
                }
            case .finished:
                HStack {
                    IconButton(icon: .reset, action: { resetWarningPresented = true })
                    IconButton(icon: .gear)
                }
            }
        }
        .alert("Reset Clock?", isPresented: $resetWarningPresented) {
            Button("Reset", role: .destructive) {
                vm.reset()
                resetWarningPresented = false
            }
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
    static var previews: some View {
        MainScreen(
            vm: FixedDecrementClockVM(
                configuration: .init(
                    playerCount: 4,
                    time: .seconds(30)
                ),
                decrement: .seconds(7)
            )
        )
    }
}
