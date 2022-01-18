//
//  NetworkAPIType.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/17.
//

import Foundation
import RxSwift

protocol NetworkAPIType {
    func search(_ query: String) -> Observable<[Photo]>
}
