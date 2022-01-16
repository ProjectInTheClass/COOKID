//
//  DBConstants.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
//

import Foundation

enum DBError: String, Error {
    case realmError = "⚠️ 로컬DB 연동에 실패했습니다."
    case firebaseError = "⚠️ 네트워크DB 연동에 실패했습니다."
}

enum DBSuceess: String, Error {
    case realmSuceess = "✅ 로컬DB 연동에 성공했습니다."
    case firebaseSuceess = "✅ 네트워크DB 연동에 성공했습니다."
}
