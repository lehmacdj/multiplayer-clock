//
//  TimeDisplay.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import SwiftUI

private let allColors: [Color] = [
    .purple,
    .blue,
    .green,
    .yellow,
    .orange,
    .red
]

struct TimeDisplay: View {
    /// Which time is active and should be displayed more prominently
    let active: Int

    /// Durations to display
    let durations: [Duration]

    var angles: [Angle] {
        let fractions: [Double]
        switch durations.count {
        case 1:
            fractions = [0.0]
        case 2:
            fractions = [0.0, 0.5]
        case 3:
            fractions = [0.0, 1.0/3.0, 2.0/3.0]
        case 4:
            fractions = [0.0, 0.25, 0.5, 0.75]
        case 5:
            fractions = [0.0, 0.2, 0.4, 0.6, 0.8]
        case 6:
            fractions = [0.0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0]
        default:
            fatalError("invalid number of angles provided")
        }

        var angles = [Angle]()
        for i in 0..<durations.count {
            angles.append(.radians(2 * .pi * Double(i) / Double(durations.count)))
        }
        return angles
    }

    var colors: [Color] {
        var colors = [Color]()
        for i in 0..<durations.count {
            let newColor: Color = allColors[i]
            colors.append(newColor)
        }
        return colors
    }

    var body: some View {
        ZStack {
//            PartitionedRectangle(angles: angles, colors: colors)
//                .ignoresSafeArea()
            VStack {
                ForEach(0..<durations.count, id: \.self) { ix in
                    let duration = durations[ix]
                    if (ix == active) {
                        Text(duration.formatted(.timeLeft))
                            .foregroundColor(.accentColor)
                    } else {
                        Text(duration.formatted(.timeLeft))
                    }
                }
            }
        }
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        let clock = MultiplayerClock(playerCount: 6, time: .seconds(17.3))
        TimeDisplay(active: 4, durations: clock.players.map(\.time))
    }
}
