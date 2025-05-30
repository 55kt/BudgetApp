//
//  BudgetCellView.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            
            Spacer()
            
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
        }
    }
}
