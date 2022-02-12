//
//  Constants.swift
//  ToDoProject
//
//  Created by ozgun on 31.01.2022.
//


struct K {
    static let cellId = "protoCell"
    static let listCell = "ListTableViewCell"
    static let nibName = "ListTableViewCell"
    static let segueDetail = "routeToDetailTodo"
    static let main = "Main"
    struct Cell {
        static let notDone = "empty"
        static let done = "full"
    }
    struct Color {
        static let light = "light"
        static let dark = "dark"
    }
    
    struct CoreData {
        static let entityName = "Todos"
        static let containerName = "ToDoProject"
        static let idPredicate = "id = %@"
        static let id = "id"
        static let isDone = "isDone"
    }
}
