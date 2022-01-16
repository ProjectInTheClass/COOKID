//
//  CoodinatorProtocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import UIKit

protocol CoordinatorType {
    var childCoordinator: [CoordinatorType] { get set }
    var navigationController: UINavigationController? { get set }
    var serviceProvider: ServiceProviderType { get set }
    @discardableResult
    func start() -> UIViewController
}
