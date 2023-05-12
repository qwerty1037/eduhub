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
        dark, light mode에서 사용될 color와 font size들을 현재 설정해 놓았다
            
    - Profile.dart : id, project, mode를 변수로 가지고 있는 class. id는 필수이며 ColorMode는 enum타입으로 dark, light가 존재한다

    - Temporary.dart : 언젠가 사용될 코드지만, 현재는 사용하고 있지 않는 코드 보관 
    
## Controller : Getx 관련 패키지를 모아둔 곳

## Screen : UI Screen, 전체 코드가 합쳐지는 부분
    - main.dart : run 또는 디버깅할 시 가장 먼저 실행되는 파일.