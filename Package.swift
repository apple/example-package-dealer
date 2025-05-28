// swift-tools-version:5.10

/*
 This source file is part of the Swift.org open source project

 Copyright 2015 – 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import PackageDescription

let package = Package(
    name: "dealer",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "dealer",
                    targets: ["dealer"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/example-package-deckofplayingcards.git",
            from: "3.0.0"),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "0.4.4"),
    ],
    targets: [
        .executableTarget(
            name: "dealer",
            dependencies: [
                .product(name: "DeckOfPlayingCards",
                         package: "example-package-deckofplayingcards"),
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "DealerTests",
            dependencies: [
                .byName(name: "dealer")
            ]),
    ]
)
