//
//  Category.swift
//  Todey
//
//  Created by lw-dlf on 3/26/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
