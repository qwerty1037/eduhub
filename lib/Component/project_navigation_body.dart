import 'package:fluent_ui/fluent_ui.dart';

class ProjectNavigationBody extends StatelessWidget {
  ProjectNavigationBody({super.key, this.projectName});
  String? projectName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropDownButton(
                  placement: FlyoutPlacementMode.bottomRight,
                  title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: Center(
                      child: Text(
                        projectName == null ? "New Project" : projectName!,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  items: [
                    MenuFlyoutItem(text: const Text('프로젝트 이름 변경'), onPressed: () {}),
                    MenuFlyoutItem(text: const Text('프로젝트 삭제'), onPressed: () {}),
                    MenuFlyoutItem(text: const Text('팀 정보'), onPressed: () {}),
                  ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Button(
                      child: const Text(
                        "초대",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {}),
                  const SizedBox(
                    width: 20,
                  ),
                  Button(
                      child: const Row(
                        children: [
                          Icon(FluentIcons.contact),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "1",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      onPressed: () {}),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: Button(
                          child: const Center(
                            child: Text(
                              "문제 추가",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          onPressed: () {})),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: Button(
                          child: const Center(
                            child: Text(
                              "시험지 생성",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          onPressed: () {})),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: Button(
                          child: const Center(
                            child: Text(
                              "문제 검색",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          onPressed: () {})),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    child: Button(
                      child: const Center(
                        child: Text(
                          "학생 관리",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}
