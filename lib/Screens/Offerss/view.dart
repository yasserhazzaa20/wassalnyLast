import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:wassalny/Components/CustomWidgets/customTextField.dart';
import 'package:wassalny/Screens/Filter/view.dart';
import 'package:wassalny/Screens/Home/drawer.dart';
import 'package:wassalny/Screens/service_details/services_offer.dart';
import 'package:wassalny/model/offers.dart';

class Offerss extends StatefulWidget {
  @override
  _OfferssState createState() => _OfferssState();
}

class _OfferssState extends State<Offerss> {
  GlobalKey<ScaffoldState> _scafold = GlobalKey<ScaffoldState>();
  TextEditingController _search = TextEditingController();

  Widget imageCarousel(List list) {
    return Stack(
      children: [
        Container(
          height: 300,
          child: Stack(
            children: <Widget>[
              Carousel(
                  boxFit: BoxFit.fill,
                  images: list.map(
                    (e) {
                      return NetworkImage(e.image);
                    },
                  ).toList(),
                  autoplay: true,
                  dotSize: 7.0,
                  dotColor: Colors.red,
                  indicatorBgPadding: 1.0,
                  dotBgColor: Colors.transparent)
            ],
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 30,
                  child: TransparentTextFieldColorText(
                      icon: InkWell(
                        onTap: () => _scafold.currentState.openDrawer(),
                        child: Icon(Icons.menu, color: Colors.blue),
                      ),
                      controller: _search,
                      hint: "SearchOffers".tr),
                )),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Get.to(Filter(1));
                  },
                  child: Icon(Icons.search, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool loader = false;
  // ignore: override_on_non_overriding_member
  String lang = Get.locale.languageCode;

  Future<void> future() async {
    loader = true;
    try {
      await Provider.of<AllOffersProvider>(context, listen: false)
          .fetchAllOffers(lang);
      setState(() {
        loader = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        loader = false;
      });
      throw (error);
    }
  }

  @override
  void initState() {
    future();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);
    final hight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    // List<SliderOffer> slideOfferslist =
    //     Provider.of<AllOffersProvider>(context, listen: false).slideOffers;

    List<AllOffer> list =
        Provider.of<AllOffersProvider>(context, listen: false).allOffers;
    List<AllOffer> list1 = list;
    List<AllGallery> allGalleries =
        Provider.of<AllOffersProvider>(context, listen: false).allGalleries;
    return Scaffold(
      key: _scafold,
      drawer: MyDrawer(),
      body: loader
          ? Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: true,
              children: [
                list1.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.4),
                          child: Text(
                            "NoOffres".tr,
                            style: TextStyle(fontSize: 30, color: Colors.blue),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(bottom: hight * 0.13),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list1.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: hight * 0.05,
                                  left: width * 0.02,
                                  right: width * 0.02),
                              child: Container(
                                width: width,
                                // margin: EdgeInsets.only(bottom: hight * 0.02),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black),
                                ),

                                child: Column(children: [
                                  Center(
                                    child: Text(
                                      "${"to".tr} : ${list1[index].endDate}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blue,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.02),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  ServicesOffers(
                                                      list1[index].serviceImage,
                                                      int.parse(list1[index]
                                                          .serviceId),
                                                      list1[index].serviceName),
                                                );
                                              },
                                              child: Container(
                                                width: width * 0.28,
                                                height: hight * 0.17,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    list1[index].serviceImage,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              list1[index].serviceName,
                                            ),
                                            SizedBox(
                                              height: hight * 0.01,
                                            ),
                                            DottedBorder(
                                              color: Colors.black,
                                              borderType: BorderType.RRect,
                                              radius: Radius.circular(15),
                                              padding: EdgeInsets.all(6),
                                              child: Container(
                                                  height: hight * 0.2,
                                                  width: width * 0.35,
                                                  child: ListView(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.5),
                                                        child: AutoSizeText(
                                                            list1[index]
                                                                .description),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  list1[index]
                                                                      .oldPrice,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .blue,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                SizedBox(
                                                                    width: width *
                                                                        0.03),
                                                                Text(
                                                                  list1[index]
                                                                      .newPrice,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   width: width * 0.02,
                                        // ),
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                height: hight * 0.4,
                                                width: width * 0.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Carousel(
                                                    images: allGalleries.map(
                                                      (e) {
                                                        return InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Carousel(
                                                                  images: allGalleries
                                                                      .map((e) => Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Container(
                                                                              child: Image.network(
                                                                                e.offersImage,
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                                  autoplay:
                                                                      false,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Image.network(
                                                            e.offersImage,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                                    'assets/images/logo.png'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    autoplay: true,
                                                    dotSize: 7.0,
                                                    dotColor: Colors.blue,
                                                    indicatorBgPadding: 1.0,
                                                    dotBgColor:
                                                        Colors.transparent),
                                              ),
                                            ),
                                            Text(list1[index].offerName),
                                            SizedBox(
                                              height: hight * 0.02,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
// InkWell(
//                               onTap: () {
//                                 Get.to(Details(
//                                   id: list1[index].offerId,
//                                   image: list1[index].offerImage,
//                                   name: list1[index].offerName,
//                                 ));
//                               },
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     margin:
//                                         EdgeInsets.only(bottom: hight * 0.03),
//                                     height: hight * 0.3,
//                                     width: width,
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: NetworkImage(
//                                               list[index].offerImage),
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                             width: 2, color: Colors.blue)),
//                                   ),
//                                   Positioned(
//                                     top: hight * 0.219,
//                                     child: Container(
//                                       height: hight * 0.08,
//                                       width: width * 0.927,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             bottomLeft: Radius.circular(22),
//                                             bottomRight: Radius.circular(22),
//                                           ),
//                                           color: Colors.black54),
//                                       child: Center(
//                                         child: MyText(
//                                             title: list[index].offerName,
//                                             weight: FontWeight.bold,
//                                             size: 25,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
