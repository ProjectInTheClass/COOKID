//
//  MyLogger.swift
//  SwinjectTest
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
    let queue: DispatchQueue = DispatchQueue(label: "mylogger")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request")
        guard let statusCode = request.response?.statusCode else { return }
        debugPrint(statusCode)
    }
}
