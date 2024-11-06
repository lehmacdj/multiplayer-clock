//
//  ComputedTimeDisplay.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 9/16/23.
//

import SwiftUI

private func rotation(forSide side: Int) -> Angle {
    switch side {
    case 0:
        return .zero
    case 1:
        return .radians(.pi / 2)
    case 2:
        return .radians(.pi)
    case 3:
        return .radians(3 * .pi / 2)
    default:
        fatalError("invalid side")
    }
}

private func size(forSide side: Int, long: CGFloat, short: CGFloat) -> CGSize {
    if side % 2 == 0 {
        return CGSize(width: long, height: short)
    } else {
        return CGSize(width: short, height: long)
    }
}

struct ComputedTimeDisplay<CenterView: View>: View {
    /// Which time is active and should be displayed more prominently
    let active: Int

    /// Durations to display
    let durations: [Duration]

    /// Maybe would be good to abstract this out so it's not included here
    let state: MultiplayerClock.State

    let centerView: CenterView

    let backgroundTapAction: () -> Void

    @EnvironmentObject var settings: AnySettings

    init(
        active: Int,
        durations: [Duration],
        state: MultiplayerClock.State,
        centerView: @escaping () -> CenterView = { EmptyView() },
        backgroundTapAction: @escaping () -> Void = {}
    ) {
        self.active = active
        self.durations = durations
        self.state = state
        self.centerView = centerView()
        self.backgroundTapAction = backgroundTapAction
    }

    private struct DurationConfiguration: Identifiable {
        let id = UUID()
        let duration: Duration
        let frame: CGSize
        let location: CGSize
        let angle: Angle

        init(duration: Duration, frame: CGSize, location: CGSize, angle: Angle) {
            self.duration = duration
            self.frame = frame
            self.location = location
            self.angle = angle
        }

        init(duration: Duration, frame: CGSize, location: CGSize, side: Int) {
            self.duration = duration
            self.frame = frame
            self.location = location
            self.angle = rotation(forSide: side)
        }
    }

    private var sideForHorizontalLayout: [Int] {
        []
    }

    private var sideForVerticalLayout: [Int] {
        switch durations.count {
        case 1:
            return [0]
        case 2:
            return [0, 2]
        case 3:
            return [0, 1, 2]
        case 4:
            return [0, 1, 2, 3]
        case 5:
            return [0, 1, 1, 2, 3]
        case 6:
            return [0, 1, 1, 2, 3, 3]
        default:
            fatalError("unsupported player count")
        }
    }

    private func durations(onSide side: Int, isHorizontal: Bool) -> Int {
        let sideCounts = isHorizontal ? sideForHorizontalLayout : sideForVerticalLayout
        return sideCounts
            .filter { $0 == side }
            .count
    }

    private func computeConfiguration(
        innerProxy: GeometryProxy,
        safeAreaProxy: GeometryProxy
    ) -> [DurationConfiguration] {
        let innerSize = innerProxy.size
        let safeAreaSize = safeAreaProxy.size
        let minimumDimension = min(innerSize.width, innerSize.height)
        // available space per side for the dimension that side spans
        var availableSpace = [innerSize.width, innerSize.height, innerSize.width, innerSize.height]

        let activeLongDimension = 3 * minimumDimension / 5
        let activeShortDimension = minimumDimension / 2
        let inactiveLongDimension = minimumDimension / 3
        let inactiveShortDimension = 3 * minimumDimension / 8

        var result = [DurationConfiguration]()

        let isHorizontal = innerSize.width > innerSize.height
        var sideForDuration = isHorizontal ? sideForHorizontalLayout : sideForVerticalLayout

        // place the active duration
        let activeSide = sideForDuration[active]
        var durationsOnActiveSide = durations(onSide: activeSide, isHorizontal: isHorizontal)

        switch durationsOnActiveSide {
        case 1:
            // TODO: fix (have correct value for both of these)
            fallthrough
        case 2:
            result.append(DurationConfiguration(
                duration: durations[active],
                frame: size(forSide: activeSide, long: activeLongDimension, short: activeShortDimension),
                location: CGSize(width: (innerProxy.size.width - activeLongDimension) / 2, height: safeAreaProxy.safeAreaInsets.top),
                side: activeSide
            ))
        default:
            fatalError("invalid number of sides")
        }

        // place the durations in smaller rectangles
        for durationIndex in active + 1..<active + durations.count {

        }

        return result
    }

    var body: some View {
        GeometryReader { safeAreaGeometry in
            GeometryReader { innerGeometry in
                ForEach(computeConfiguration(innerProxy: innerGeometry, safeAreaProxy: safeAreaGeometry)) { configuration in
                    Color.green.opacity(0.5)
                        .frame(width: configuration.frame.width, height: configuration.frame.height)
                        .rotationEffect(configuration.angle)
                        .offset(configuration.location)
                }
            }
            .border(Color.orange)
            .ignoresSafeArea()
        }
        .border(Color.red)
    }
}

struct ComputedTimeDisplay_Previews: PreviewProvider {
    @State static var settings = TransientSettings()

    static var previews: some View {
        ForEach(0..<(Constants.maxPlayerCount + 1), id: \.self) { n in
            ForEach(0..<n, id: \.self) { active in
                let clock = MultiplayerClock(
                    playerCount: n,
                    time: .minutes(5) + .seconds(55),
                    settings: settings.eraseToAnySettings()
                )
                ComputedTimeDisplay(
                    active: active,
                    durations: clock.players.map(\.time),
                    state: clock.state
                )
                .environmentObject(settings.eraseToAnySettings())
            }
        }
    }
}
