//
//  Storage.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 15.02.2024.
//

import Foundation

class Storage {
    public var accessToken: String = ""
    public var userData: User?
    static let sharedInstance = Storage()
}
