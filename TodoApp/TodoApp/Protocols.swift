//
//  Protocols.swift
//  TodoApp
//
//  Created by 박세라 on 3/21/25.
//

import Foundation

// 화면간 정보 전송 protocol
protocol NavigationDelegate: AnyObject {
    func receiveData(_ data: [String: Any])
}
