//
//  AddBudgetScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct AddBudgetScreen: View {
    // MARK: - Properties
    @State private var title: String = ""
    @State private var limit: Double?
    
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
                // action
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
        }// Form
    }// Body
}// View

// MARK: - Preview
#Preview {
    AddBudgetScreen()
}
