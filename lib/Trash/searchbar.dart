/*
  Widget searchBar(controller) {
    return Overlay(
      child: DefaultTextBox(
        controller: controller.searchBarController,
        placeholder: "SearchBar",
        prefix: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: material.Icon(material.Icons.search),
        ),
        suffix: const material.Icon(material.Icons.arrow_forward_ios),
        onChanged: (value) => controller.searchBarController.text,
        onEditingComplete: () {
          tabController.isHomeScreen.value = false;
          Tab newTab = tabController.addTab(SearchScreen(), "SearchScreen");
          tabController.tabs.add(newTab);
          tabController.currentTabIndex.value = tabController.tabs.length - 1;
        },
      ),
    );
  }
*/