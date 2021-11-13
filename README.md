# COOKID

> 나만의 식비 관리 앱
>
> https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1577118367

# 1. 서비스 소개 😊

* 쿠키드는 식재료 쇼핑과 식사일지를 기반으로 한 달 정해진 식비 예산을 분석, 관리해주는 서비스입니다. 



# 2. 팀원 소개 👩🏻‍💻🧑🏻‍💻👨🏻‍💻🧑🏻‍💻

* [김동환](https://github.com/supersupremekim)
* [박형석](https://github.com/Developer-Paul-t)
* [임현지](https://github.com/leemyeonji)
* [홍석현](https://github.com/Derek1119)



# 3. 핵심 기능 📱

![cookidImage](https://user-images.githubusercontent.com/77890228/128953113-641338e6-e86c-47e1-b27a-7360b7bca4c8.png)

* 홈 화면에서 소비현황과 나의 식사를 한 눈에 확인할 수 있습니다.<br/>
 목표 식비, 쇼핑, 외식, 잔액, 그래프를 통해 식비 소비 현황에 대한 정보를 제공합니다.

* 나의 식생활을 확인할 수 있습니다.<br/>
지난 식사 데이터를 분석하여 식비를 관리할 수 있도록 돕는 통계를 제공합니다.

* 달력으로 나의 소비패턴을 확인하고 관리할 수 있습니다.<br/>
달력에서 소비 빈도와 소비의 정도를 표시합니다. 원하는 내역을 삭제하고 수정할 수 았습니다.



# 4. 기술 스택 🛠

### Swift 5.3
* Swift
* UIKit

### 코딩컨벤션
* SwiftLint
* Naming Conventions / https://soojin.ro/blog/english-for-developers-swift (Refactoring)

### 뷰 드로잉
* Storyboard
* Then, SnapKit

### 반응형 프로그래밍 및 커뮤니티 기술
* RxSwift, RxCocoa, RxDataSource, RxKeyboard, NSObject+Rx
* ReactorKit

### 백앤드
* Kakao, Naver, Apple Auth
* Firebase Firestore
* Firebase Storage
* Local DB: Realm, KeyChain, FileManager, UserDefault

### CI/CD, Test
* Unit Test, XCTest

### 앱어트리뷰션
* Firebase Analytics
* Firebase Crashlytics

### 개발 아키텍처
* Rx + MVVM + Coordinator Pattern 
* Singletone Pattern

### 이외에 사용한 오픈소스
* Kingfisher
* FSCalendar
* PanModal
* PagingKit

# 5. 업데이트 내역 및 예정

* 1.0.1 앱 출시 버전
* 1.0.2 버그 수정, 다크 모드 지원, 식사 & 쇼핑 CRUD관련 사용자 편의 개선, 랭킹 페이지 제작, 리팩토링, 로컬 노티피케이션 추가

* 1.0.3 Soon(버그 수정, 애플 계정 전환 -> CloudMessage, Realm, fastlane으로 배포 자동화, 식사 기본 이미지 추가, 온라인 서비스 준비 : OAuth(카카오, 네이버, 애플), Firestore(유저), 유저 페이지 제작, 뷰제작: 마이페이지(나의 모든 소비, 프로필))

* 2.0 Soon(온라인 서비스 : Firestore(레시피 & 코멘트 & 게시글 DB) - Realm 연동 / 뷰 변경 : 모든 통계는 메인페이지, 마이페이지(좋아요 레시피 & 나의 레시피 추가), 집밥레시피 페이지(메인테이블, 디테일페이지, 코멘트페이지), 랭킹페이지 변경(베스트 집밥러, 베스트 레시피), 자유게시판 추가 제작)

* 3.0 Not yet(유료 서비스 준비 : 유료레시피, 카드사 연동 API 자동 추가 시스템 제작(시간대, 가격, 업계관련, 이름 등))
