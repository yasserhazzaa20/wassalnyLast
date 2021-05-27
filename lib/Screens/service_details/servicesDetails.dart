import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:wassalny/Components/CustomWidgets/showdialog.dart';
import 'package:wassalny/Screens/Branches/view.dart';
import 'package:wassalny/Screens/Home/drawer.dart';
import 'package:wassalny/Screens/min/view.dart';
import 'package:wassalny/Screens/service_details/services_offer.dart';
import 'package:wassalny/model/itemServicesDetail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class ServicesDetails extends StatefulWidget {
  final int id;

  const ServicesDetails({this.id});
  @override
  _ServicesDetailsState createState() => _ServicesDetailsState();
}

class _ServicesDetailsState extends State<ServicesDetails> {
  bool loader = false;
  // Completer<GoogleMapController> _controller = Completer();
  // Set<Marker> marker = {};
  ScrollController _customController = ScrollController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String counterr, value = '';
  Future counter() async {
    counterr = await FlutterBarcodeScanner.scanBarcode(
        '#004297', 'colse', true, ScanMode.DEFAULT);
    setState(() {
      value = counterr;
    });
    return value;
  }

  Widget imageCarousel() {
    final hight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    List<AllSlider> sliderImageInMain =
        Provider.of<ItemServicesDetail>(context, listen: false).allslider;
    if (sliderImageInMain.isEmpty || sliderImageInMain == null) {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: hight * 0.02),
      child: Container(
        height: hight * 0.3,
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
                  return Image.network(
                    e.img,
                    fit: BoxFit.fill,
                  );
                },
              ).toList(),
              autoplay: false,
              dotSize: 7.0,
              overlayShadow: true,
              dotColor: Colors.blue,
              indicatorBgPadding: 1.0,
              dotBgColor: Colors.transparent),
        ),
      ),
    );
  }

  String lang = Get.locale.languageCode;

  Future<void> getDetails() async {
    setState(() {
      loader = true;
    });
    Provider.of<ItemServicesDetail>(context, listen: false).cobon = 0;
    try {
      await Provider.of<ItemServicesDetail>(context, listen: false)
          .fetchAllDetails(widget.id, lang);

      setState(() {
        loader = false;
      });
    } catch (e) {}
  }

  bool cobonLoader = false;

  Future<void> getcobon() async {
    setState(() {
      cobonLoader = true;
    });
    try {
      await Provider.of<ItemServicesDetail>(context, listen: false)
          .getCobon(widget.id);

      setState(() {
        cobonLoader = false;
      });
    } catch (e) {}
  }

  bool qrloader = false;
  Future<void> getQr(qr) async {
    setState(() {
      loader = true;
    });
    try {
      await Provider.of<ItemServicesDetail>(context, listen: false)
          .qr(qr, lang);

      setState(() {
        loader = false;
      });
      final provider = Provider.of<ItemServicesDetail>(context, listen: false);

      qrDaialog(provider.number.toString(), context, provider.message);
    } catch (e) {}
  }

  Widget cobonNum() {
    final info = Provider.of<ItemServicesDetail>(context, listen: false);
    if (info.cobon.toString() == '') {
      setState(() {});
      return AutoSizeText(
        'nodiscountcoupons'.tr,
        style: TextStyle(color: Colors.blue[400]),
        maxLines: 1,
      );
    } else {
      return AutoSizeText(
        info.cobon.toString(),
        style: TextStyle(color: Colors.blue[400]),
        maxLines: 1,
      );
    }
  }

  YoutubePlayerController _youtubePlayerController;
  String linnk() {
    String link =
        Provider.of<ItemServicesDetail>(context, listen: false).videoLink;
    if (link == null) {
      return 'https://www.youtube.com/watch?v=PakAvfdXi5I';
    } else if (link.isEmpty) {
      return 'https://www.youtube.com/watch?v=PakAvfdXi5I';
    }
    return link;
  }

  String url() {
    String phone =
        Provider.of<ItemServicesDetail>(context, listen: false).whatsapp;
    return "whatsapp://send?phone=$phone";
  }
  // double lat() {
  //   return double.parse(Provider.of<ItemServicesDetail>(context).lat);
  // }

  // double lang() {
  //   return double.parse(Provider.of<ItemServicesDetail>(context).lag);
  // }

  @override
  void initState() {
    // print(linnk());
    getDetails().then((value) {
      String videoId;
      videoId = YoutubePlayer.convertUrlToId(
          Provider.of<ItemServicesDetail>(context, listen: false).videoLink);
      print(videoId);
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: true,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(() {});
    });

    // .then((value) {
    //   marker.add(
    //     Marker(
    //       markerId: MarkerId('MyMarker'),
    //       draggable: false,
    //       position: LatLng(
    //         double.parse(
    //             Provider.of<ItemServicesDetail>(context, listen: false).lat),
    //         double.parse(
    //             Provider.of<ItemServicesDetail>(context, listen: false).lag),
    //       ),
    //     ),
    //   );
    // });

    // _videoPlayerController = VideoPlayerController.network(
    //      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4')
    //   ..setVolume(1.0)
    //   ..setLooping(true)
    //   ..initialize().then((value) {
    //     setState(() {
    //       _videoPlayerController.play();
    //     });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _youtubePlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<ItemServicesDetail>(context, listen: false);
    final width = (MediaQuery.of(context).size.width);
    final higt = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    print(widget.id);
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              SizedBox(
                width: width * 0.25,
              ),
              Image.asset('assets/images/logo.png', width: 50),
              Spacer(),
              InkWell(
                child: Image.asset(
                  'assets/images/qr.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                ),
                onTap: () => counter().then((value) {
                  if (value < 0) {
                    print('object');
                  } else {
                    getQr(value);
                  }
                }),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: true),
      drawer: MyDrawer(),
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    int.parse(info.sliderType) == 0
                        ? imageCarousel()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: YoutubePlayer(
                                controller: _youtubePlayerController,
                                bottomActions: [
                                  CurrentPosition(),
                                  ProgressBar(
                                    isExpanded: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: higt * 0.015,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                int.parse(info.delivary) == 0 ||
                                        int.parse(info.delivary) == null
                                    ? SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                                    : SizedBox(
                                        width: width * 0.35,
                                        child: RaisedButton(
                                          color: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          onPressed: () {},
                                          child: AutoSizeText(
                                            "delivery".tr,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                int.parse(info.delivary) == 0 ||
                                        int.parse(info.delivary) == null
                                    ? SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                                    : SizedBox(
                                        width: width * 0.02,
                                      ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.35,
                                      child: cobonLoader == true
                                          ? Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 15,
                                              ),
                                            )
                                          : RaisedButton(
                                              onPressed: getcobon,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              color: Colors.blue,
                                              child: AutoSizeText(
                                                '${'coupon'.tr}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                maxLines: 1,
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: width * 0.025,
                                    ),
                                    cobonLoader == true
                                        ? Center(
                                            child: CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                          )
                                        : info.cobon == 0
                                            ? Text('')
                                            : info.cobon == null
                                                ? AutoSizeText(
                                                    'nodiscountcoupons'.tr,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue[400]),
                                                    maxLines: 1,
                                                  )
                                                : AutoSizeText(
                                                    info.cobon.toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue[400]),
                                                    maxLines: 1,
                                                  )
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.35,
                                  child: RaisedButton(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: AutoSizeText(
                                      "deliverMap".tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      maxLines: 1,
                                    ),
                                    onPressed: () async {
                                      await launch('http:${info.loctaation}');
                                    },
                                  ),
                                ),
                                // InkWell(
                                //   onTap: () async {
                                //     await launch('tel:${info.phone}');
                                //   },
                                //   child: AutoSizeText(
                                //     info.phone,
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //     ),
                                //     maxLines: 1,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Container(
                                height: higt * 0.13,
                                width: higt * 0.12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    info.offersImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                info.serviceName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.025, vertical: higt * .01),
                      child: Container(
                        height: higt * 0.25,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: higt * 0.01),
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DraggableScrollbar.arrows(
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: Colors.blue,
                          controller: _customController,
                          child: ListView(
                            padding: EdgeInsets.only(right: width * 0.06),
                            controller: _customController,
                            children: [
                              info.phoneSecond.isEmpty ///////////
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        await launch('tel:${info.phoneSecond}');
                                      },
                                      child: AutoSizeText(
                                        info.phoneSecond,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        // maxLines: 1,
                                      ),
                                    ),
                              info.phoneThird.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        await launch('tel:${info.phoneThird}');
                                      },
                                      child: AutoSizeText(
                                        info.phoneThird,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        // maxLines: 1,
                                      ),
                                    ),
                              info.phoneSecond.isEmpty &&
                                      info.phoneThird.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : SizedBox(
                                      height: higt * 0.01,
                                    ),
                              info.email.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        await launch('mailto:${info.email}');
                                      },
                                      child: AutoSizeText(
                                        info.email,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        // maxLines: 1,
                                      ),
                                    ),
                              info.address == '' || info.address.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : AutoSizeText(
                                      info.address,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      // maxLines: 2,
                                    ),
                              info.description.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : SizedBox(
                                      height: higt * 0.01,
                                    ),
                              info.description.isEmpty
                                  ? SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : AutoSizeText(
                                      info.description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      // maxLines: 12,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        width: width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: width * 0.3,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  Get.to(Branches(info.idd));
                                },
                                child: AutoSizeText(
                                  "Branches".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.3,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  Get.to(
                                    Min(
                                      id: info.idd,
                                      title: info.menuTilte == null ||
                                              info.menuTilte == ''
                                          ? "menu".tr
                                          : info.menuTilte,
                                    ),
                                  );
                                },
                                child: AutoSizeText(
                                  info.menuTilte == null || info.menuTilte == ''
                                      ? "menu".tr
                                      : info.menuTilte,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.3,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  Get.to(
                                    ServicesOffers(info.mainImg, info.idd,
                                        info.serviceName),
                                  );
                                  // Get.to(Offerss());
                                },
                                child: AutoSizeText(
                                  "offers".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.3,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  // Get.to(ServicesOffers());
                                  // Get.to(Offerss());
                                },
                                child: info.points.isEmpty
                                    ? AutoSizeText(
                                        "${"Points".tr} = 0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        maxLines: 1,
                                      )
                                    : AutoSizeText(
                                        "${"Points".tr} : ${info.points}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        maxLines: 1,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // info.lag.isEmpty
                    //     ? SizedBox(
                    //         width: 0,
                    //         height: 0,
                    //       )
                    //     : Padding(
                    //         padding:
                    //             EdgeInsets.symmetric(vertical: higt * 0.01),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(15),
                    //           child: Container(
                    //             height: higt * 0.2,
                    //             child: GoogleMap(
                    //               mapType: MapType.normal,
                    //               onMapCreated:
                    //                   (GoogleMapController controller) {
                    //                 _controller.complete(controller);
                    //               },
                    //               initialCameraPosition: CameraPosition(
                    //                 target: LatLng(double.parse(info.lat),
                    //                     double.parse(info.lag)),
                    //                 zoom: 14.4746,
                    //               ),
                    //               markers: Set.from(marker),
                    //               myLocationEnabled: true,
                    //               myLocationButtonEnabled: true,
                    //               onTap: (val) {
                    //                 print(val);
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        padding: EdgeInsets.all(
                          width * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IntrinsicHeight(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                info.phone.isEmpty
                                    ? Container()
                                    : InkWell(
                                        child: Image.asset(
                                          'assets/images/phoneicon.png',
                                          width: width * 0.12,
                                          height: higt * 0.07,
                                          fit: BoxFit.fill,
                                        ),
                                        onTap: () async {
                                          await launch('tel:${info.phone}');
                                        },
                                      ),
                                info.instagram.isEmpty
                                    ? Container()
                                    : VerticalDivider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                info.instagram.isEmpty
                                    ? Container()
                                    : InkWell(
                                        child: Image.asset(
                                          'assets/images/instagram.png',
                                          width: width * 0.12,
                                          height: higt * 0.07,
                                          fit: BoxFit.fill,
                                        ),
                                        onTap: () async {
                                          await launch(
                                              'http:${info.instagram}');
                                        },
                                      ),
                                info.twitter.isEmpty
                                    ? Container()
                                    : VerticalDivider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                info.twitter.isEmpty
                                    ? Container()
                                    : InkWell(
                                        child: Container(
                                          width: width * 0.12,
                                          height: higt * 0.07,
                                          child: Image.asset(
                                            'assets/images/twitter.png',
                                            width: width * 0.12,
                                            height: higt * 0.07,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        onTap: () async {
                                          await launch('http:${info.twitter}');
                                        },
                                      ),
                                info.facebook.isEmpty
                                    ? Container()
                                    : VerticalDivider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                info.facebook.isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () async {
                                          await launch('http:${info.facebook}');
                                        },
                                        child: Image.asset(
                                          'assets/images/facebook.png',
                                          width: width * 0.12,
                                          height: higt * 0.07,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                info.whatsapp.isEmpty
                                    ? Container()
                                    : VerticalDivider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                info.whatsapp.isEmpty
                                    ? Container()
                                    : InkWell(
                                        child: Image.asset(
                                          'assets/images/whatsapp.png',
                                          width: width * 0.12,
                                          height: higt * 0.07,
                                          fit: BoxFit.fill,
                                        ),
                                        onTap: () async {
                                          await launch(url());
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }
}
