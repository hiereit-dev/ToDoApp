//
//  Extensions.swift
//  TodoApp
//
//  Created by 박세라 on 3/21/25.
//

import Foundation

extension Date {
    // Date -> yyyy-MM-dd HH:mm 포맷인 String으로 변환
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
