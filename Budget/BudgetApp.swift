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
    
    init() {
        provider = CoreDataProvider()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
