//
//  CoodinatorProtocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import UIKit
import Swinject

protocol CoordinatorType {
    var assembler: Assembler { get set }
    var navigationController: UINavigationController { get set }
    init(assembler: Assembler,
         navigationController: UINavigationController)
    func start()
}
