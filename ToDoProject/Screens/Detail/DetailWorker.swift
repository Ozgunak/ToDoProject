//
//  DetailWorker.swift
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

protocol DetailWorkerProtocol {
    func createTodo(title: String, description: String, completionHandler: @escaping (Bool?) -> Void)
    func editTodo(id: Int, title: String, description: String, completionHandler: @escaping (Bool?) -> Void)
}

class DetailWorker: DetailWorkerProtocol {
    var coreData: CoreDataManagerProtocol
    init(coreData: CoreDataManagerProtocol) {
        self.coreData = coreData
    }
    
    func createTodo(title: String, description: String, completionHandler: @escaping (Bool?) -> Void) {
        coreData.saveTodo(title: title, description: description, isDone: false) { onSuccess in
            completionHandler(onSuccess)
        }
    }


    func editTodo(id: Int, title: String, description: String, completionHandler: @escaping (Bool?) -> Void) {
        coreData.editTodo(id: Int64(id), title: title, description: description) { isSuccess in
            completionHandler(isSuccess)
        }
    }
    

}
