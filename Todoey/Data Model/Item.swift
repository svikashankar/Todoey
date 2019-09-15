//
//  Item.swift
//  Todoey
//
//  Created by Vikass s on 13/09/19.
//  Copyright © 2019 Chips PVT LTD. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
