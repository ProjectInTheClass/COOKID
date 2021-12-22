//
//  AppDependency.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/22.
//

import Foundation
import UIKit
import Alamofire
import Pure
import Swinject

// Composition Root : 전체 의존성 그래프가 resolved 된 곳, 프로그램의 진입점
// iOS에서는 AppDelegate이기 때문에 여기서 전체 resolved 되면 된다.
// Root Dependency가 결국 AppDelegate와 RoowViewController의 Dependency
// 이 의존성을 주입하기 위해 구조체를 만들어서 저장

struct AppDependency {
    let container = Container()
    let assembler: Assembler
}

extension AppDependency {
    static func resolve() -> AppDependency {
        let assembler = Assembler(
            [
                AppAssembly(),
                RepositoryAssembly(),
                DomainAssembly(),
                PresenterAssembly()
            ])
        return AppDependency(
            assembler: assembler
        )
    }
}
