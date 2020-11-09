//
//  PullRequest.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation
import UIKit

enum PRState : String {
    case open, closed
}

class PullRequest : NSObject {
    
    let htmlURL: String
    let number: String
    let state: PRState
    let locked: Bool
    let title: String
    let createdBy: User?
    let body: String
    let createdAt, updatedAt, closedAt, mergedAt: Date?
    let head, base: Branch
    
    enum JsonKeys: String {
        
        case htmlURL = "html_url"
        case number, state, locked, title, user, body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case mergedAt = "merged_at"
        case head, base
    }
    
    init(withDictionary dict : [String : Any]) throws {
        
        guard let num = dict[JsonKeys.number.rawValue] as? Int, let prState = dict[JsonKeys.state.rawValue] as? String else {
            throw DecodingError.runtimeError("Invalid Data format")
        }
        
        htmlURL = dict[JsonKeys.htmlURL.rawValue] as? String ?? ""
        number = String(num)
        state = PRState.init(rawValue : prState) ?? .open
        locked = dict[JsonKeys.locked.rawValue] as? Bool ?? false
        title = dict[JsonKeys.title.rawValue] as? String ?? ""
        body = dict[JsonKeys.body.rawValue] as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        createdAt = dateFormatter.date(from: dict[JsonKeys.createdAt.rawValue] as? String ?? "")
        updatedAt = dateFormatter.date(from: dict[JsonKeys.updatedAt.rawValue] as? String ?? "")
        closedAt = dateFormatter.date(from: dict[JsonKeys.closedAt.rawValue] as? String ?? "")
        mergedAt = dateFormatter.date(from: dict[JsonKeys.mergedAt.rawValue] as? String ?? "")
        
        head = Branch.init(withDictionary : dict[JsonKeys.head.rawValue] as? [String : Any] ?? [:])
        base = Branch.init(withDictionary : dict[JsonKeys.base.rawValue] as? [String : Any] ?? [:])
        do {
            createdBy = try? User.init(withDictionary: dict[JsonKeys.user.rawValue] as? [String : Any] ?? [:])
        } catch DecodingError.runtimeError(let errorMessage) {
            print(errorMessage)
        } catch {
            print("error in parsing")
        }
    }
    
    func ifFit(forFilter filter : FilterOptions, andPRid id : String) -> Bool {
        if state.rawValue == filter.rawValue.lowercased() || filter == .all {
            if number.contains(id) || id.count == 0 {
                return true
            }
        }
        return false
    }
    
    func getInfoString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        switch state {
        case .open:
            var infoString = ", by " + (createdBy?.login ?? createdBy?.name ?? "")
            if let date = createdAt {
                infoString = "opened on " + dateFormatter.string(from: date) + infoString
            }
            return infoString
        default:
            if let mergeDate = mergedAt {
                let mergeAtDateString = dateFormatter.string(from: mergeDate)
                let mergeByString = (createdBy?.login ?? createdBy?.name ?? "")
                return "by " + mergeByString + ", was merged on " + mergeAtDateString
            } else {
                var infoString = " by " + (createdBy?.login ?? createdBy?.name ?? "")
                if let date = closedAt {
                    infoString = infoString + ", was closed on " + dateFormatter.string(from: date)
                }
                return infoString
            }
        }
    }
    
    func getPRSymbolImage() -> UIImage {

        switch state {
        case .open:
            return #imageLiteral(resourceName: "closed_open_icon")
        default:
            if mergedAt != nil {
                return #imageLiteral(resourceName: "merge_icon")
            } else {
                return #imageLiteral(resourceName: "closed_open_icon")
            }
        }
    }
    
    func getMergeStatusString() -> (String, String) {

        switch state {
        case .open:
            return ((createdBy?.login ?? createdBy?.name ?? ""), "wants to merge commits into")
        default:
            if mergedAt != nil {
                return ((createdBy?.login ?? createdBy?.name ?? ""), "merged commits into")
            } else {
                return ((createdBy?.login ?? createdBy?.name ?? ""), "wants to merge commits into")
            }
        }
    }
    
    func getDescriptionTitle() -> (String, String) {
        if let date = createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM, dd"
            return ((createdBy?.login ?? createdBy?.name ?? ""), "added comment on " + dateFormatter.string(from: date))
        }
        return ((createdBy?.login ?? createdBy?.name ?? ""), "added comment")
    }
    
    func getPRSymbolColor() -> UIColor {

        switch state {
        case .open:
            return PRViewerColors.open
        default:
            if mergedAt != nil {
                return PRViewerColors.merged
            } else {
                return PRViewerColors.closed
            }
        }
    }
    
    func getPRStatusString() -> String {

        switch state {
        case .open:
            return "Open"
        default:
            if mergedAt != nil {
                return "Merged"
            } else {
                return "Closed"
            }
        }
    }

}


class Branch : NSObject {
    let label, title: String
    let user: User?
    
    init(withDictionary dict : [String : Any]) {
        label = dict["label"] as? String ?? ""
        title = dict["ref"] as? String ?? ""
        do {
            user = try? User.init(withDictionary: dict["user"] as? [String : Any] ?? [:])
        } catch DecodingError.runtimeError(let errorMessage) {
            print(errorMessage)
        } catch {
            print("error in parsing")
        }
    }
    
}
