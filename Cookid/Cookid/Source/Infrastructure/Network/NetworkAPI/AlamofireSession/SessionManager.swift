//
//  SessionManager.swift
//  SwinjectTest
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation
import Alamofire

final class SessionManager {
    static let shared = SessionManager()
    
    // 인터셉터
    let interceptors = Interceptor(adapters: [], retriers: [], interceptors: [MyInterceptor()])
    
    // 로거
    let monitor = [MyLogger()] as [EventMonitor]
    
    // 세션
    var session: Session
    private init() {
        // session에 작업에 따라서 다른 configuration을 넣어줄 수 있다.
        // 기본은 default이고 URLSession과 동일. 다만 헤더가 기본값으로 설정되어 있다.
        // default인 경우 shared와 다르게 Delegate로 작업을 해줘야 하는데,
        // Alamofire는 SessionDelegate에서 다 작업을 해주고 있다.
        session = Session(interceptor: interceptors, eventMonitors: monitor)
    }
    
}
