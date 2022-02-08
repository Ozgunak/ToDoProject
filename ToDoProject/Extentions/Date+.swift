//
//  Date+.swift
//  ToDoProject
//
//  Created by ozgun on 8.02.2022.
//

import Foundation
extension Date {
    func timeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedString = formatter.string(from: self)

        return formattedString
    }
}
