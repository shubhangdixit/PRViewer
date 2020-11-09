//
//  NetworkManager.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation

public enum GITAPIEndPoint {
    case checkUser(userName : String)
    case checkRepo(userName : String, repoName : String)
    case allPRs(userName : String, repoName : String)
    case allRepos(repoName : String)
    
    func urlString() -> String {
        switch self {
        case .checkUser(let userName):
            return "https://api.github.com/users/\(userName)"
        case .checkRepo(let userName, let repoName):
            return "https://api.github.com/repos/\(userName)/\(repoName)/"
        case .allRepos(let userName):
            return "https://api.github.com/users/\(userName)/repos"
        case .allPRs(let userName, let repoName):
            return "https://api.github.com/repos/\(userName)/\(repoName)/pulls?state=all"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    typealias successBlock  = (Data?) -> Void
    typealias failureBlock = (Error?)-> Void
    
    func getData(withEndPoint type : GITAPIEndPoint, payload : [String : String], success: @escaping successBlock, failure: @escaping failureBlock) {
        
        performRequest(forUrl: type.urlString(), requestType: "GET", success: { data in
            success(data)
        }) { error in
            failure(error)
        }
    }
    
    func performRequest(forUrl url : String, requestType : String, success: @escaping successBlock, failure: @escaping failureBlock) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = requestType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let apiError = error {
                failure(apiError)
            } else {
                if let result = data {
                    success(result)
                }
            }
        })
        task.resume()
    }
}
