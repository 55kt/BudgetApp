//
//  CoreDataProvider.swift
//  Budget
//
//  Created by Vlad on 27/5/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context
        
        let entertainment = Budget(context: context)
        entertainment.title = "Entertainment"
        entertainment.limit = 500
        entertainment.dateCreated = Date()
        
        let sailing = Budget(context: context)
        sailing.title = "Sailing"
        sailing.limit = 10000
        sailing.dateCreated = Date()
        
        let fuel = Expense(context: context)
        fuel.title = "Fuel"
        fuel.amount = 320.20
        fuel.dateCreated = Date()
        
        let water = Expense(context: context)
        water.title = "Water"
        water.amount = 12.40
        water.dateCreated = Date()
        
        sailing.addToExpenses(fuel)
        sailing.addToExpenses(water)
        
        // insert tags
        let commonTags = ["Food", "Dining", "Travel", "Entertainmnent", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
        }
        
        do {
           try context.save()
        } catch {
            print(error)
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data Store failed to initialize \(error)")
            }
        }
        
    }
    
}
