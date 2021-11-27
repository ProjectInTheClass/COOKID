//
//  NetworkContants.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
//

import Foundation

enum NetWorkingError : String, Error {
    case failure
    case hasNoToken = "토큰을 얻어오지 못했습니다."
    case fetchError = "서버에서 정보를 가져오는데 실패했습니다."
    case signInError = "로그인에 성공하지 못했습니다."
    case networkError = "네트워크에서 정상적인 작동이 이루어지지 않았습니다."
}

enum NetWorkingResult : String {
    case success
    case successSignIn = "로그인에 성공했습니다!"
    case token
}
