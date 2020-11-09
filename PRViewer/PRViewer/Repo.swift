//
//  Repo.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation

class Repo : NSObject {
    
    let name, fullName: String
    let htmlURL: String
    let welcomeDescription: String

    enum JsonKeys: String {
        case name
        case fullName = "full_name"
        case htmlURL = "html_url"
        case welcomeDescription = "description"
    }
    
    init(withDictionary dict : [String : Any]) {
        name = dict[JsonKeys.name.rawValue] as? String ?? ""
        fullName = dict[JsonKeys.fullName.rawValue] as? String ?? ""
        htmlURL = dict[JsonKeys.htmlURL.rawValue] as? String ?? ""
        welcomeDescription = dict[JsonKeys.welcomeDescription.rawValue] as? String ?? ""
    }
}
