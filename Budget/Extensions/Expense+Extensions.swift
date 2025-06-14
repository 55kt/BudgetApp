//
//  Expense+Extensions.swift
//  Budget
//
//  Created by Vlad on 4/6/25.
//

import Foundation
import CoreData

extension Expense {
    
    var total: Double {
        amount * Double(quantity)
    }
    
    static func exists(context: NSManagedObjectContext, title: String, budget: Budget) -> Bool {
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@ AND budget == %@", title, budget)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch  {
            return false
        }
        
    }
}
