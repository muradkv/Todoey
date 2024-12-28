//
//  Category.swift
//  Todoey
//
//  Created by murad on 28.12.2024.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @objc dynamic var name: String = ""
    let items = List<ItemRealm>()
}
