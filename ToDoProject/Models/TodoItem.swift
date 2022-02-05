//
//  TodoItem.swift
//  ToDoProject
//
//  Created by ozgun on 31.01.2022.
//
import Foundation

struct TodoItem {
    var id: Int
    var title: String
    var descriptions: String?
    var notificationDate: Date?
    var isDone: Bool
    var timerSet: Bool
    var lastModifiedDate: Double
}
