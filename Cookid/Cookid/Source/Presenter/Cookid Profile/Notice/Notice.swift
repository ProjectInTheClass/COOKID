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
식사 및 쇼핑을 기록하실 수 있습니다. 필요하시다면 오늘의 식사 추가를 통해 한번에 업로드하세요. 메인 페이지 통계는 당월만 집계되지만 이제까지 모든 식사는 마이페이지 내 식사 탭에서 가능합니다.
\n# 식사 추천 포스팅 참여하기\n
식사 추천 포스팅을 적극 활용해 보세요. 추천하실 식사의 가격과 별점을 기록하시고 사진과 함께 올리셔서 맛있는 식사를 추천해주세요. 해당 예산에 적합한지 각 식사마다 계산해서 게시판을 사용하는 사람들에게 알려줍니다. 댓글 기능과 대댓글 기능도 있으니 적극 활용해 보세요:)
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
