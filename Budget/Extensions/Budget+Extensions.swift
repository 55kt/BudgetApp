//
//  Budget+Extensions.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import Foundation
import CoreData

extension Budget {
    
    static func exists(context: NSManagedObjectContext, title: String) -> Bool {
        
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch  {
            return false
        }
        
    }
    
}
