//
//  NetworkResult.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

enum NetworkError: Error {
    case statusCode
    case componentRequest
    case adaptError
    case retryError
}
