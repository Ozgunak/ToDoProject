//
//  TodoStore.swift
//  ToDoProject
//
//  Created by ozgun on 2.02.2022.
//

import Foundation
import CoreData

class TodoStore: TodosStoreProtocol, DetailStoreProtocol {
   

    // MARK: - CRUD operations - Inner closure

    func fetchTodos(completionHandler: @escaping (() throws -> [Todos]) -> Void) {
        let todos = CoreDataManager().fetchTodoList()
//        let todos = CoreDataManager.shared.fetchTodos(ascending: true)
        completionHandler { return todos }
    }

//    func fetchTodo(id: Int, completionHandler: @escaping (() throws -> Todo?) -> Void) {
//
//        let todo = CoreDataManager.shared.fetchTodo(id: Int64(id))
//        completionHandler { return todo }
//    }


    func createTodo(title: String, description: String, completionHandler: @escaping (() throws -> Bool?) -> Void) {

        CoreDataManager().saveTodo(title: title, description: description, isDone: false){ onSuccess in

            print("saved =\(onSuccess)")
            completionHandler { return onSuccess }
        }
    }
    
//    func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, Todo?) -> Void) {
//        
//        CoreDataManager().checkTodo(id: Int64(todoIdToCheck)){
//            onSuccess in
//            print("update =\(onSuccess)")
//        }
//    }
    
}