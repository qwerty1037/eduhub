'내가 작성한 코드는 나랑 신만 안다. 2주가 지나면 신만 안다'

<기본>
이름 - 누가 보더라도 쉽게 이해할 수 있도록 선정한다
함수 - 가능한 핵심 기능만 
method, variable name - camelCase 
class name - PascalCase
전역 상수 - 대문자
README파일 변경 또는 추가 부분 * 붙이기(일주일 후 제거)

<DOCS>
Component : screen 구성에 사용될 component들. component 부분은 쉽게 끌어다 쓰는 것이 중요하므로, getX를 사용하지 않았다.
 
    - Config.dart : 공통으로 사용되는 상수들 저장
        flutter에서 색상의 경우 세밀한 조정 필요시 Color(0xFFFFFFFF), 아닐시 Colors.black[100]같은 방식으로 사용 가능하다 
        dark, light mode에서 사용될 color와 font size들을 현재 설정해 놓았다
            
    - Profile.dart : id, project, mode를 변수로 가지고 있는 class. id는 필수이며 ColorMode는 enum타입으로 dark, light가 존재한다

    - Temporary.dart : 언젠가 사용될 코드지만, 현재는 사용하고 있지 않는 코드 보관 
    
GetX : Getx 관련 패키지를 모아둔 곳

Screen : UI Screen, 전체 코드가 합쳐지는 부분