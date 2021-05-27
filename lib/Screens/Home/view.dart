import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';
import 'package:wassalny/Components/CustomWidgets/customTextField.dart';
import 'package:wassalny/Components/CustomWidgets/showdialog.dart';
import 'package:wassalny/Screens/CategoryList/view.dart';
import 'package:wassalny/Screens/Filter/view.dart';
import 'package:wassalny/Screens/searchScreen/searchScreen.dart' as Search;
import 'package:wassalny/Screens/service_details/servicesDetails.dart';
import 'package:wassalny/model/home.dart';
import 'package:wassalny/model/homeSearch.dart';

import 'drawer.dart';
import 'gridWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scafold2 = GlobalKey<ScaffoldState>();
  TextEditingController _search = TextEditingController();
  String lang = Get.locale.languageCode;

  Widget restaurant(String image) => Expanded(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/$image.png"),
            ),
          ),
        ),
      );
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  Future<void> _submit() async {
    bool doneSearching =
        Provider.of<SearchName>(context, listen: false).doneSearching;
    final provider = Provider.of<SearchName>(context, listen: false);
    provider.searchName.clear();
    if (!key.currentState.validate()) {
      return;
    }
    key.currentState.save();
    showDaialogLoader(context);
    try {
      doneSearching =
          await provider.fetchSearch(_search.text.toString(), 100, 0, lang);
      // ignore: unused_catch_clause
    } catch (error) {
      print(error);
      Navigator.of(context).pop();
      showErrorDaialog("NoInternet".tr, context);
    } finally {
      if (doneSearching) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.of(context).pop();
          Get.to(Search.SearchScreen(
            name: _search.text,
            search: Provider.of<SearchName>(context, listen: false).searchName,
            searchText: _search.text.toString(),
          ));
        });
      }
    }
  }

  Widget imageCarousel() {
    final width = (MediaQuery.of(context).size.width);
    final hight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    List<MainOffer> sliderImageInMain =
        Provider.of<HomeLists>(context, listen: false).sliderImageInMain;
    return Padding(
      padding: EdgeInsets.only(
          top: hight * 0.048, left: width * 0.048, right: width * 0.048),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _scafold2.currentState.openDrawer(),
                  child: Icon(Icons.menu, color: Colors.blue),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 30,
                    child: Form(
                      key: key,
                      child: TransparentTextFieldColorText(
                          controller: _search,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'PleaseEnterTheSearchWord'.tr;
                            } else {
                              return null;
                            }
                          },
                          hint: "SearchOffers".tr),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: _submit,
                  child: Icon(Icons.search, color: Colors.blue),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: hight * 0.02),
            child: Container(
              height: hight * 0.25,
              decoration: BoxDecoration(
                border: Border(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Carousel(
                    boxFit: BoxFit.fill,
                    images: sliderImageInMain.map(
                      (e) {
                        return InkWell(
                          onTap:
                              e.link.isEmpty || e.link == null || e.link == ''
                                  ? () {}
                                  : () async {
                                      await launch('http:${e.link}');
                                    },
                          child: Image.network(
                            e.image,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ).toList(),
                    autoplay: true,
                    dotSize: 7.0,
                    overlayShadow: true,
                    dotColor: Colors.blue,
                    indicatorBgPadding: 1.0,
                    dotBgColor: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AllRecommended chonsenOne(int position) {
    List<AllRecommended> allrecommended =
        Provider.of<HomeLists>(context, listen: false).recomended;
    AllRecommended selected = allrecommended.firstWhere(
        (element) => element.recommendedPosition == position,
        orElse: () => null);

    return selected;
  }

  bool loader = false;
  final savedLang = GetStorage();

  Future<void> fechHome() async {
    loader = true;
    try {
      await Provider.of<HomeLists>(context, listen: false)
          .fetchHome(lang)
          .then((_) {
        setState(() {
          loader = false;
        });
      });
    } catch (error) {
      showErrorDaialog("NoInternet".tr, context);
    }
  }

  @override
  void initState() {
    fechHome();
    savedLang.write('lang', lang);
    super.initState();
  }

  int mainIDN;
  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);
    final hight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    List<AllCategory> allCategories =
        Provider.of<HomeLists>(context).allCategories;
    List<AllFeature> allfeature =
        Provider.of<HomeLists>(context, listen: false).allfeature;

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      key: _scafold2,
      drawer: MyDrawer(),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 8,
            ))
          : ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                imageCarousel(),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.048),
                  child: AutoSizeText(
                    'Recommended'.tr,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.048),
                  child: Container(
                    height: hight * 0.15,
                    width: width,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02, vertical: hight * 0.01),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                ServicesDetails(
                                  id: chonsenOne(1).serviceId,
                                ),
                              );
                            },
                            child: Container(
                              width: width * 0.4,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/logo.png',
                                image: chonsenOne(1).recommendedImage == null
                                    ? SizedBox()
                                    : chonsenOne(1).recommendedImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: hight * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ServicesDetails(
                                      id: chonsenOne(2).serviceId,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: hight * 0.06,
                                  width: width * 0.20,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/logo.png',
                                    image:
                                        chonsenOne(2).recommendedImage == null
                                            ? SizedBox()
                                            : chonsenOne(2).recommendedImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ServicesDetails(
                                      id: chonsenOne(6).serviceId,
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.red,
                                  height: hight * 0.06,
                                  width: width * 0.20,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/logo.png',
                                    image:
                                        chonsenOne(6).recommendedImage == null
                                            ? SizedBox()
                                            : chonsenOne(6).recommendedImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.015,
                              vertical: hight * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.22,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(ServicesDetails(
                                          id: chonsenOne(3).serviceId,
                                        ));
                                      },
                                      child: Container(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/logo.png',
                                          image: chonsenOne(3)
                                                      .recommendedImage ==
                                                  null
                                              ? SizedBox()
                                              : chonsenOne(3).recommendedImage,
                                          fit: BoxFit.fill,
                                        ),
                                        width: width * 0.1,
                                        height: hight * 0.06,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          ServicesDetails(
                                            id: chonsenOne(4).serviceId,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/logo.png',
                                          image: chonsenOne(4)
                                                      .recommendedImage ==
                                                  null
                                              ? SizedBox()
                                              : chonsenOne(4).recommendedImage,
                                          fit: BoxFit.fill,
                                        ),
                                        width: width * 0.1,
                                        height: hight * 0.06,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ServicesDetails(
                                      id: chonsenOne(5).serviceId,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: hight * 0.06,
                                  width: width * 0.22,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/logo.png',
                                    image:
                                        chonsenOne(5).recommendedImage == null
                                            ? SizedBox()
                                            : chonsenOne(5).recommendedImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                customGridView(
                  context,
                  allCategories,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(Filter(1));
                          },
                          child: Row(
                            children: [
                              Text(
                                'FastSearch'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.search, color: Colors.indigo),
                              Spacer(),
                              Text(
                                "ReachingTheGoal".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.location_on, color: Colors.indigo)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ...allfeature.map((items) {
                        // ignore: unused_element
                        int mainId() {
                          for (var i = 0; i < allCategories.length; i++) {
                            if (allCategories[i].allDepartment.length > 0) {
                              mainIDN = 0;
                            } else {
                              mainIDN = 1;
                            }
                          }
                          return mainIDN;
                        }

                        return Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => Get.to(
                                  CategoryList(items.catId, 1, 1),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10),
                                      child: Text(
                                        items.categoryName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.blue.withAlpha(40),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  items.categoryImage),
                                              fit: BoxFit.fill),
                                        ),
                                        height: 90,
                                        width: 90),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: items.allProducts.map((e) {
                                    // print("${e.productImage} image");
                                    return Column(children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            ServicesDetails(
                                              id: e.prodId,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.015),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          height: 80,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              e.productImage,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(e.productName),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}