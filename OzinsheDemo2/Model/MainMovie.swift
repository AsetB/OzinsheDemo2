//
//  MainMovie.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import Foundation
import SwiftyJSON

enum CellType {
    case mainBanner
    case mainMovie
    case userHistory
    case genre
    case ageCategory
}

class MainMovies {
    var categoryId: Int = 1
    var categoryName: String = ""
    var movies: [Movie] = []
    
    var bannerMovie: [BannerMovie] = []
    var cellType: CellType = .mainMovie
    var categoryAges: [CategoryAge] = []
    var genres: [Genre] = []
    
    init() {
        
    }
    
    init(json: JSON) {
        if let data = json["categoryId"].int {
            self.categoryId = data
        }
        if let data = json["categoryName"].string {
            self.categoryName = data
        }
        if let array = json["movies"].array {
            for item in array {
                let temp = Movie(json: item)
                self.movies.append(temp)
            }
        }
    }
}
