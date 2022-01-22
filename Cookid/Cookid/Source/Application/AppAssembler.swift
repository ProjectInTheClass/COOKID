//
//  AppAssembler.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

final class AppAssembler {
    static func resolve() -> Assembler {
        let appContainer = Container()
        let assembler = Assembler([
            // Data
            NetworkAssembly(),
            FirebaseAssembly(),
            RealmAssembly(),
            // Domain
            ServiceAssembly(),
            // Presenter
            HomeAssembly(),
            LocalSignInAssembly(),
            MainAssembly(),
            PostAssembly(),
            MyPageAssembly()
        ], container: appContainer)
        return assembler
    }
}
