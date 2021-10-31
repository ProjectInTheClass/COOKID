//
//  BaseService.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseService {
    unowned let repoProvider: RepositoryProviderType
    unowned let serviceProvider : ServiceProviderType
    init(repoProvider: RepositoryProviderType,
         serviceProvider : ServiceProviderType) {
        self.repoProvider = repoProvider
        self.serviceProvider = serviceProvider
    }
}
