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
            (.minutes(5) + .seconds(17.3)).formatted(.timeLeft),
            "5:17"
        )
        XCTAssertEqual(
            Duration.seconds(17.310481084018).formatted(.timeLeft),
            "17.3"
        )
        XCTAssertEqual(
            Duration.seconds(17.310481084018).formatted(.timeLeft(showTenthsOfASecond: false)),
            "17"
        )
        XCTAssertEqual(
            Duration.seconds(-77).formatted(.timeLeft),
            "-1:17"
        )
    }

    func testAppleMinuteSecondNegativeDurationTimeFormat() {
        XCTAssertEqual(
            Duration.seconds(-77).formatted(.time(pattern: .minuteSecond)),
            "-1:17",
            "Apple's .minuteSecond time format now correctly handles negative numbers"
        )
    }

    func testNegativeZeroNotShown() {
        // When showing tenths, -0.1 should display as "-0.1"
        XCTAssertEqual(
            Duration.seconds(-0.1).formatted(.timeLeft(showTenthsOfASecond: true)),
            "-0.1"
        )

        // When not showing tenths, values that round to 0 should display as "0", not "-0"
        XCTAssertEqual(
            Duration.seconds(-0.4).formatted(.timeLeft(showTenthsOfASecond: false)),
            "0"
        )
        XCTAssertEqual(
            Duration.seconds(-0.1).formatted(.timeLeft(showTenthsOfASecond: false)),
            "0"
        )

        // When showing tenths, values that round to 0.0 should display as "0.0", not "-0.0"
        XCTAssertEqual(
            Duration.seconds(-0.04).formatted(.timeLeft(showTenthsOfASecond: true)),
            "0.0"
        )

        // Positive zero should still be "0"
        XCTAssertEqual(
            Duration.seconds(0).formatted(.timeLeft(showTenthsOfASecond: false)),
            "0"
        )
        XCTAssertEqual(
            Duration.seconds(0).formatted(.timeLeft(showTenthsOfASecond: true)),
            "0.0"
        )
    }
}
