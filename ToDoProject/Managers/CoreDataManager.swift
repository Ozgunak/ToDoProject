//
//  CoreDataManager.swift
//  ToDoProject
//
//  Created by ozgun on 1.02.2022.
//

import Foundation
import CoreData


protocol CoreDataManagerProtocol {
    func saveTodo(title: String, description: String, isDone: Bool, notificationDate: Date?, onSuccess: @escaping ((Bool) -> Void))
    func fetchTodoList() -> [TodoItem]
    func editTodo(id: Int64, title: String, description: String?, onSuccess: @escaping ((Bool) -> Void))
    func deleteTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void))
    func searchTodo(with text: String) -> [TodoItem]
    func checkTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void))
    func checkTodo2(id: Int64, onSuccess: @escaping (() throws -> Int, TodoItem?) -> Void)

}

class CoreDataManager: CoreDataManagerProtocol {
    
    lazy var context = persistentContainer.viewContext
    
   
    //MARK: - edit todo

    func editTodo(id: Int64, title: String, description: String?, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let result = results[0]
                    result.title = title
                    result.descriptions = description
                    result.lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
                }
            }
        } catch let error as NSError {
            print("Could not edit: \(error), \(error.userInfo)")
        }
        contextSave { success in
            onSuccess(success)
        }
    }

    //MARK: - Delete Todo

    func deleteTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)

        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let objectUpdate = results[0] as NSManagedObject
                    context.delete(objectUpdate)
                    try context.save()
                }
            }
        } catch let error as NSError {
            print("Could not check: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        contextSave { success in
            onSuccess(success)
        }
    }
    

    //MARK: - Search Todo
    
    func searchTodo(with text: String) -> [TodoItem] {
        var todos = [TodoItem]()

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todos")
        fetchRequest.predicate = NSPredicate(format: "title contains[c] '\(text)'")


        do {
            if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                for item in fetchResult {
                    let todo = TodoItem(id: Int(item.id), title: item.title ?? "", descriptions: item.descriptions, isDone: item.isDone, timerSet: item.timerOn, lastModifiedDate: item.lastModifiedDate)
                    todos.append(todo)
                }
            }
        } catch let error as NSError {
            print("Could not fatch: \(error), \(error.userInfo)")
        }
        return todos

    }
    
    //MARK: - Check Todo

    func checkTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)

        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let objectUpdate = results[0] as NSManagedObject
                    objectUpdate.setValue(!results[0].isDone, forKey: "isDone")
                    results[0].lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
                    try context.save()
                }
            }
        } catch let error as NSError {
            print("Could not check: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        contextSave { success in
            onSuccess(success)
        }

    }
    
    func checkTodo2(id: Int64, onSuccess: @escaping (() throws -> Int, TodoItem?) -> Void) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let objectUpdate = results[0] as NSManagedObject
                    objectUpdate.setValue(!results[0].isDone, forKey: "isDone")
                    results[0].lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
                    try context.save()
                }
            }
        } catch let error as NSError {
            print("Could not check: \(error), \(error.userInfo)")
        }
        contextSave { success in
            
        }

    }
    //MARK: - save todo

    func saveTodo(title: String, description: String, isDone: Bool, notificationDate: Date?, onSuccess: @escaping ((Bool) -> Void)) {
        if let entity: NSEntityDescription
            = NSEntityDescription.entity(forEntityName: "Todos", in: context) {
            
            // id get value
            var lastId: Int = 0
            let fetchRequest: NSFetchRequest<NSManagedObject>
            = NSFetchRequest<NSManagedObject>(entityName: "Todos")
            do {
                if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                    
                    if fetchResult.count != 0 {
                        lastId = Int(fetchResult[fetchResult.count-1].id)
                    } else {
                        lastId = 0
                    }
                }
            } catch let error as NSError {
                print("Could not create: \(error), \(error.userInfo)")
            }
            
            if let todo: Todos = NSManagedObject(entity: entity, insertInto: context) as? Todos {
                todo.id = Int32(lastId + 1)
                todo.title = title
                todo.descriptions = description
                todo.isDone = isDone
                todo.lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
                if notificationDate != nil {
                    todo.notificationDate = notificationDate
                    todo.timerOn = true
                }else {
                    todo.timerOn = false
                }
                contextSave { success in
                    
                    onSuccess(success)
                }
            }
        }
    }
    
//    func saveTodo2(title: String, description: String, isDone: Bool, onSuccess: @escaping ((Bool) -> Void)) {
//        if let entity: NSEntityDescription
//            = NSEntityDescription.entity(forEntityName: "Todos", in: context) {
//            
//            // id get value
//            var lastId: Int = 0
//            let fetchRequest: NSFetchRequest<NSManagedObject>
//            = NSFetchRequest<NSManagedObject>(entityName: "Todos")
//            do {
//                if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
//                    
//                    if fetchResult.count != 0 {
//                        lastId = Int(fetchResult[fetchResult.count-1].id)
//                    } else {
//                        lastId = 0
//                    }
//                }
//            } catch let error as NSError {
//                print("Could not create: \(error), \(error.userInfo)")
//            }
//            
//            if let todo: Todos = NSManagedObject(entity: entity, insertInto: context) as? Todos {
//                todo.id = Int32(lastId + 1)
//                todo.title = title
//                todo.descriptions = description
//                todo.isDone = isDone
//                todo.lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
//                
//                contextSave { success in
//                    
//                    onSuccess(success)
//                }
//            }
//        }
//    }
    //MARK: - fetch todo
    
    
    func fetchTodoList() -> [TodoItem] {
        var todos = [TodoItem]()
        let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let fetchRequest: NSFetchRequest<NSManagedObject>
        = NSFetchRequest<NSManagedObject>(entityName: "Todos")
        fetchRequest.sortDescriptors = [idSort]
        do {
            if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                for item in fetchResult {
                    let todo = TodoItem(id: Int(item.id), title: item.title ?? "", descriptions: item.descriptions, notificationDate: item.notificationDate, isDone: item.isDone, timerSet: item.timerOn, lastModifiedDate: item.lastModifiedDate)
                    todos.append(todo)
                }
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        return todos
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ToDoProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
