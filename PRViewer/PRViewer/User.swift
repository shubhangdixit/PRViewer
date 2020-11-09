//
//  User.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation

enum DecodingError : Error {
    case runtimeError(String)
}

class User : NSObject {
    
    let login: String
    let avatarURL: String
    let gravatarID: String
    let htmlURL: String
    let reposURL: String
    let type: String
    let name: String
    let company: String?
    let location: String?
    let publicRepos: Int
    let createdAt, updatedAt: Date?

    enum JsonKeys: String {
        case login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case htmlURL = "html_url"
        case reposURL = "repos_url"
        case type
        case name, company, location
        case publicRepos = "public_repos"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(withDictionary dict : [String : Any]) throws {
        
        guard let loginId = dict[JsonKeys.login.rawValue] as? String else {
            throw DecodingError.runtimeError("Invalid Data format")
        }
        login = loginId
        avatarURL = dict[JsonKeys.avatarURL.rawValue] as? String ?? ""
        gravatarID = dict[JsonKeys.gravatarID.rawValue] as? String ?? ""
        htmlURL = dict[JsonKeys.htmlURL.rawValue] as? String ?? ""
        reposURL = dict[JsonKeys.reposURL.rawValue] as? String ?? ""
        type = dict[JsonKeys.type.rawValue] as? String ?? ""
        name = dict[JsonKeys.name.rawValue] as? String ?? ""
        company = dict[JsonKeys.company.rawValue] as? String
        location = dict[JsonKeys.location.rawValue] as? String
        publicRepos = dict[JsonKeys.publicRepos.rawValue] as? Int ?? 0
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        createdAt = dateFormatter.date(from: dict[JsonKeys.createdAt.rawValue] as? String ?? "")
        updatedAt = dateFormatter.date(from: dict[JsonKeys.updatedAt.rawValue] as? String ?? "")
    }
}

