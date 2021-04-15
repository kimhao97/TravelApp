//
//  User.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/13/21.
//

import Foundation

struct User: Codable {
    var id: Int
    var name: String?
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
