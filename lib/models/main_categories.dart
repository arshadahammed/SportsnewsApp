class MainCategories {
  final String id, name, svg;

  MainCategories({
    required this.id,
    required this.name,
    required this.svg,
  });
}

List<MainCategories> allCategories = [
  MainCategories(
    id: "1",
    name: "Football",
    svg: "assets/icons/category/football2.svg",
  ),
  MainCategories(
    id: "2",
    name: "Cricket",
    svg: "assets/icons/category/cricket1.svg",
  ),
  MainCategories(
    id: "3",
    name: "tennis",
    svg: "assets/icons/category/tennis.svg",
  ),
  MainCategories(
    id: "4",
    name: "Others",
    svg: "assets/icons/category/tennis2.svg",
  ),
];
