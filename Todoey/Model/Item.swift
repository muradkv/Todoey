//
//  Item.swift
//  Todoey
//
//  Created by murad on 02.09.2022.
//

import Foundation

class Item: Encodable {
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
        Item(title: "Hellloooo", done: false),
        Item(title: "Today is good day", done: false),
        Item(title: "I'm fine", done: false),
        Item(title: "Biblio", done: false),
        Item(title: "AppDelegate", done: false),
        Item(title: "Tequila", done: false),
        Item(title: "MainBase", done: false),
        Item(title: "About Atmosphere", done: false),
        Item(title: "ToDolist", done: false),
        Item(title: "Scene", done: false),
        Item(title: "Murmur", done: false),
        Item(title: "Quick Help", done: false),
        Item(title: "Baratrum", done: false),
        Item(title: "Gendalf", done: false),
        Item(title: "Thanksiamgood", done: false),
        Item(title: "LetsBeHonest", done: false),
        Item(title: "Sentemmber5", done: false),
        Item(title: "Catch-22", done: false),
        Item(title: "George Clooney", done: false),
        Item(title: "MaybeYouAreRight", done: false),
        Item(title: "GreatBritain", done: false),
        Item(title: "BadBad", done: false)
    ]
}
