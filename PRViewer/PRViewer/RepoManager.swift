//
//  RepoManager.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation

class RepoManager : NSObject {
    
    static let shared = RepoManager()
    typealias successBlock  = () -> Void
    typealias failureBlock = () -> Void
    
    var pullRequests : [PullRequest] = []
    @objc dynamic var visiblePullRequests : [PullRequest] = []
    
    var timer = Timer()
    var lastSearchId : String = ""
    var lastFilter : FilterOptions = .all
    let userName = "danielgindi"
    let repository = "Charts"
    
    func initiateContent() {
        reloadAndUpdateData(true)
        timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.reloadAndUpdateData), userInfo: nil, repeats: true)
    }
    
    
    @objc func reloadAndUpdateData(_ isFirstUpdate : Bool = false) {
        
        pullRequests = []
        
        loadAllPRs {[weak self] in
            
            if self?.lastSearchId.count ?? 0 > 0 || self?.lastFilter != .all {
                self?.filteredList(forSearchKey: self?.lastSearchId ?? "", andFilter: self?.lastFilter ?? .all)
                
            } else {
                self?.visiblePullRequests = self?.pullRequests ?? []
                
            }
        } failure: {}
    }
    
    func loadAllPRs(withSuccess success : @escaping successBlock, failure : @escaping failureBlock) {
        
        let payload : [String:String] = [:]
        
        NetworkManager.shared.getData(withEndPoint: .allPRs(userName: userName, repoName: repository), payload: payload, success: {[weak self] data in
            do {
                if let prList = try JSONSerialization.jsonObject(with: data!) as?
                    [[String:Any]] {
                    for pr in prList {
                        if let newPR = try? PullRequest(withDictionary: pr) {
                            self?.pullRequests.append(newPR)
                        }
                    }
                    self?.sortPRs()
                    success()
                } else {
                    failure()
                }
            }  catch DecodingError.runtimeError(let errorMessage) {                print(errorMessage)
            } catch {
                print("error in parsing")
            }
            
        }) { _ in
            failure()
        }
    }
    
    func getNumberOfRors() -> Int {
        return visiblePullRequests.count
    }
    
    private func sortPRs() {
        self.pullRequests = pullRequests.sorted { a,b -> Bool in
            return (a.updatedAt ?? Date()) > (b.updatedAt ?? Date())
        }
    }
    
    func filteredList(forSearchKey key : String?, andFilter filter : FilterOptions?) {
        
        lastSearchId = key ?? lastSearchId
        lastFilter = filter ?? lastFilter
        if lastSearchId.count == 0 && lastFilter == .all {
            visiblePullRequests = pullRequests
            return
        }
        let filteredList = pullRequests.filter({ $0.ifFit(forFilter : lastFilter, andPRid : lastSearchId)})
        visiblePullRequests = filteredList
    }
    
    func getRepoPath() -> String {
        return userName + "/" + repository
    }
}

