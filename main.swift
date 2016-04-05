/*
 This source file is part of the Swift.org open source project

 Copyright 2015 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

#if os(Linux)
import Glibc
srandom(UInt32(clock()))
#endif

import DeckOfPlayingCards

var deck = Deck.standard52CardDeck()
deck.shuffle()

for _ in 0..<deck.currentNumberOfCards() {
    guard let card = deck.deal() else {
        print("No More Cards!")
        break
    }

    print(card)
}
