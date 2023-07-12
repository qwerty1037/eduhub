//정보를 {아이디, name, 부모 아이디} 형태로 받은 list가 존재한다고 가정. 다음은 예시 데이터. 로그인 즉시 or 프로젝트 선택시 백엔드로부터 폴더 데이터 받기
List<dynamic> example = [
  {
    "id": 1,
    "name": "하이탑",
    "parent_id": null,
  },
  {
    "id": 2,
    "name": "고1",
    "parent_id": 1,
  },
  {
    "id": 3,
    "name": "고2",
    "parent_id": 1,
  },
  {
    "id": 4,
    "name": "중간대비",
    "parent_id": 3,
  },
  {
    "id": 5,
    "name": "기말대비",
    "parent_id": 3,
  },
  {
    "id": 6,
    "name": "고3",
    "parent_id": 1,
  },
];
