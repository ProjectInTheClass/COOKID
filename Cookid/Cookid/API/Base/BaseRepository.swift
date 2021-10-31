//
//  BaseRepository.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseRepository {
    unowned let repoProvider: RepositoryProviderType
    init(repoProvider: RepositoryProviderType) {
        self.repoProvider = repoProvider
    }
}
