//
//  Category.swift
//  Todoey
//
//  Created by Shivam Rishi on 10/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colorHex : String = ""

    var items = List<Item>()
}
