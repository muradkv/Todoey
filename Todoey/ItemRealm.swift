//
//  Item.swift
//  Todoey
//
//  Created by murad on 28.12.2024.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date = Date()
    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property: "items")
}
