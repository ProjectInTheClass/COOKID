//
//  NetworkAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import Swinject

class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkAPIType.self, name: nil) { _ in
            return PhotoAPI()
        }
    }
}
