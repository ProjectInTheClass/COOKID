//
//  PostDetailReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/20.
//

import Foundation
import RxSwift
import ReactorKit
import RxDataSources

final class PostDetailReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var post: Post
        var comments: [CommentSection]
    }
    
    let initialState = State(post: DummyData.shared.posts.first!, comments: [])
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    var dataSource: DataSource<CommentSection> = {
        let ds = DataSource<CommentSection> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.updateUI(comment: item)
            return cell
        }
        return ds
    }()
    
    
}

struct CommentSection: SectionModelType {
    
    var header : Item
    var items: [Comment]
    
    init(header: Item, items: [Item]) {
        self.header = header
        self.items = items
    }
    
}

extension CommentSection {
    typealias Item = Comment
    init(original: CommentSection, items: [Comment]) {
        self = original
    }
}
