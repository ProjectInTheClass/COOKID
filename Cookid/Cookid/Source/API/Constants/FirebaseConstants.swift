//
//  FirebaseConstants.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
//

import Foundation

enum FirebaseError: String, Error {
    
    case postUpdateError = "⚠️ 포스트를 업데이트하는데 실패했습니다."
    case postFetchError = "⚠️ 포스트를 가져오는데 실패했습니다."
    case deletePostError = "⚠️ 포스트를 삭제하는데 실패했습니다."
    case postUploadError = "⚠️ 포스트를 업로드하는데 실패했습니다."
    case reportPostError = "⚠️ 포스트를 신고하는데 실패했습니다."
    case buttonTransactionError = "⚠️ 해당 버튼의 업데이트에 실패했습니다."
    case imagesUploadError = "⚠️ 이미지 배열을 업로드하는데 실패했습니다."
    case commentFetchError = "⚠️ 댓글을 가져오는데 실패했습니다."
    case commentCreateError = "⚠️ 댓글을 업로드하는데 실패했습니다."
    case commentDeleteError = "⚠️ 댓글을 삭제하는데 실패했습니다."
    case commentReportError = "⚠️ 댓글을 신고하는데 실패했습니다."
    case createUserError = "⚠️ 유저를 생성하는데 실패했습니다."
    case fetchUserError = "⚠️ 유저를 가져오는데 실패했습니다."
    case updateUserError = "⚠️ 유저 데이터를 업로드하는데 실패했습니다."
    case fetchRankerError = "⚠️ 랭킹을 가져오는데 실패했습니다."
}

enum FirebaseSuccess: String {
    case postUploadSuccess = "✅ 포스트를 업로드에 성공했습니다."
    case postUpdateSuceess = "✅ 포스트를 업데이트하는데 성공했습니다."
    case deletePostSuccess = "✅ 포스트를 삭제하는데 성공했습니다."
    case reportPostSuceess = "✅ 포스트를 신고하는데 성공했습니다."
    case buttonTransactionSuccess = "✅ 해당 버튼이 업데이트 되었습니다."
    case deleteImageSuccess = "✅ 이미지를 삭제하는데 성공했습니다."
    case createCommentSuccess = "✅ 댓글을 업로드하는데 성공했습니다."
    case deleteCommentSuccess = "✅ 댓글을 삭제하는데 성공했습니다."
    case reportCommentSuceess = "✅ 댓글을 신고하는데 성공했습니다."
    case createUserSuccess = "✅ 유저를 생성하는데 성공했습니다."
    case fetchUserSuccess = "✅ 유저를 가져오는데 성공했습니다."
    case updateUserSuceess = "✅ 유저 데이터를 업로드하는데 성공했습니다."
    case fetchRankerSuccess = "✅ 랭킹을 가져오는데 성공했습니다."
}
