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

struct TimeDisplay<CenterView: View>: View {
    /// Which time is active and should be displayed more prominently
    let active: Int

    /// Durations to display
    let durations: [Duration]

    /// Maybe would be good to abstract this out so it's not included here
    let state: MultiplayerClock.State

    let centerView: CenterView

    let action: () -> Void

    init(active: Int, durations: [Duration], state: MultiplayerClock.State, centerView: @escaping () -> CenterView = { EmptyView() }, action: @escaping () -> Void = {}) {
        self.active = active
        self.durations = durations
        self.state = state
        self.centerView = centerView()
        self.action = action
    }

    private struct Configuration {
        let unitCenter: UnitPoint
        let fractions: [Double]
        let labelPositions: [(x: CGFloat, y: CGFloat, angle: Angle)]
    }

    /// Map a count of durations we're displaying and an active duration, to a center point
    /// and an angle
    /// Note: because `(Int, Int): ~Hashable` at the moment we use `[Int]` as a workaround
    /// Note: this whole thing is basically a giant workaround till I get around to implementing a
    /// fancy algorithm that optimizes for a just sufficiently large box for the duration for each
    /// partition. That algorithm would most likely optimize solutions that give the non-active
    /// cells sufficient space by some weighted sum of:
    /// * variation from default angle
    /// * center point variation
    /// * total space given to active cell
    /// * even-ness of the total space given to non-active cells
    /// This kind of algorthm is necessary because otherwise it would be far too tedious /
    /// inconsistent / error-prone to come up with layouts for every possible device / orientation
    private let configurations: [[Int]: Configuration] = [
        [1, 0]: Configuration(
            unitCenter: UnitPoint(x: 0.5, y: 0.2),
            fractions: [0],
            labelPositions: [
                (x: 0.5, y: 0.6, angle: .zero),
            ]
        ),
        [2, 0]: Configuration(
            unitCenter: UnitPoint(x: 0.5, y: 0.3),
            fractions: [0, 0.5],
            labelPositions: [
                (x: 0.5, y: 0.65, angle: .zero),
                (x: 0.5, y: 0.18, angle: .radians(.pi)),
            ]
        ),
        [2, 1]: Configuration(
            unitCenter: UnitPoint(x: 0.5, y: 0.7),
            fractions: [0, 0.5],
            labelPositions: [
                (x: 0.5, y: 0.85, angle: .zero),
                (x: 0.5, y: 0.35, angle: .radians(.pi)),
            ]
        ),
        [3, 0]: Configuration(
            unitCenter: UnitPoint(x: 0.45, y: 0.3),
            fractions: [0, 1.0/3.0, 2.0/3.0],
            labelPositions: [
                (x: 0.5, y: 0.65, angle: .zero),
                (x: 0.18, y: 0.30, angle: .radians(.pi / 2)),
                (x: 0.65, y: 0.18, angle: .radians(.pi)),
            ]
        ),
        [3, 1]: Configuration(
            unitCenter: UnitPoint(x: 0.8, y: 0.5),
            fractions: [0, 0.35, 0.65],
            labelPositions: [
                (x: 0.7, y: 0.85, angle: .zero),
                (x: 0.35, y: 0.5, angle: .radians(.pi / 2)),
                (x: 0.7, y: 0.18, angle: .radians(.pi)),
            ]
        ),
        [3, 2]: Configuration(
            unitCenter: UnitPoint(x: 0.45, y: 0.7),
            fractions: [0, 1.0/3.0, 2.0/3.0],
            labelPositions: [
                (x: 0.65, y: 0.85, angle: .zero),
                (x: 0.18, y: 0.7, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.3, angle: .radians(.pi)),
            ]
        ),
        [4, 0]: Configuration(
            unitCenter: UnitPoint(x: 0.3, y: 0.3),
            fractions: [0, 0.25, 0.5, 0.75],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [4, 1]: Configuration(
            unitCenter: UnitPoint(x: 0.7, y: 0.3),
            fractions: [0, 0.25, 0.5, 0.75],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [4, 2]: Configuration(
            unitCenter: UnitPoint(x: 0.3, y: 0.7),
            fractions: [0, 0.25, 0.5, 0.75],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [4, 3]: Configuration(
            unitCenter: UnitPoint(x: 0.7, y: 0.7),
            fractions: [0, 0.25, 0.5, 0.75],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [5, 0]: Configuration(
            unitCenter: UnitPoint(x: 0.37, y: 0.32),
            fractions: [0, 0.25, 0.33, 0.62, 0.8],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [5, 1]: Configuration(
            unitCenter: UnitPoint(x: 0.6, y: 0.35),
            fractions: [0, 0.2, 0.42, 0.6, 0.8],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [5, 2]: Configuration(
            unitCenter: UnitPoint(x: 0.67, y: 0.5),
            fractions: [0, 0.2, 0.3, 0.7, 0.8],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [5, 3]: Configuration(
            unitCenter: UnitPoint(x: 0.6, y: 0.65),
            fractions: [0, 0.2, 0.4, 0.58, 0.8],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        [5, 4]: Configuration(
            unitCenter: UnitPoint(x: 0.37, y: 0.68),
            fractions: [0, 0.2, 0.38, 0.67, 0.75],
            labelPositions: [
                (x: 0.5, y: 0.1, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.4, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.7, angle: .radians(3 * .pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
                (x: 0.5, y: 0.9, angle: .radians(.pi / 2)),
            ]
        ),
        // TODO: durations.count == 6
        [6, 0]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
        [6, 1]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
        [6, 2]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
        [6, 3]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
        [6, 4]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
        [6, 5]: Configuration(
            unitCenter: .center,
            fractions: [0, 1.0/6.0, 1.0/3.0, 0.5, 2.0/3.0, 5.0/6.0],
            labelPositions: []
        ),
    ]

    var unitPoint: UnitPoint {
        guard let configuration = configurations[[durations.count, active]] else {
            fatalError("invalid configuration: \(durations.count) \(active)")
        }

        return configuration.unitCenter
    }

    var angles: [Angle] {
        guard let configuration = configurations[[durations.count, active]] else {
            fatalError("invalid configuration: \(durations.count) \(active)")
        }

        return configuration.fractions.map { Angle(radians: $0 * 2 * .pi) }
    }

    var colors: [Color] {
        var colors = [Color]()
        for i in 0..<durations.count {
            let newColor: Color = allColors[i]
            colors.append(newColor)
        }
        return colors
    }

    func labelPositions(_ geometry: GeometryProxy) -> [(dx: CGFloat, dy: CGFloat, angle: Angle)] {
        guard let configuration = configurations[[durations.count, active]] else {
            fatalError("invalid configuration: \(durations.count) \(active)")
        }

        let actualCenter = CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
        return configuration.labelPositions.map { labelPosition in
            let actualLabelPosition = (x: geometry.size.width * labelPosition.x, y: geometry.size.height * labelPosition.y)
            let dx = actualLabelPosition.x - actualCenter.x
            let dy = actualLabelPosition.y - actualCenter.y
            return (dx: dx, dy: dy, angle: labelPosition.angle)
        }

    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if durations.count == 1 {
                    Color.purple
                }

                PartitionedRectangle(
                    angles: angles,
                    colors: colors,
                    unitCenter: unitPoint,
                    action: action
                ) {
                    centerView.zIndex(.infinity)
                }

                let labelPositions = labelPositions(geometry)
                ForEach(0..<durations.count, id: \.self) { ix in
                    let duration = durations[ix]
                    let labelPosition = labelPositions[ix]
                    Text(duration.formatted(.timeLeft))
                        .systemFont(size: 72, relativeTo: .largeTitle)
                        .rotationEffect(labelPosition.angle)
                        .offset(x: labelPosition.dx, y: labelPosition.dy)
                        .allowsHitTesting(false)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(0..<(Constants.maxPlayerCount + 1), id: \.self) { n in
            ForEach(0..<n, id: \.self) { active in
                let clock = MultiplayerClock(playerCount: n, time: .seconds(17.3))
                TimeDisplay(
                    active: active,
                    durations: clock.players.map(\.time),
                    state: clock.state
                )
            }
        }
    }
}
