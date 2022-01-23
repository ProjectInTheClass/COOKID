//
//  CoodinatorProtocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import UIKit
import Swinject

protocol CoordinatorType: AnyObject {
    var parentCoordinator: CoordinatorType? { get set }
    var childCoordinator: [CoordinatorType] { get set }
    var assembler: Assembler { get set }
    var navigationController: UINavigationController? { get set }
    init(assembler: Assembler)
    func start()
}
