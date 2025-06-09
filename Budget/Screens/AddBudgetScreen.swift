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
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var limit: Double?
    
    @State private var errorMessage: String = ""
    
    /// --Field Validation
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && limit != nil && Double(limit!) > 0
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
                    dismiss()
                } else {
                    errorMessage = "Budget title already exists"
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
            /// -- ErrorMessage
            Text(errorMessage)
        }// Form
    }// Body
    
    // MARK: - Methods
    private func saveBudget() {
        
        let budget = Budget(context: context)
        budget.title = title
        budget.limit = limit ?? 0.0
        budget.dateCreated = Date()
        
        do {
            try context.save()
            errorMessage = ""
            dismiss()
        } catch {
            errorMessage = "Unable to save budget"
        }
    }
    
}// View

// MARK: - Preview
#Preview {
    AddBudgetScreen()
        .environment(\.managedObjectContext, CoreDataProvider(inMemory: true).context)
}
