//
//  Date+.swift
//  ToDoProject
//
//  Created by ozgun on 8.02.2022.
//

import Foundation
extension Date {
    func toString(format: String = "dd MMM yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
