/*
 This source file is part of the Swift.org open source project

 Copyright 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest
import class Foundation.Bundle

final class DealerTests: XCTestCase {
    func testUsage() throws {
        let (status, output, error) = try execute(with: ["--help"])
        XCTAssertEqual(status, EXIT_SUCCESS)
        XCTAssert(output?.starts(with: "OVERVIEW: Shuffles a deck of playing cards and deals a number of cards.") ?? false)
        XCTAssertEqual(error, "")
    }

    func testDealOneCard() throws {
        let (status, output, error) = try execute(with: ["1"])
        XCTAssertEqual(status, EXIT_SUCCESS)
        XCTAssertEqual(output?.filter(\.isPlayingCardSuit).count, 1)

        XCTAssertEqual(error, "")
    }

    func testDealTenCards() throws {
        let (status, output, error) = try execute(with: ["10"])
        XCTAssertEqual(status, EXIT_SUCCESS)
        XCTAssertEqual(output?.filter(\.isPlayingCardSuit).count, 10)

        XCTAssertEqual(error, "")
    }

    func testDealThirteenCardsFourTimes() throws {
        let (status, output, error) = try execute(with: ["13", "13", "13", "13"])
        XCTAssertEqual(status, EXIT_SUCCESS)
        XCTAssertEqual(output?.filter(\.isPlayingCardSuit).count, 52)
        XCTAssertEqual(output?.filter(\.isNewline).count, 4)

        XCTAssertEqual(error, "")
    }

    func testDealOneHundredCards() throws {
        let (status, output, error) = try execute(with: ["100"])
        XCTAssertNotEqual(status, EXIT_SUCCESS)
        XCTAssertEqual(output, "")
        XCTAssertEqual(error, "Error: Not enough cards\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    private func execute(with arguments: [String] = []) throws -> (status: Int32, output: String?, error: String?) {
        let process = Process()
        process.executableURL = productsDirectory.appendingPathComponent("dealer")
        process.arguments = arguments

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        let errorPipe = Pipe()
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let status = process.terminationStatus

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)

        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errorData, encoding: .utf8)

        return (status, output, error)
    }
}

// MARK: -

private extension Character {
    var isPlayingCardSuit: Bool {
        switch self {
        case "♠︎", "♡", "♢", "♣︎":
            return true
        default:
            return false
        }
    }
}
