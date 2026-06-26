//
//  DataController-Awards.swift
//  UltimatePortfolio
//
//  Created by Stefan on 24.06.26.
//

import CoreData
import Foundation

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "issues":
            // certain nr of issues
            let fetchRequest = Issue.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "closed":
            // return true if they closed a certain nr of issues
            let fetchRequest = Issue.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "tags":
            // return true if they creqated a certain nr of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "unlock":
            return fullVersionUnlock
        default:
            // unknown award criterion; this should never be allowed
            // fatalError("Unknown criterion for award: \(award.criterion)")
            return false
        }
    }
}
