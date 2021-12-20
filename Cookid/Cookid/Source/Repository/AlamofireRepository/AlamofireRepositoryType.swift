//
//  AlamofireRepositoryType.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

protocol AlamofireRepositoryType {
    func performRequest<R: Decodable, E: ResponRequestable>(with endPoint: E, completion: @escaping (Result<[R], NetworkError>) -> Void) where E.Response == R
}
