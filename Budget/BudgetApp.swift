//
//  BudgetApp.swift
//  Budget
//
//  Created by Vlad on 27/5/25.
//

import SwiftUI

@main
struct BudgetApp: App {
    
    let provider: CoreDataProvider
    let tagSeeder: TagsSeeder
    
    init() {
        provider = CoreDataProvider()
        tagSeeder = TagsSeeder(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
                .onAppear {
                    let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                    if !hasSeededData {
                        let commonTags = ["Food", "Dining", "Travel", "Entertainmnent", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]

                        do {
                            try tagSeeder.seed(commonTags)
                            UserDefaults.standard.setValue(true, forKey: "hasSeedData")
                        } catch {
                            print(error)
                        }
                    }
                }
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
