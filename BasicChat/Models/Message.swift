//
//  Message.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let user: User
    let text: String
    let date: Date
}
