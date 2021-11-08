//
//  Notice.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import Foundation

struct Notice {
    var title: String
    var content: String
    var date: String
}

struct NoticeManager {
    static let notices = [
        Notice(title: "[공지] COOKID 운영정책 안내",
               content:
"""
안녕하세요? COOKID입니다. 저희 서비스를 이용해 주시는 회원 여러분께 감사드리며, COOKID 운영에 관해 안내드립니다.
\n# 식사 및 쇼핑 기록하기\n
와우!
\n# 식사 추천 포스팅 참여하기\n
와우!
""",
               date: "2021년 11월 15일"),
        Notice(title: "[공지] COOKID 개인정보 보호정책 안내",
               content:
"""
안녕하세요? COOKID입니다. 저희 서비스를 이용해 주시는 회원 여러분께 감사드리며, COOKID 개인정보 보호정책에 관해 안내드립니다. COOKID는 로그인 후 포스팅 작성, 댓글 작성과 관련해 사용자 데이터가 수집되며, 해당 데이터는 서버에 업로드 됩니다. 이에 대한 자세한 내용은 앱 스토어 하단의 개인정보 처리방침 링크를 참고해 주시면 감사하겠습니다. 관련 문의는 '이메일로 문의하기'를 이용해 주시길 바랍니다.
""",
               date: "2021년 11월 15일")
    ]
}
