//
//  ListInteractor.swift
//  ToDoProject
//
//  Created by ozgun on 31.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListBusinessLogic {
    func fetchTodos(request: List.FetchTodos.Request)
    func checkTodo(request: List.CheckTodo.Request)
    func deleteTodo(request: List.DeleteTodo.Request)
}

protocol ListDataStore {
    var todos: [TodoItem]? { get set }
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var todos: [TodoItem]?
    
    var presenter: ListPresentationLogic?
    var todosWorker = ListWorker(coreData: CoreDataManager(), notificationManager: NotificationManager())
    
    // MARK: - Fetch Todos
    
    func fetchTodos(request: List.FetchTodos.Request) {
        if let text = request.text {
            todosWorker.fetchTodos(with: text) { (todos) -> Void in
                self.todos = todos
                let response = List.FetchTodos.Response(todos: todos)
                self.presenter?.presentTodos(response: response)
            }
        }else {
            todosWorker.fetchTodos(completionHandler: { (todos) -> Void in
                self.todos = todos
                let response = List.FetchTodos.Response(todos: todos)
                self.presenter?.presentTodos(response: response)
            })
        }
        
    }
    //MARK: - Check Todos

    func checkTodo(request: List.CheckTodo.Request) {
        todosWorker.checkTodo(with: request.id, row: request.row) { (row, todo) -> Void in
            let response = List.CheckTodo.Response(row: row, todo: todo!)
            self.presenter?.updateTodo(response: response)
        }
        if let id = request.notificationId {
            todosWorker.deleteNotification(with: id)
        }
    }
    
    func deleteTodo(request: List.DeleteTodo.Request) {
        todosWorker.deleteTodo(with: request.id, row: request.row) { (row) in
            let response = List.DeleteTodo.Response(row: row)
            self.presenter?.deleteTodo(response: response)
        }
    }


}

