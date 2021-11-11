//
//  FirebaseConvertable.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/12.
//

import Foundation

protocol FirebaseConvertable {
    func toDocument() -> [String:Any]
}
