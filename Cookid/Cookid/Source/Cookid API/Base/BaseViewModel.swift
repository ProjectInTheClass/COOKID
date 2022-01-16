//
//  BaseViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import Foundation

class BaseViewModel {
    unowned let serviceProvider: ServiceProviderType
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
}
