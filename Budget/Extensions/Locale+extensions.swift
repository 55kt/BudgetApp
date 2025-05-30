//
//  Locale+extensions.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import Foundation

extension Locale {
    
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD" 
    }
    
}
