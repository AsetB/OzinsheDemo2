//
//  Movie.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import Foundation
import SwiftyJSON

class Movie {
    public var id: Int = 0
    public var movieType: String = ""
    public var name: String = ""
    public var keyWords: String = ""
    public var description: String = ""
    public var year: Int = 0
    public var trend: Bool = false
    public var timing: Int = 0
    public var director: String = ""
    public var producer: String = ""
    public var posterLink: String = ""
    public var videoLink: String = ""
    public var watchCount: Int = 0
    public var seasonCount: Int = 0
    public var seriesCount: Int = 0
    public var createdDate: String = ""
    public var lastModifiedDate: String = ""
    public var screenshots: [Screenshot] = []
    public var categoryAges: [CategoryAge] = []
    public var genres: [Genre] = []
    public var categories: [Category] = []
    public var favorite: Bool = false
    
    init() {
    }
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["movieType"].string {
            self.movieType = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["keyWords"].string {
            self.keyWords = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["year"].int {
            self.year = temp
        }
        if let temp = json["trend"].bool {
            self.trend = temp
        }
        if let temp = json["timing"].int {
            self.timing = temp
        }
        if let temp = json["director"].string {
            self.director = temp
        }
        if let temp = json["producer"].string {
            self.producer = temp
        }
        if json["poster"].exists() {
            if let temp = json["poster"]["link"].string {
                self.posterLink = temp
            }
        }
        if json["video"].exists() {
            if let temp = json["video"]["link"].string {
                self.videoLink = temp
            }
        }
        if let temp = json["watchCount"].int {
            self.watchCount = temp
        }
        if let temp = json["seasonCount"].int {
            self.seasonCount = temp
        }
        if let temp = json["seriesCount"].int {
            self.seriesCount = temp
        }
        if let temp = json["createdDate"].string {
            self.createdDate = temp
        }
        if let temp = json["lastModifiedDate"].string {
            self.lastModifiedDate = temp
        }
        if let array = json["screenshots"].array {
            for item in array {
                let temp = Screenshot(json: item)
                self.screenshots.append(temp)
            }
        }
        if let array = json["categoryAges"].array {
            for item in array {
                let temp = CategoryAge(json: item)
                self.categoryAges.append(temp)
            }
        }
        if let array = json["genres"].array {
            for item in array {
                let temp = Genre(json: item)
                self.genres.append(temp)
            }
        }
        if let array = json["categories"].array {
            for item in array {
                let temp = Category(json: item)
                self.categories.append(temp)
            }
        }
        if let temp = json["favorite"].bool {
            self.favorite = temp
        }
    }
}
