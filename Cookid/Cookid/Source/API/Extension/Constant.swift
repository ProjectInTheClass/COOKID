//
//  Constant.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit

public enum DefaultStyle {
   
    public enum Color {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollection in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .darkGray
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
        public static let labelTint: UIColor = {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == . dark {
                    return .white
                } else {
                    return .black
                }
            }
        }()
        public static let bgTint: UIColor = {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == . dark {
                    return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
                } else {
                    return .white
                }
            }
        }()
    }
}

enum CELLIDENTIFIER {
    static let rankingCell = "rankingCell"
    static let rankingHeaderView = "rankingHeaderView"
    static let mainMealCell = "mainMealCell"
    static let mainShoppingCell = "mainShoppingCell"
    static let pictureSelectCell = "pictureSelectCell"
    static let menuCell = "menuCell"
    static let recipeCell = "recipeCell"
    static let postCell = "postCell"
    static let commentCell = "commentCell"
    static let postImageCell = "postImageCell"
    static let myPostCollectionViewCell = "myPostCollectionViewCell"
    static let myBookmarkCollectionViewCell = "myBookmarkCollectionViewCell"
}

enum NetWorkingError : String, Error {
    case failure
    case hasNoToken = "토큰을 얻어오지 못했습니다."
    case fetchError = "서버에서 정보를 가져오는데 실패했습니다."
    case signInError = "로그인에 성공하지 못했습니다."
    case networkError = "네트워크에서 정상적인 작동이 이루어지지 않았습니다."
}

enum NetWorkingResult : String {
    case success
    case successSignIn = "로그인에 성공했습니다!"
    case token
}

enum IMAGENAME {
    static let placeholder = "placeholder"
}

enum FirebaseError: String, Error {
    case postFetchError = "⚠️ 포스트를 가져오는데 실패했습니다."
    case postUploadError = "⚠️ 포스트를 업로드하는데 실패했습니다."
    case imagesUploadError = "⚠️ 이미지 배열을 업로드하는데 실패했습니다."
    case commentFetchError = "⚠️ 댓글을 가져오는데 실패했습니다."
    case commentCreateError = "⚠️ 댓글을 업로드하는데 실패했습니다."
    case commentDeleteError = "⚠️ 댓글을 삭제하는데 실패했습니다."
    case commentReportError = "⚠️ 댓글을 신고하는데 실패했습니다."
    case deletePostError = "⚠️ 포스트를 삭제하는데 실패했습니다."
    case postUpdateError = "⚠️ 포스트를 업데이트하는데 실패했습니다."
    case reportPostError = "⚠️ 포스트를 신고하는데 실패했습니다."
    case buttonTransactionError = "⚠️ 해당 버튼의 업데이트에 실패했습니다."
}

enum FirebaseSuccess: String {
    case postUploadSuccess = "✅ 포스트를 업로드에 성공했습니다."
    case deleteImageSuccess = "✅ 이미지를 삭제하는데 성공했습니다."
    case buttonTransactionSuccess = "✅ 해당 버튼이 업데이트 되었습니다."
    case fetchRankerSuccess = "✅ 랭킹을 가져오는데 성공했습니다."
    case createCommentSuccess = "✅ 댓글을 업로드하는데 성공했습니다."
    case deleteCommentSuccess = "✅ 댓글을 삭제하는데 성공했습니다."
    case reportCommentSuceess = "✅ 댓글을 신고하는데 성공했습니다."
    case deletePostSuccess = "✅ 포스트를 삭제하는데 성공했습니다."
    case reportPostSuceess = "✅ 포스트를 신고하는데 성공했습니다."
    case updateUserSuceess = "✅ 유저 데이터를 업로드하는데 성공했습니다."
    case postUpdateSuceess = "✅ 포스트를 업데이트하는데 성공했습니다."
}
