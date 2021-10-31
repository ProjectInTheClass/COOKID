//
//  BaseService.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseService: BaseRepository {
    unowned let serviceProvider: ServiceProviderType
    init(serviceProvider: ServiceProviderType, repoProvider: RepositoryProviderType) {
        self.serviceProvider = serviceProvider
        super.init(repoProvider: repoProvider)
    }
}
