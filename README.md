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

<img src="/Users/shhong/Desktop/Simulator Screen Shot - iPhone 11 - 2021-07-21 at 14.55.21.png" alt="Simulator Screen Shot - iPhone 11 - 2021-07-21 at 14.55.21" style="zoom: 25%;" align="left">

 

* 홈 화면에서 소비현황과 나의 식사를 한 눈에 확인할 수 있습니다. 
  * 목표 식비, 쇼핑, 외식, 잔액, 그래프, 식사에 대한 정보를 제공합니다. 

<img src="/Users/shhong/Library/Application Support/typora-user-images/image-20210721150027068.png" alt="image-20210721150027068" style="zoom:33%;" align="left" />

* 나의 식생활을 확인할 수 있습니다. 
  * 식사 데이터를 분석하여 식사 통계를 제공합니다. 

<img src="/Users/shhong/Library/Application Support/typora-user-images/image-20210721150100268.png" alt="image-20210721150100268" style="zoom:33%;" align="left" />

* 나의 소비패턴을 확인할 수 있습니다.
  * 달력에서 소비 빈도를 확인할 수 있습니다. 



# 4. 기술 스택 🛠

### OpenSource

* Kingfisher

* FSCalendar

* Then

* SnapKit



### 사용한 기술 

* swiftUI

* Firebaseauth

* realtimeDatabase

* Storage



# 5. 업데이트 내역

* 0.0.1
  * Not yet
    

# 6. 역할 분담? 느낀 점? 

* ### 임현지

  1. View
     * swiftUI
     * Combine : 데이터에 변화가 생길때마다 변화를 감지
     * UIHostingViewController : 컴플리션 핸들러로 뷰에 정보를 전달할 수 있도록 했음
     * GeometryEffect : 뷰에서 뷰로 넘어갈때 서로의 Geometry를 알고 있다가 뷰에서 뷰로의 전환이 자유롭게 해줌 (사용하려면 버전 관리를 해야함 14버전 이후)
     * Firebase : 익명로그인 시도

  2. 어려웠던 점

     key의 대한 관리, key를 고유하게 만들어서 관리하고 싶었는데 이 아이디어가 쉽지 않았음

     swiftUI에서 Meal의 정보를 서비스에 어떻게 보내야할지 

* ### 박형석

  1. 작업 내용?

  * View
    * mainView 작업 : 하나의 스크롤뷰 안에 뷰를 넣음 (for 여백의 미) 
    * 온보딩뷰 작업: 온보딩에서 사용자의 정보를 입력하는 방식, 정보는 버튼으로 들어가고 이를 가능하게 했던 것은 뷰모델을 사용하였기 때문 
    * charaterSet 
    * MealtapView : progressBar

  * 데이터 바인딩
    * MealService
    * RxSwift, RxCocoa

  2. 어려웠던 점

     error처리

     익명로그인 

  3. 느낀 점

     MVVM 수정이 쉬운 장점을 느꼈음

* ### 홍석현

  1. 작업 내용

  * View



* ### 김동환 

  1. 작업내용

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
          -  main 뷰의 사용자의 현재 사용 금액별 현황 메시지 구현을 위한 로직 구현
          
    * UserService
          -  업데이트 된 유저의 정보를 repository로 전달
    
    * UserRepository
          -  UserSevice에서 전달 받은 업데이트 된 유저의 정보를 파이어베이스에 업데이트


  2. 어려웠던 점
   
    service에서 비즈니스 로직을 짤 때, 어떻게 짜면 더 가독성이 있을지(분기가 필요한 함수에서 switch문을 쓸지 if문을 쓸 지), 더 효율적일지 (여러 군데에서 사용되는 date -> String, string -> date 로직을 따로 함수로 구현해서 사용), 어느 로직이 더 빠를 지 등을 고민하는 과정이 어려웠지만, 협업자들과 소통하고 고민하며 문제를 풀어가는 과정이 흥미로웠다.
    
    MVVM의 특성과 이번 협업 구성의 특성상, 다른 협업자가 담당한 부분을 정확하게 알지 못하다보니, 필요한 데이터를 적절히 제공받지 못하거나, 정확히 어떤 정보가 view에서 필요한 지 모르면서 작업하는 것이 난해할 때가 있었다.
    
    사용자에게 소비 현황별 메시지를 전달하는 로직을 짤 때, 어느 기간을 기준으로, 어느 정도의 사용 금액을 기준으로 나누어 메시지를 전달하는 것이 사용자에게 유용할 지, 앱을 사용하는 재미가 있을 지 고민했는데, 주 단위로 제공하는 것이 적당히 사용자의 앱 사용 동기를 부여해준다고 판단하여 주 단위로 메시지를 제공하는 로직을 짰다.
    
    사용자 정보를 업데이트하는 뷰에서, 앱 전체의 분위기에 맞는 ui, ux를 제공하는 것을 고민했다. 고민의 결과, 이야기를 건네듯 현재 유저의 상태를 알려주면서도, 업데이트가 가능한 각 정보 아래 텍스트 필드와 placeholder를 제공하여, 친근한 분위기이지만 기능이 확실한 ux를 제공하는 뷰를 구성하였다.




