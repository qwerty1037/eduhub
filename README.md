## 공통 컨벤션

변수명, 메소드 → 카멜 케이스  ex) thisIsMethod
Class → 파스칼 케이스 ex) ThisIsClass
파일명 → 스네이크 케이스 ex) This_Is_Snake
전역 상수 → 대문자 + 스네이크 ex) const GLOBAL_CONST 

## flutter 컨벤션

콤마 전부 찍기(마지막에도 찍기)
들여쓰기도 왠만하면 레벨에 따라 한칸씩 띄우는거 맞추기

///: 
**필수** 이거 쓰면 메소드 앞에 쓰면 불러왔을때 볼수있음. input, output, preference 작성.  

//:
 이거는 그냥 코드 보는 사람한테 간단하게, 개인 선택에 따라 작성.

## 금기
중괄호 없는 조건문
금기 예시:
if ( someCondition )
     executeMethod;

## 폴더 분류
대분류는 
스크린 - 컨트롤러 - 컴포넌트 - 클래스
컴포넌트는 파일은 따로 만들되 비슷한 기능들끼리 폴더로 묶기

## 백엔드 컨벤션
MVC 패턴(model, view, controller). 예를 들어 admin이라는 라우터가 있다.
admin.view.ts
admin.controller.ts
admin.middleware.ts
이렇게 이름.역할.확장자 형식 표시
상대 경로 아닌 절대 경로 사용하기

## 코드 리뷰
merge를 코드 리뷰할 때 끝내기 + monday.com에 할 리스트 다 작성하고 가기


## DOCS관련
통합본 DOCS 방식을 하자. 써오는건 각자하고 저장은 일단 깃허브 README파일에 합치기
별도로 description 요약해서 작성하기

# DOCS

## Class : 사용하는 클래스를 모아둔 곳

## Component : component 부분은 반복적인 구조를 쉽게 끌어다 쓰는 것이 중요 
    - Config.dart : 공통으로 사용되는 상수들 저장
        flutter에서 색상의 경우 세밀한 조정 필요시 Color(0xFFFFFFFF), 아닐시 Colors.black[100]같은 방식으로 사용 가능하다 
        다양한 화면에 사용될 color와 fontsize, 백엔드 host 등을 설정해놓았다.
            
    

    
    
## Controller : Getx 관련 패키지를 모아둔 곳
    - total.controller.dart : 앱 전체적으로 사용되는 전역변수들 모아두는 컨트롤러
        
        <variable>
        isdark : light, dark 모드를 결정하기 위한 변수. true -> 다크모드

    - tab.controller.dart : 로그인 후 maintabview 부분을 관리하는 컨트롤러. 

        <variable>
        currentTabIndex : 현재 화면에 보이는 탭의 인덱스
        tabs : 관리되는 탭 리스트
        isHomeScreen : true면 HomeScreen렌더링. 처음 or 홈 아이콘 누를시 true로 업데이트되며 다른 탭을 볼 때 false로 업데이트

        <method>
        addTab : widget 형식의 body 인자를 받아서 탭을 만들고 return하는 함수. 현재는 title의 제목 부분이 new tab으로 고정되어 있으나 추후 업데이트 필요시 변경해야함(프로젝트 이름 등)
        onReordered : 탭 간의 순서가 바뀔 때 인덱스를 새로 업데이트해주는 함수.

    - home_screen.controller.dart : 홈 스크린 관련 컨트롤러로 주로 홈 스크린의 navigation view관련 처리를 함.
        
        <variable>
        selectedIndex : navigation view에서 보여줄 pane의 인덱스 
        paneItemList : navigation view의 paneItemlist. 생성자로 초기화.
        paneIsOpen : 왼쪽에 리스트로 보여줄 pane이 open(넓게 열린 상태)인지 minimal(아이콘만 보임) 상태인지 나타내며 true이 open.

        <method>
        onChanged : 현재 보고 있는 pane의 인덱스가 바뀔시 작동하는 함수. 새 인덱스를 인자로 받으며, 마지막의 new project부분이 아닐 경우 selectedIndex를 업데이트하고, new project 인덱스일 경우 새 paneItem을 삽입(새 프로젝트 생성).

## Screen : UI Screen, 전체 코드가 합쳐지는 부분
    - main.dart : run 또는 디버깅할 시 가장 먼저 실행되는 파일. 앱 전반에 사용되는 total, folder controller와 함께 작동한다. 초반에 homeTabview로 자동으로 이어진다.(추후 로그인 부분으로 변경 예정)

    - home_tabview.dart : 로그인 후 처음 보여질 탭뷰이며 컨트롤러와 함께 연동되어 작동한다. 헤더에 home 아이콘 모양의 버튼을 두었으며 맨 처음 Screen 렌더링 또는 아이콘 클릭시 homeScreen이 stack 방식으로 렌더링된다. 다른 탭으로 넘어가거나 새로운 탭을 만들경우 해당 화면으로 렌더링 되도록 코드가 작성되었다.

    - home_screen.dart : 탭뷰가 처음 렌더링 되거나 홈 아이콘 클릭시 보여지는 home_screen이다. fluent_ui의 navigationView를 이용하여 개발하였으며 왼쪽 부분에는 프로젝트 리스트와 새 프로젝트 만들기, pane list 사이즈 줄이기 버튼이 현재 존재한다. Appbar부분에는 테마 모드를 설정하는 toggle버튼과 내정보, 결제, 로그아웃 기능을 수행할 설정 dropdown button(기능 미구현), 추후 문제를 태그 형식으로 검색할 검색창 부분, appbar의 끝 부분에는 flyout을 통해 유튜브 사용법 보기, 언어 변경, 피드백 보내기(기능 미구현)가 가능하도록 ui가 구성되어 있다.
    현재 각 pane의 body부분은 구현되지 않은 상태이다.



