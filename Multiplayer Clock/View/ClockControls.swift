//
//  ClockControls.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import SwiftUI

struct ClockControls: View {
    let state: MultiplayerClock.State
    let play: () -> Void
    let pause: () -> Void
    let reset: () -> Void

    @State private var resetWarningPresented = false
    @State private var isShowingSettings = false
    @EnvironmentObject var settings: AnyWritableSettings

    var body: some View {
        Group {
            switch state {
            case .unstarted:
                HStack {
                    IconButton(icon: .gear) { isShowingSettings = true }
                }
            case .running:
                HStack {
                    IconButton(icon: .pause, action: pause)
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
            Button("Reset", role: .destructive, action: reset)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsScreen()
                .environmentObject(settings)
        }
    }
}

struct ClockControls_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(MultiplayerClock.State.allCases, id: \.self) { state in
                ClockControls(state: state, play: {}, pause: {}, reset: {})
            }
        }
        .environmentObject(TransientSettings().eraseToAnyWritableSettings())
    }
}
