//
//  Data.swift
//  Todoey
//
//  Created by OUT-Koshelev-VO on 16.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
