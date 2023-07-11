//
//  DurationTests.swift
//  Multiplayer ClockTests
//
//  Created by Devin Lehmacher on 7/10/23.
//

@testable import Multiplayer_Clock
import XCTest

final class DurationTests: XCTestCase {
    func testTimeLeft() {
        XCTAssertEqual(
            (.minutes(150) + .seconds(12)).formatted(.timeLeft),
            "2:30:12"
        )
        XCTAssertEqual(
            (.minutes(99) + .seconds(59)).formatted(.timeLeft),
            "99:59"
        )
        XCTAssertEqual(
            (.minutes(5) + .seconds(17.3).formatted(.timeLeft),
            "5:17"
        )
        XCTAssertEqual(
            .seconds(17.310481084018).formatted(.timeLeft),
            "17.3"
        )
    }
}
