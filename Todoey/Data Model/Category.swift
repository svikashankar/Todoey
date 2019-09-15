    //
    //  Category.swift
    //  Todoey
    //
    //  Created by Vikass s on 13/09/19.
    //  Copyright © 2019 Chips PVT LTD. All rights reserved.
    //

    import Foundation
    import RealmSwift
    class  Category: Object {
        @objc dynamic var name: String = " "
        @objc dynamic var colour: String = ""
        let items = List<Item>()
    }
