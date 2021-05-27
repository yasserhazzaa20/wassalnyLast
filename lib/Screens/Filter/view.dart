import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wassalny/Components/CustomWidgets/MyText.dart';
import 'package:wassalny/Components/CustomWidgets/appBar.dart';
import 'package:wassalny/Components/CustomWidgets/myColors.dart';
import 'package:wassalny/Components/CustomWidgets/showdialog.dart';
import 'package:wassalny/Screens/Location/view.dart';
import 'package:wassalny/Screens/SetAddress/view.dart';
import 'package:wassalny/model/home.dart';

class Filter extends StatefulWidget {
  final int searchType;
  Filter(this.searchType);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  TextEditingController _search = TextEditingController();

  String city;
  int cityId;

  Widget filter(Widget widget) => Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: widget);

  Widget searchContainer(Function onTap, String title) => InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(40),
                // height: 100,
                // width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.pinkAccent),
                child: MyText(
                    alien: TextAlign.center,
                    title: title,
                    color: Colors.white,
                    weight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    List<AllCategory> allCategories =
        Provider.of<HomeLists>(context).allCategories;
    List<AllCategory> cities = allCategories;

    return Scaffold(
      appBar: titleAppBar(context, "filter".tr),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
              )),
          // SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MyText(
                    alien: TextAlign.center,
                    title: "TextInLangScreen".tr,
                    weight: FontWeight.w500,
                    size: 25),
              ),
            ],
          ),
          // SizedBox(height: 20),
          // filter(
          //   TransparentTextField(
          //     controller: _search,
          //     hint: "Searchbyservicename".tr,
          //     onTap: () {},
          //     icon: Icon(Icons.search, color: Colors.white),
          //   ),
          // ),
          SizedBox(height: 20),
          filter(
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.blue[300],
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: citiesWidget(
                        context,
                        cities,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // _modalBottomSheetMenu(context, cities),
              child: Row(
                children: [
                  Expanded(
                      child: Text(city == null ? "categories".tr : city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17))),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30)
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: searchContainer(
                    cityId == null
                        ? () {
                            showErrorDaialog(
                                "Pleaseenterthesectionfirst".tr, context);
                          }
                        : () {
                            Get.to(
                              MapPage(
                                id: cityId,
                                searchType: widget.searchType,
                              ),
                            );
                          },
                    "Searchbymap".tr),
              ),
              SizedBox(width: 20),
              Expanded(
                child: searchContainer(
                    cityId == null
                        ? () {
                            showErrorDaialog(
                                "Pleaseenterthesectionfirst".tr, context);
                          }
                        : () {
                            Get.to(SetAddress(
                              name: _search.text.toString(),
                              vategory: cityId,
                              searchType: widget.searchType,
                            ));
                          },
                    "adress".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _modalBottomSheetMenu(BuildContext context, List<AllCategory> cities) {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     context: context,
  //     builder: (builder) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return citiesWidget(context, cities);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget citiesWidget(BuildContext context, List<AllCategory> cities) {
    return ListView.builder(
      itemCount: cities.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              city = cities[index].categoryName;
              cityId = cities[index].catId;
            });
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Offstage(
                    offstage: city == cities[index].categoryName ? false : true,
                    child: Icon(Icons.check_circle, color: MyColors.green)),
                // SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Center(
                      child: MyText(
                        title: cities[index].categoryName,
                        size: 18,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
