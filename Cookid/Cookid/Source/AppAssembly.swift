//
//  AppAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/22.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserDefaults.self) { resolver in
            return UserDefaults.standard
        }
    }
}
