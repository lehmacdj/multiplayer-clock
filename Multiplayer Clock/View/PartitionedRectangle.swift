//
//  PartitionedRectangle.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import SwiftUI

/// Partitions a rectangle radially separated by rays with the specified angles, coloring the partitions with the specified colors.
struct PartitionedRectangle<CenterView: View>: View {
    /// An array of increasing angles all less than 2π used to divide the rectangle into sections.
    let angles: [Angle]

    /// An array of `angles.count` colors assigned to partitions such that the last element of the array colors the partition between the last and first angle.
    let colors: [Color]

    /// Center from which to partition from
    let unitCenter: UnitPoint

    let centerView: CenterView

    let action: () -> Void

    init(angles: [Angle], colors: [Color], unitCenter: UnitPoint = .center, action: @escaping () -> Void = {}, centerView: @escaping () -> CenterView = { EmptyView() }) {
        assert(angles.count == colors.count && angles.sorted() == angles)
        self.angles = angles
        self.colors = colors
        self.unitCenter = unitCenter
        self.centerView = centerView()
        self.action = action
    }

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(
                x: unitCenter.x * geometry.size.width,
                y: unitCenter.y * geometry.size.height
            )
            let rays = angles.map { Ray(origin: center, direction: $0) }
            let rect = CGRect(origin: .zero, size: geometry.size)
            let intersections = rays.map { ray -> CGPoint in
                let intersections = rect.intersection(with: ray)
                // the ray should intersect exactly once because it is inside of the rectangle
                assert(
                    intersections.count == 1,
                    "\(ray) intersections with \(rect): \(intersections)"
                )
                return intersections[0]
            }

            let corners = [
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.minY),
            ]
            let cornerAngles = corners.map { corner -> Angle in
                let radians = atan2(corner.y - center.y, corner.x - center.x)
                return .radians(radians < 0 ? radians + 2 * .pi : radians)
            }

            ZStack {
                ForEach(0..<angles.count, id: \.hashValue) { ix1 in
                    let ix2 = (ix1 + 1) % angles.count
                    let angle1 = angles[ix1]
                    let angle2 = angles[ix2]
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: intersections[ix1])
                        for (cix, cornerAngle) in cornerAngles.enumerated() {
                            if cornerAngle > angle1 && (cornerAngle < angle2 || angle2 < angle1) {
                                path.addLine(to: corners[cix])
                            }
                        }
                        path.addLine(to: intersections[ix2])
                        path.closeSubpath()
                    }
                    .fill(colors[ix1])
                }

                Button(action: action) {
                    Color.clear
                }

                let actualCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                centerView.offset(x: center.x - actualCenter.x, y: center.y - actualCenter.y)
            }
        }
    }
}

struct PartitionedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        PartitionedRectangle(
            angles: [.radians(0), .radians(.pi / 2 - 0.2), .radians(4 * .pi / 3)],
            colors: [.red, .green, .blue],
            unitCenter: UnitPoint(x: 0.4, y: 0.6),
            action: {}
        ) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.black)
        }
        .ignoresSafeArea()
    }
}
