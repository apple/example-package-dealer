/*
 This source file is part of the Swift.org open source project

 Copyright 2015 – 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

#if os(Linux)
import Glibc
srandom(UInt32(clock()))
#endif

import Foundation
import DeckOfPlayingCards
import ArgumentParser

var stdout = FileHandle.standardOutput
var stderr = FileHandle.standardError

struct Deal: ParsableCommand {
    static var configuration = CommandConfiguration(
            abstract: "Shuffles a deck of playing cards and deals a number of cards.",
            discussion: """
                Prints each card to stdout until the deck is completely dealt,
                and prints "No more cards" to stderr if there are no cards remaining.
                """)

    @Argument(help: "The number of cards to deal.")
    var count: UInt = 10

    mutating func run() throws {
        var deck = Deck.standard52CardDeck()
        deck.shuffle()

        for _ in 0..<count {
            guard let card = deck.deal() else {
                print("No more cards", to: &stderr)
                break
            }

            print(card, to: &stdout)
        }
    }
}

Deal.main()
