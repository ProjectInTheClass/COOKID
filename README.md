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

<img src="https://user-images.githubusercontent.com/78390837/126449082-0efbe2c6-354e-4ff4-bdf9-62cc76d11520.png)
" alt="Simulator Screen Shot - iPhone 11 - 2021-07-21 at 14.55.21" style="zoom: 15%;" align="left"/>  <br/>

 

* 홈 화면에서 소비현황과 나의 식사를 한 눈에 확인할 수 있습니다. 
  * 목표 식비, 쇼핑, 외식, 잔액, 그래프, 식사에 대한 정보를 제공합니다. 

<img src="https://user-images.githubusercontent.com/78390837/126447314-c2d6481e-6647-480b-a82f-604924a897cd.png" alt="image-20210721150100268" style="zoom:33%;" align="left" />  <br/>



* 나의 식생활을 확인할 수 있습니다. 
  * 식사 데이터를 분석하여 식사 통계를 제공합니다. 



<img width="307" alt="스크린샷 2021-07-21 오후 3 00 54" src="https://user-images.githubusercontent.com/78390837/126447765-8feefce5-d305-4c10-a940-31182e61d56e.png" style="zoom: 45%;" align="left" >  <br/>



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

    * UserInputView

      키보드노티피케이션

  * Service

    * 사용 비율에 따른 결과값 도출 함수 (주 단위)

      
