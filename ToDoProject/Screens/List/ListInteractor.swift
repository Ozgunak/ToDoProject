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
}

protocol ListDataStore {
    var todos: [TodoItem]? { get set }
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var todos: [TodoItem]?
    
    var presenter: ListPresentationLogic?
    var worker: ListWorker?
    var todosWorker = ListWorker(todosStore: TodoStore())
    
    // MARK: - Fetch Todos
    
    func fetchTodos(request: List.FetchTodos.Request) {
        todosWorker.fetchTodos { (todos) -> Void in
            self.todos = todos
            let response = List.FetchTodos.Response(todos: todos)
            self.presenter?.presentTodos(response: response)
        }
    }
    //MARK: - Check Todos

    func checkTodo(request: List.CheckTodo.Request) {
        todosWorker.checkTodo(todoIdToCheck: request.id, todoRowToCheck: request.row) { (row, todo) -> Void in
            let response = List.CheckTodo.Response(row: row, todo: todo!)
            self.presenter?.updateTodo(response: response)
        }
    }


}
    
    
//  func doSomething(request: List.Something.Request)
//  {
//    worker = ListWorker()
//    worker?.doSomeWork()
//
//    let response = List.Something.Response()
//    presenter?.presentSomething(response: response)
//  }

