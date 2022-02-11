//
//  CoreDataManager.swift
//  ToDoProject
//
//  Created by ozgun on 1.02.2022.
//

import Foundation
import CoreData


protocol CoreDataManagerProtocol {
    func saveTodo(title: String, description: String, isDone: Bool, notificationDate: Date, notificationId: String?, onSuccess: @escaping ((Bool) -> Void))
    func fetchTodoList() -> [TodoItem]
    func editTodo(id: Int64, title: String, description: String?, onSuccess: @escaping ((Bool) -> Void))
    func editTodoWithDate(id: Int64, title: String, description: String?, notificationDate: Date, notificationId: String?, onSuccess: @escaping ((Bool) -> Void))
    func deleteTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void))
    func searchTodo(with text: String) -> [TodoItem]
    func checkTodo(id: Int64, onSuccess: @escaping (() throws -> Int, TodoItem?) -> Void)

}

class CoreDataManager: CoreDataManagerProtocol {
    
    lazy var context = persistentContainer.viewContext
    
   
    //MARK: - edit todo

    func editTodo(id: Int64, title: String, description: String?, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let todo = results[0]
                    todo.title = title
                    todo.descriptions = description
                    todo.lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
                    todo.notificationDate = NSDate.distantPast
                    todo.notificationId = nil
                }
            }
        } catch let error as NSError {
            print("Could not edit: \(error), \(error.userInfo)")
        }
        contextSave { success in
            onSuccess(success)
        }
    }
    func editTodoWithDate(id: Int64, title: String, description: String?, notificationDate: Date, notificationId: String?, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        do {
            if let results: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
                if results.count != 0 {
                    let todo = results[0]
                    todo.title = title
                    todo.descriptions = description
                    todo.notificationDate = notificationDate
                    todo.notificationId = notificationId
                    todo.lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
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
                    let todo = TodoItem(id: Int(item.id), title: item.title ?? "", descriptions: item.descriptions, notificationDate: item.notificationDate!, isDone: item.isDone, lastModifiedDate: item.lastModifiedDate, notificationId: item.notificationId)
                    todos.append(todo)
                }
            }
        } catch let error as NSError {
            print("Could not fatch: \(error), \(error.userInfo)")
        }
        return todos

    }
    
    //MARK: - Check Todo

    
    func checkTodo(id: Int64, onSuccess: @escaping (() throws -> Int, TodoItem?) -> Void) {

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
    //MARK: - create save todo

    func saveTodo(title: String, description: String, isDone: Bool, notificationDate: Date, notificationId: String?, onSuccess: @escaping ((Bool) -> Void)) {
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
                todo.notificationDate = notificationDate
                todo.notificationId = notificationId
                contextSave { success in
                    
                    onSuccess(success)
                }
            }
        }
    }

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
                    let todo = TodoItem(id: Int(item.id), title: item.title ?? "", descriptions: item.descriptions, notificationDate: item.notificationDate!, isDone: item.isDone, lastModifiedDate: item.lastModifiedDate, notificationId: item.notificationId)
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

        let container = NSPersistentContainer(name: "ToDoProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

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
