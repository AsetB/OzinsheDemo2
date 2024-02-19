//
//  Genres.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import Foundation
import SwiftyJSON

class Genre {
    public var id: Int = 0
    public var name: String = ""
    public var link: String = ""
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["name"].string {
            self.name = data
        }
        if let data = json["link"].string {
            self.link = data
        }
    }
}
