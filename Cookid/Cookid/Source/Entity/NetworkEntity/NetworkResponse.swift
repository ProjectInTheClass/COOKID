//
//  NetworkResponse.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

struct NetworkResponse<Wrapper: Codable>: Codable {
    var items: [Wrapper]
}
