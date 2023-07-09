//
//  TimeDisplay.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import SwiftUI

struct TimeDisplay: View {
    /// Which time is active and should be displayed more prominently
    let active: Int

    /// Durations to display
    let durations: [Duration]

    var body: some View {
        VStack {
            ForEach(0..<durations.count, id: \.self) { ix in
                let duration = durations[ix]
                if (ix == active) {
                    DurationLabel(duration: duration)
                        .foregroundColor(.accentColor)
                } else {
                    DurationLabel(duration: duration)
                }
            }
        }
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        let clock = MultiplayerClock(playerCount: 3, time: .seconds(17.3))
        TimeDisplay(active: clock.currentPlayer, durations: clock.players.map(\.time))
    }
}
