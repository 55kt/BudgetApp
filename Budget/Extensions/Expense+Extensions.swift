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
    
}
