//
//  ItemDidSelect.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 20.02.2024.
//

import Foundation

protocol ItemDidSelect: AnyObject {
    func movieDidSelect(movie: Movie)
    func genreDidSelect(genreID: Int, genreName: String)
    func ageDidSelect(ageID: Int, ageName: String)
}
