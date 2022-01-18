//
//  AppAssembler.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

class AppAssembler {
    static let assembler = Assembler([
        ServiceAssembly(),
        MainAssembly()
    ])
}


