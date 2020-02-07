//
//  User.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//

import Foundation

struct User: Identifiable {
    let id = UUID().uuidString
    let name: String
    let imageProfile: String
    let colorName: String
}
