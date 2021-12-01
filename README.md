# COOKID

> 나만의 식비 관리 앱
> https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1577118367

# 1. 서비스 소개 😊

* 쿠키드는 식재료 쇼핑과 식사일지를 기반으로 한 달 정해진 식비 예산을 분석, 관리해주는 서비스입니다. 

# 2. 팀원 소개 👩🏻‍💻🧑🏻‍💻👨🏻‍💻🧑🏻‍💻

* [김동환](https://github.com/supersupremekim)
* [박형석](https://github.com/Developer-Paul-t)
* [임현지](https://github.com/leemyeonji)
* [홍석현](https://github.com/Derek1119)

# 3. 핵심 기능 📱

* 메인 : 소비현황과 나의 식생활을 한 눈에 확인할 수 있습니다.<br/> 목표 식비, 쇼핑, 외식, 잔액, 그래프를 통해 식비 소비 현황에 대한 정보를 제공합니다. 또 지난 식사 데이터를 분석하여 식비를 관리할 수 있도록 돕는 통계를 제공합니다.

* 식사추천 : 맛있게 먹은 식사를 추천하는 커뮤니티입니다. 식사 장소와 가격, 별점, 후기, 사진 등을 통해 좋은 식사 경험을 나누고, 해당 식사가 현재 예산에 적합한지 확인할 수 있습니다. 해당 포스트에 좋아요와 북마크로 인터렉션 할 수 있고 댓글과 대댓글로 서로 소통할 수 있습니다.

* 마이페이지 : 사용자의 활동을 보여주는 곳입니다. 사용자의 정보 수정 및 문의를 할 수 있고, 모든 식사 내역, 자신이 포스팅한 글, 북마크한 글을 저장해주고 보여줍니다. 

# 4. 기술 스택 🛠

### Swift
* Swift 5.3
* UIKit

### 코딩컨벤션
* SwiftLint

### 뷰 드로잉
* Interface builder, Storyboard
* Code : Then, SnapKit

### 반응형 프로그래밍 및 커뮤니티 기술
* RxSwift, RxCocoa, RxDataSource, RxKeyboard, NSObject+Rx
* ReactorKit

### 백앤드
* Kakao, Naver, Apple Auth
* Firebase Cloud Messaging
* Firebase Firestore
* Firebase Storage

* Local DB: Realm, fileManager, UserDefault, KeyChain

### 앱 사용 분석
* Firebase Analytics
* Firebase Crashlytics

### CI/CD Pipeline
* Bitrise : Github -> Bitrise -> fastlane
* Fastlane : fastlane -> Testflight / App Store

### Test
* Unit Test : XCTest

### 개발 아키텍처
* Rx + MVVM + Coordinator Pattern
* ReactorKit
* Singletone Pattern

### 이외에 사용한 오픈소스
* Kingfisher
* FSCalendar
* PanModal
* PagingKit

# 5. 업데이트 내역

* 1.0.1 앱 출시 버전
* 1.0.2 버그 수정, 다크 모드 지원, 식사 & 쇼핑 CRUD관련 사용자 편의 개선, 랭킹 페이지 제작, 리팩토링, 로컬 노티피케이션 추가
* 2.0 버그 수정, 애플 계정 전환, FCM, Realm 연동, Bitrise & fastlane / 온라인 서비스 : 카카오, 네이버, 애플, Firestore, , 뷰제작: 마이페이지(나의 모든 소비, 프로필, 북마크, 나의 글, 레시피는 뷰만), 모든 통계는 메인페이지, 랭킹페이지 변경(베스트 집밥러, 베스트 레시피), 자유게시판(식사추천) 제작

