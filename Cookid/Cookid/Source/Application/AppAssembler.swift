//
//  AppAssembler.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

final class AppAssembler {
    static let assembler = Assembler([
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
    ])
}
