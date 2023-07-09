//
//  Multiplayer_ClockTests.swift
//  Multiplayer ClockTests
//
//  Created by Devin Lehmacher on 7/7/23.
//

@testable import Multiplayer_Clock
import SnapshotTesting
import XCTest

final class Multiplayer_ClockTests: XCTestCase {
    func intersectionTest(ray: ((CGFloat, CGFloat), CGFloat), line: ((CGFloat, CGFloat), (CGFloat, CGFloat))) {
        let ray_ = Ray(origin: CGPoint(x: ray.0.0, y: ray.0.1), direction: .radians(ray.1))
        let line_ = Line(start: CGPoint(x: line.0.0, y: line.0.1), end: CGPoint(x: line.1.0, y: line.1.1))
        assertSnapshot(
            matching: line_.intersection(with: ray_),
            as: .json,
            named: "\(ray) intersection with \(line)"
        )
    }

    func testRayLineIntersection() throws {
        intersectionTest(ray: ((0, 0), .pi / 4), line: ((1, 0), (0, 1)))
        intersectionTest(ray: ((0, 0), .pi / 4), line: ((1, 0), (1, 2)))
        intersectionTest(ray: ((0, 0), 0), line: ((1, 1), (1, -1)))
        intersectionTest(ray: ((0, 0), .pi), line: ((-1, 1), (-1, -1)))
    }
}
