//
//  Extensions.swift
//  TodoApp
//
//  Created by 박세라 on 3/21/25.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
