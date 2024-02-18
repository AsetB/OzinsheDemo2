//
//  Storage.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 15.02.2024.
//

import Foundation
import KeychainSwift

class Storage {
    public var accessToken: String = ""
    public var userData: User?
    static let sharedInstance = Storage()
}


final class AuthenticationService {
    
    public static let shared = AuthenticationService()
    
    private let keychain = KeychainSwift()
    private let key = "token"
    
    var token: String {
        get {
            keychain.get(key) ?? ""
        }
        set {
            keychain.set(newValue, forKey: key)
        }
    }
    
    var isAuthorized: Bool {
        !token.isEmpty
    }
    
    private init() {}
}
