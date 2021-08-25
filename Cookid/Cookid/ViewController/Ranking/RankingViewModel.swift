//
//  RankingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import Foundation
import RxSwift
import RxDataSources

class RankingViewModel: ViewModelType {
    
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        let topRanker: BehaviorSubject<[UserSection]>
        let allSortedUsers: Observable<[UserForRanking]>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService) {
        self.userService = userService
        
        let topRanker = BehaviorSubject<[UserSection]>(value: [])
        let allSortedUsers = userService.sortedUsers()
        
        userService.makeRanking { users, error in
            if let error = error {
                print(error)
            } else {
                guard let users = users else { return }
                let userSection = [UserSection(header: UIView(), items: users)]
                topRanker.onNext(userSection)
            }
        }
        
        self.input = Input()
        self.output = Output(topRanker: topRanker, allSortedUsers: allSortedUsers)
    }
    
    let dataSource: RxTableViewSectionedReloadDataSource<UserSection> = {
        let ds = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { datasource, tableView, indexPath, user -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.rankingCell, for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
            cell.updateUI(user: user, ranking: indexPath.row)
            return cell
        })
        return ds
    }()
    
    
}
