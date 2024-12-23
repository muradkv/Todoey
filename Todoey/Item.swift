//
//  Item.swift
//  Todoey
//
//  Created by murad on 21.12.2024.
//

import Foundation

struct Item: Encodable, Decodable {
    var title: String
    var done: Bool
}
