##
업데이트가 필요한 docs, 주석으로 처리된 부분을 통해 기능 파악 추천

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

## Component : 스크린을 구성하는 컴포넌트나 공통으로 사용되는 함수/위젯 등을 담아두는 폴더. 하위 폴더로 Default폴더가 있다. 이 폴더에는 주로 공용으로 사용되는 함수/위젯 파일을 포함한다.


    [Default 폴더 내부 파일]
    - Config.dart : 공통으로 사용되는 상수들 저장
        flutter에서 색상의 경우 세밀한 조정 필요시 Color(0xFFFFFFFF), 아닐시 Colors.black[100]같은 방식으로 사용 가능하다 
        다양한 화면에 사용될 color와 fontsize, 백엔드 host 등을 설정해놓았다
            
    - Cookie.dart : 쿠키 관련 공통으로 사용되는 작업을 모아놓은 곳. 현재는 쿠키를 읽고 header형태로 반환하는 함수만 존재한다
        <method>
        sendCookieToBackend : 백엔드의 엔드포인트로 보낼 header부분에 들어갈 쿠키를 안전한 저장소에서 읽고 반환하는 함수

    - Default_Key_Text.dart : 텍스트 필드의 제목 부분에 들어갈 Text Widget의 양식
        Black, Bold, Fontsize 21

    - Default_Text_Field.dart : 텍스트 필드 위젯의 기본 양식

    - Default_TextBox.dart : 텍스트 박스 위젯의 기본 양식
        Material에 대응하는 FluentUI에서의 TextBox

    - HttpConfig.dart : Http request에서 사용되는 메서드 정의
        
        <Enum>
        httpContentType : http request의 종류를 구분하는 열거형 데이터

        <Method>
        defaultHeader : httpContentType을 인자로 받아서 http request의 header를 반환
        isHttpRequestSuccess : http request가 성공되었을 시 true를 반환
        isHttpRequestFailure : http request가 실패하였을 시 true를 반환

    [직속 파일]
    - Applifecycle_Observer.dart : flutter의 lifecycle을 감시하다가 앱이 일시정지되거나 종료시 쿠키를 삭제하는 옵저버이다. 추후 마지막 작업을 쿠키에 저장하는 코드가 추가될 것이다

    - Feedback_Overlay.dart : 피드백 전송 버튼을 눌렀을 때 나타나는 Overlay. Overlay의 특성상 widget이 아닌 method로 구현되어 있다.

    - Folder_TreeView_Explore.dart : workspace에 파일 탐색 기능이 있을 경우 만들어진 각각의 탭의 왼쪽 대시보드에 들어가게될 폴더 treeview이다. 유저의 폴더 내용이 탭별로 모두 동일해야하므로 태그를 사용하지 않는 folder controller의 정보를 이용한다. onSecondaryTap과 Flyout을 이용하여 폴더 우클릭후 폴더삭제/새폴더/폴더 이름바꾸기 기능을 쓸수 있다.(FolderTreeView_MenuFlyout 파일에서 처리) 폴더를 그냥 클릭시 홈화면에서 누를경우 새탭을 열면서 문제 리스트가, 아닐경우 현재 탭의 작업창 부분에 해당 폴더에 속하는 문제 리스트가 뜨게 된다.

    - Folder_TreeView_Save.dart : workspace에 문제 저장 기능이 있을 경우 대시보드에 들어가게 될 폴더 treeview이다. 폴더를 누르면 폴더에 속한 문제가 workspace에 띄워지는 Folder_TreeView_Explore.dart와 달리 폴더를 누르면 문제를 저장할 directory가 해당 폴더로 정해진다.

    - FolderTreeView_MenuFlyout.dart : Folder_TreeView에서 사용되는 위젯이다. 우클릭시 폴더의 삭제, 새폴더 만들기, 이름 바꾸기 기능이 포함되어 있다.

    - New_Folder_Button : 폴더가 비어 있을때 새로운 폴더를 만드는 버튼이다. home과 일반 탭에서 공용으로 사용된다.

    - Problem_List.dart : workingspace에 들어가는 부분으로 폴더에 속하는 문제 리스트를 보여준다. 세로 2줄로 총 8개의 문제가 리스트로 나타나며 문제 클릭시 오른쪽에 이미지가 뜬다. 폴더 직속문제와 폴더 아래 모든 문제를 사용자가 제어할 수 있다. 버튼은 문제 개수에 따라 계산되어 자동으로 뜨게 해놓았지만 문제가 너무 많이 들어올 경우 버튼 개수를 제한 시키는 코드를 추가해야한다(현재 완벽x)
    
    - Search_Bar_OverLay.dart : 검색 버튼을 눌렀을 때 나타나는 Overlay. Overlay의 특성상 widget이 아닌 method로 구현되어 있다.

    - Tag_Model.dart : 임시로 사용할 Tag 입력 창에서 사용되는 클래스
    

## Controller : Getx 관련 패키지를 모아둔 곳

    [ScreenController 내부 파일]

    - Default_Tab_Body_Controller.dart : 각 개별 탭을 관리하는 컨트롤러

        <variable>
        tabName : 탭의 tag를 저장하는 변수
        workingSpaceWidget : 작업창에 들어갈 위젯 변수(Container 타입)
        savedWorkingSpace : 저장해둔 이전 작업창 위젯

        <method>
        saveThisWorkingSpace : 현재 작업창 내용을 저장하는 함수
        changeWorkingSpace : 현재 탭의 작업창을 바꾸는 함수로 위젯을 파라미터로 받는다
        deleteWorkingSpaceController : 현재 탭 안에서 만들어진 컨트롤러들을 제거하는 함수

    - Home_Screen_Controller.dart : 홈 스크린 관련 컨트롤러
        
        <variable>
        isFolderEmpty : 현재 폴더가 비어있는지 아닌지 boolean변수

        <method>
        logout : 로그아웃 함수로 현재는 쿠키를 없애고 total컨트롤러를 제외한 모든 컨트롤러 인스턴스를 제거
        
    - Login_Screen_Controller.dart : 로그인 관련 컨트롤러
        
        <method>
        getCookieValue : 쿠키 headder와 cookieName을 파라미터로 받아 이름에 해당하는 내용을 추출하는 함수
        saveCookieToSecureStorage : 쿠키를 안전한 보관소에 저장하는 함수
        loginSuccess : 로그인 성공시 적용되는 로직으로 초기 데이터를 받아오고 탭뷰를 띄워주며 현재 컨트롤러 인스턴스를 삭제
        logInRequest : 백엔드에 로그인을 요청하는 함수로 성공시 쿠키를 저장하고 loginSuccess를 실행한다

    - Pdf_Save_Screen_Controller.dart : 문제를 저장하는 스크린 관련 컨트롤러

        <Variable>
        capturedImageProblem : 캡쳐된 문제 이미지파일
        capturedImageAnswer : 캡쳐된 정답 이미지파일
        tagsList : 입력된 태그의 리스트
        isImagePreviewButtonTapped : 이미지 미리보기 버튼이 눌려있으면 true를 반환
        difficultySliderValue : 난이도를 정하는 슬라이더의 값
        problemNameController : 문제명 입력 TextField의 TextEditingController
        tagsController : 태그 입력 TextField의 TextEditingController

        <Method>
        sendProblemInfo : 백엔드에 문제 정보를 전송하는 메서드
        getImage : 문제, 해설 이미지를 받아오는 메서드
        imagePreviewButtonText : 이미지 프리뷰 버튼 옆에 -보기, -숨기기 텍스트를 반환하는 메서드
        whenImagePreviewButtonTapped : 이미지 프리뷰 버튼이 탭되었을 때 실행될 메서드
        selectedChipsList : 선택된 칩 리스트를 반환하는 메서드
        filterChipsList : 검색한 텍스트에 맞춘 태그 칩 리스트를 반환하는 메서드

    - Pdf_Viewer_Screen_Controller.dart : Pdf Viewer 스크린 관련 컨트롤러

        <Variable>
        defaultColor : pdf를 입력하는 박스의 기본 색깔
        uploadingColor : 파일이 드래그되었을 때의 박스의 색깔
        isPdfInputed : pdf가 입력되었을 때 true를 가지는 변수
        pickedFile : FilePicker에 의해 입력된 파일
        pickedFileName : FilePicker에 의해 입력된 파일의 이름
        capturedImage : 캡쳐된 이미지
        isDragged : 파일이 드래그되었을 때 true
        isCaptured : 이미지를 캡쳐하였을 떄 true

        <Method>
        fileUpload : FilePicker를 이용해 파일을 입력하는 메서드
        onDragDone: 드래그가 완료되었을 때 실행될 메서드로, picked된 파일을 내부변수에 입력함
        onDragEntered : pdf입력 박스 안으로 드래그가 되었을 때 실행되는 메서드
        onDragExited : pdf입력 박스 밖으로 드래그가 되었을 때 실행되는 메서드
        getFileName : pickedFileName.value를 반환하는 getter
        exitPdf : PdfViewer를 종료
        capturePdf : Pdf를 캡쳐하는 메서드
        deleteCapturedImage : Captured된 이미지를 제거하는 메서드
        getCapturedImage : capturedImage 의 getter
        buttonColor : 박스의 컬러를 반환하는 메서드

    [직속 파일]
  
    - Feedback_Controller.dart : 피드백 오버레이의 컨트롤러
        <Variable>
        titleController : 제목 텍스트필드의 컨트롤러
        contentController : 내용 텍스트필드의 컨트롤러

        <Method>
        delete : 텍스트필드의 모든 내용을 삭제하는 메서드

    - Folder_Controller.dart : 폴더 관련된 처리를 하는 컨트롤러. 태그를 사용하지 않고 공용으로 사용된다.

        <variable>
        totalFolders : 사용자의 모든 폴더 리스트가 담겨 있다. 모두 동등하게 취급된다.
        firstFolders : rx로 관리되며 가장 상위 폴더만 포함된다. 사용자에게 직접적으로 보여주는 부분이며 왼쪽 클릭시 자식 폴더가 보인다.

        <method>
        receiveData : 로그인 후 백엔드로부터 유저의 폴더 데이터를 받아와 초기화를 하는 함수
        makeFolderListInfo : jsondata로부터 직접 유저에게 보여줄 폴더 형태로 보여주는 로직을 수행하는 함수
        makeFolderItem : 이름, id, parent를 파라미터로 받아 새로운 TreeViewItem를 반환하는 함수
        makeProblemListInNewTab : 특정 폴더를 클릭했을 때 해당하는 문제 내용을 백엔드로부터 받고 새로운탭을 열면서 보여주는 함수
        makeProblemListInCurrentTab : 특정 폴더를 클릭했을 때 현재 탭에서 폴더에 속하는 문제 리스트들을 보여주는 함수

    - Problem_List_Controller.dart : ProblemList의 로직을 담당하는 컨트롤러로 문제 탐색 관련 기능을 포함

        <variable>
        problemList : 보여줄수 있는 전체 문제 리스트(모든 페이지)
        savedProblemArray : 백엔드로부터 문제의 detail을 받아온 데이터들을 저장해둔 배열
        currentPageProblems : 현재 페이지에 속하는 문제들
        problemImageViewer : 문제 클릭시 문제의 이미지를 보여줄 위젯
        isAllProblems : 모든 문제/폴더 직속 문제를 제어하는 boolean 변수
        currentPage : 현재 페이지 수
        itemsPerPage : 한 페이지당 허용가능한 아이템 개수
        startIndex : 현재 페이지에서 첫번째 문제의 index
        endIndex : 현재 페이지에서 마지막 문제의 index
        lastButton : 페이지 버튼의 마지막 숫자
        pageButton : 페이지 전환 버튼들이 들어있는 리스트

        <method>
        resetVariable : 폴더 직속문제 보기 / 폴더 아래 모든 문제 보기 버튼을 클릭했을때 내부 데이터를 새로 초기화하는 함수
        makePageButton : 문제 리스트들의 페이지 버튼을 새로 만드는 함수
        fetchPageData : 문제 리스트 중에 현재 페이지에 있는 리스트들의 자세한 데이터를 받아오는 함수

    - Register_Info_Controller.dart : 회원가입 관련 컨트롤러

        <variable>
        selectedGender : 0일 경우 남자, 1일경우 여자 
        matchpassword : 비밀번호와 비밀번호 확인에 들어간 값이 일치하는지 나타내는 변수
        formatCorrect : 최종적으로 회원가입할 수 있는(채울거 다채운) 상태인지를 나타내는 변수
        이외 texteditingController 들은 각 이름에 해당하는 textfield의 컨트롤러로 사용

        <method>
        isCorrectFormat : 채워야할 정보를 모두 채웠는지 확인하는 함수
        sendRegisterInfo : 입력한 정보를 백엔드에 보내는 함수
        tryMakeId : 유저가 회원가입 시도시 회원가입이 가능한 형태인지 검증한 후 가능한 형태시 다른 함수에 넘겨주는 함수

    - Tab_Controller.dart : 앱에서 사용되는 탭 관련  컨트롤러

        <variable>
        currentTabIndex : 현재 화면에 메인으로 보여주는 탭의 index, 홈 화면일 경우 -1로 둔다.
        tabs : 전체 탭들을 리스트 타입으로 담겨있다.
        isHomeScreen : 현재 홈스크린인지 아닌지를 나타내는 boolean 변수
        tagNumber : 각 탭들의 고유 key값을 설정할 숫자로 탭을 만들때마다 1씩 커진다.
        isNewTab : 새로운 탭을 만드는지 아닌지를 제어하는 boolean 변수
    
        <method>
        addTab : 새로운 탭을 추가하는 함수로 body와 탭 이름을 파라미터로 받는다. 탭 이름 미설정시 NewTab으로 된다.
        renameTab : 탭의 이름을 바꾸는 함수로 바꿀 탭과 바꿀 이름을 파라미터로 주면 된다
        onReorder : 탭의 순서가 바뀔때 로직
        onNewPressed : tab view에서 오른쪽의 +버튼을 눌렀을때 로직
        _getCurrentTabKey : 현재 탭의 키를 반환하는 함수
        getNewTabKey : 새로 만들 탭의 key값을 반환하는 함수
        getTabKey : 새탭을 만들경우 getNewTabKey를 아닐 경우 _getCurrentTabKey를 반환하는 함수

    - Tag_Controller.dart : 사용자의 태그를 관리하는 컨트롤러
     
        <Variable>
        tagsInputController : 태그 입력 텍스트필드의 컨트롤러
        numberOfTags : 태그의 총 개수
        inputedTagsList : 입력된 태그 리스트
        totalTagList : 모든 태그의 리스트

        <Method>
        inputedChipsList : 입력된 칩 리스트를 반환
        sendTags : 입력된 CustomTags를 백엔드로 전송
        receiveTags : 사용자의 Tags를 백엔드에서 받아옴

    - Total_Controller.dart : 앱 전체적으로 사용되는 전역변수들 모아두는 컨트롤러
        
        <variable>
        isLoginSuccess : 현재 로그인 상태를 관리하는 boolean 변수

        <method>
        reverseLoginState : isLoginSuccess 값을 뒤집는 함수
        
    
## Screen : UI Screen, 전체 코드가 합쳐지는 부분
    
    - Default_Tab_Body.dart : 새로운 탭이 만들어질때 제작되는 틀인 클래스. workingSpace로 작업창 부분 초기화가 가능하다.

    - Home_Screen.dart : 탭뷰가 처음 렌더링 되거나 홈 아이콘 클릭시 보여지는 스크린이다. 메뉴바, 대시보드, 작업창 영역으로 구분되어 있으며 작업창 영역은 최근 기록 페이지로 고정시켜놓았다. 다른 기능이나 폴더 클릭시 새 탭이 열리면서 작업창 내용을 업데이트한다.

    - Home_Tabview.dart : 로그인 후 UI의 가장 위에 존재하는 위젯이다. 헤더에 홈 아이콘 모양의 버튼을 두었으며 맨 처음 Screen 렌더링 또는 아이콘 클릭시 homeScreen이 stack 방식으로 렌더링된다. 그렇기에 홈 스크린의 색깔을 완전 불투명하게 해야 다른 탭의 내용이 보이지 않는다.

    - Login_Screen.dart : 로그인 스크린이다. 왼쪽에는 앱에 대한 설명과 유튜브 보기 등을 넣어두었으며 오른쪽 부분에는 아이디, 비밀번호, 회원가입 관련 위젯이 존재한다.

    - Pdf_Save_Screen.dart : Pdf를 저장하는 스크린이다. Pdf_Viewer_Screen에서 저장 버튼을 누르면 나오는 스크린으로, 문제 제목, 디렉토리, 태그 등을 사용자가 정해 저장하는 기능이 있는 스크린이다.

    - Pdf_Viewer_Screen.dart : Pdf Viewer로, 드래그하거나 file_picker를 이용해 pdf를 입력받으면 pdf뷰어가 실행된다.

    - Search_Screen.dart : 검색 오버레이에서 검색버튼을 클릭하였을 때 나오는 스크린으로, 왼쪽에 검색 하위 속성 선택 버튼이 있고 workspace에 해당 문제들이 나열되는 스크린이다.

    - Tag_Management_Screen.dart : 커스텀 태그 입력 스크린


    


## Main.dart : run 또는 디버깅할 시 가장 먼저 실행되는 파일.
