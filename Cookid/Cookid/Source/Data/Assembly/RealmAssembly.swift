//
//  RealmAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/19.
//

import Foundation
import Swinject

class RealmAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FileManagerRepoType.self, name: nil) { resolver in
            return FileManagerRepo()
        }
        
        container.register(RealmUserRepoType.self, name: nil) { resolver in
            return RealmUserRepo()
        }
        
        container.register(RealmMealRepoType.self, name: nil) { resolver in
            return RealmMealRepo()
        }
        
        container.register(RealmShoppingRepoType.self, name: nil) { resolver in
            return RealmShoppingRepo()
        }
    }
}
