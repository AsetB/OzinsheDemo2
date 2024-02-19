//
//  Screenshot.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import Foundation
import SwiftyJSON

class Screenshot {
    public var id: Int = 0
    public var link: String = ""
    
    init() {
    }
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["link"].string {
            self.link = data
        }
    }
    
}
