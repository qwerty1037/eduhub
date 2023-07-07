# DOCS

## Class : 사용하는 클래스를 모아둔 곳

## Component : component 부분은 반복적인 구조를 쉽게 끌어다 쓰는 것이 중요 
    - DefaultKeyText.dart : PdfSaveScreen.dart에서 Key부분에(문제명, tags등) Default로 사용할 Text의 속성 정의
        * 왼쪽에 정렬된 fontSize: 21의 Text를 반환
    
    - DefaultTextField.dart: PdfSaveScreen.dart에서 Default로 사용할 TextField를 정의

    - TagModel.dart: 임시 파일로, tags의 속성을 담을 클래스 정의


    - Config.dart : 공통으로 사용되는 상수들 저장
        flutter에서 색상의 경우 세밀한 조정 필요시 Color(0xFFFFFFFF), 아닐시 Colors.black[100]같은 방식으로 사용 가능하다 
        dark, light mode에서 사용될 color와 font size들을 현재 설정해 놓았다
            
    - Profile.dart : id, project, mode를 변수로 가지고 있는 class. id는 필수이며 ColorMode는 enum타입으로 dark, light가 존재한다

    - Temporary.dart : 언젠가 사용될 코드지만, 현재는 사용하고 있지 않는 코드 보관 
    
## Controller : Getx 관련 패키지를 모아둔 곳

    - PdfSaveScreen: PDF에서 문제, 해설을 캡쳐 후 저장할 때 나타나는 스크린

    - PdfViewerScreen: PDF 뷰어와 캡처 기능이 구현된 스크린

## Screen : UI Screen, 전체 코드가 합쳐지는 부분
    - main.dart : run 또는 디버깅할 시 가장 먼저 실행되는 파일.