//
//  AddBudgetScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct AddBudgetScreen: View {
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var title: String = ""
    @State private var limit: Double?
    
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && limit != nil && Double(limit!) > 0
    }
    
    private func saveBudget() {
        
        let budget = Budget(context: context)
        budget.title = title
        budget.limit = limit ?? 0.0
        budget.dateCreated = Date()
        
        do {
            try context.save()
            errorMessage = ""
        } catch {
            errorMessage = "Unable to save budget"
        }
    }
    
    // MARK: - Body
    var body: some View {
        Form {
            Text("New Budget")
                .font(.title)
                .font(.headline)
            
            TextField("Title", text: $title)
                .presentationDetents([.medium])
            
            TextField("Limit", value: $limit, format: .number)
                .keyboardType(.numberPad)
            Button {
                if !Budget.exists(context: context, title: title) {
                    saveBudget()
                } else {
                    errorMessage = "Budget title already exists"
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
            Text(errorMessage)
        }// Form
    }// Body
}// View

// MARK: - Preview
#Preview {
    AddBudgetScreen()
        .environment(\.managedObjectContext, CoreDataProvider(inMemory: true).context)
}
