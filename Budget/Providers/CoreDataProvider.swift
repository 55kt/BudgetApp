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
        
        // List of expenses
        let foodItems = ["Burger", "Carrot", "Noodles", "Sushi", "Pizza", "Pitta Gyro"]
        for foodItem in foodItems {
            let expense = Expense(context: context)
            expense.title = foodItem
            expense.amount = Double.random(in: 8...100)
            expense.quantity = Int16.random(in: 1...12)
            expense.dateCreated = Date()
            expense.budget =  sailing
        }
        
        // insert tags
        let commonTags = ["Food", "Dining", "Travel", "Sailing", "Entertainmnent", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            if let tagName = tag.name, ["Sailing", "Travel"].contains(tagName) {
                fuel.addToTags(tag)
            }
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
