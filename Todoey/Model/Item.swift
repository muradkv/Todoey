//
//  Item.swift
//  Todoey
//
//  Created by murad on 02.09.2022.
//

import Foundation

class Item {
    var title: String
    var done: Bool
    
    init() {
        self.title = ""
        self.done = false
    }
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}

class ItemList {
    static var allValues = [
        Item(title: "Food", done: false),
        Item(title: "Mood", done: false),
        Item(title: "Good", done: false)
    ]
}
