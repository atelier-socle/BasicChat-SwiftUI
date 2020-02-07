//
//  FakeDatabase.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//

import Foundation

struct FakeDatabase {
    static let me = User(name: "Paul", imageProfile: "avatar.paul", colorName: "Blue")
    static let users = [User(name: "Julien", imageProfile: "avatar.julien", colorName: "Yellow"),
                        User(name: "Céline", imageProfile: "avatar.celine", colorName: "Red"),
                        User(name: "Marie", imageProfile: "avatar.marie", colorName: "Green")]

    static var messages = (0...20).compactMap { idx in
        (0...(1...50).randomElement()!).map { _ in "Hello" }.joined(separator: " ")
    }.enumerated().map {
        Message(user: $0.isMultiple(of: 3) ? me : users.randomElement()!, text: $1, date: Date())
    }
}
