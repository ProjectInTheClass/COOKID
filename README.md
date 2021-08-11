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
* [홍석현](https://github.com/nyokki1119)



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
* SwiftUI (위젯 제작)

### 코딩컨벤션
* SwiftLint

### 뷰 드로잉
* Storyboard
* Then, SnapKit

### 반응형 프로그래밍 및 커뮤니티 기술
* RxSwift, RxCocoa, RxDataSource, RxKeyboard, NSObject+Rx

### 백앤드
* Firebase Auth, Realtime Database, Storage

### 테스트
* Rx : RxTest, RxBlocking
* Unit : Nimble
* UI : UITest (swift)
* Application : Firebase Crashlytics, Analytics

### 테스트 자동화
* fastlane

### 개발 아키텍처
* Rx + MVVM + Coordinator Pattern 
* Singletone Pattern

### 이외에 사용한 오픈소스
* Kingfisher
* FSCalendar

# 5. 업데이트 내역

* 1.0.1
* Not yet (진행 중 : 버그 개선, 다크 모드 지원, 식사 CRUD관련 사용자 편의 개선, 위젯 추가, 랭킹 페이지 제작, 리팩토링, 로컬 노티피케이션 추가)
    

# 6. 역할 분담

* ### 임현지
  * View
     * swiftUI
     * Combine : 데이터에 변화가 생길때마다 변화를 감지
     * UIHostingViewController : 컴플리션 핸들러로 뷰에 정보를 전달할 수 있도록 했음
     * GeometryEffect 
     * Firebase : 익명로그인 시도


* ### 박형석

  * View
    * mainView 작업 : 하나의 스크롤뷰 안에 뷰를 넣음 (for 여백의 미) 
    * 온보딩뷰 작업: 온보딩에서 사용자의 정보를 입력하는 방식, 정보는 버튼으로 들어가고 이를 가능하게 했던 것은 뷰모델을 사용하였기 때문 
    * charaterSet 
    * MealtapView : progressBar

  * 데이터 바인딩
    * MealService
    * RxSwift, RxCocoa


* ### 홍석현

  * View
    + InputDataShopping view  
      쇼핑한 데이터를 입력하는 뷰  
      + UITapGestureRecognizer  
        사용자가 데이터를 입력하는 서브뷰 외의 공간을 터치하면 입력 취소로 받아드려 view dismiss 기능 구현  
      + keyboardNotification  
        키보드 노티피케이션, 옵저버를 등록하고 디바이스에 따라 키보드가 뷰를 가리는 여부에 따라 뷰가 움직이는 로직 
      + UIAlertController   
        모든 데이터를 입력 여부에 따른 alert, 확인 버튼을 탭하면 데이터 save  
        데이터 수정의 경우 alert하여 확인 버튼을 탭하면 데이터 update  
      + UIDatePicker  
    + MyExpenseView  
      나의 식사와 쇼핑 기록을 캘린더에 나타나게 하고, 해당 날짜를 탭하면 테이블 뷰에 상세 데이터 표시
      + FSCalendar  
        FSCalendar 오픈소스를 활용하여 scopeGesture, 캘린더 이벤트 날짜 표시하기 기능 구현  
      + UITableView  
        캘린더에서 받아온 데이터를 통해 테이블뷰에 전달하여 데이터를 표시하는 로직  


* ### 김동환 

  * View

    * UserInfoUpdate view - user의 정보를 업데이트 하는 뷰
     - Notification center
        키보드 노티피케이션 등록으로 키보드가 올라오고 내려갈 때에 따른 사용자 정보 입력 ux 작업
     - UITapGestureRecognizer
        사용자가 뷰 상의 텍스트 필드, 버튼 이외의 부분 눌렀을 때 tap을 인식하여 키보드가 내려오는 로직
    
  * Service
    
    * MealService 
      -뷰모델에서 필요한 data를 위해 비즈니스로직 구현 
          -  repository에서 받아온 data 가공을 통해 Meals를 모아둠, 특정 날짜에 해당하는 meals 제공, 하루 평균 소비금액 제공, date string을 Date 타입으로 변환하는 등의 비즈니스 로직 구현
          -  main 뷰의 사용자의 현재 사용 금액별 현황 메시지 제공을 위한 로직 구현
      
    * UserService
          -  업데이트 된 유저의 정보를 repository로 전달
    
    * UserRepository
          -  UserSevice에서 전달 받은 업데이트 된 유저의 정보를 파이어베이스에 업데이트


