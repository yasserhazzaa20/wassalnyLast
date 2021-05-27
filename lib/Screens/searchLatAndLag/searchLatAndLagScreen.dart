import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wassalny/Screens/service_details/servicesDetails.dart';
import 'package:wassalny/model/searchLAndLat.dart';

// package:wasalny/Screens/service_details/servicesDetails.dart

class SearchLatAndLagScreen extends StatefulWidget {
  final int id;
  final double lat;
  final double lag;
  final int searchType;
  const SearchLatAndLagScreen({this.id, this.lag, this.lat, this.searchType});

  @override
  _SearchLatAndLagScreenState createState() => _SearchLatAndLagScreenState();
}

class _SearchLatAndLagScreenState extends State<SearchLatAndLagScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool loader = false;
  String lang = Get.locale.languageCode;

  Future<void> future() async {
    loader = true;
    var provider = Provider.of<SearchLatAndLagProvider>(context, listen: false);
    provider.searchLatAndLag.clear();
    // var nextLength = provider.searchLatAndLag.length + 20;
    try {
      await provider.fetchSearch(
          widget.id, 100, 0, widget.lat, widget.lag, widget.searchType, lang);
      // if (provider.searchLatAndLag.length >= nextLength)
      //   _refreshController.loadComplete();
      // else
      //   _refreshController.loadNoData();

      setState(() {
        loader = false;
      });
      _refreshController.refreshCompleted();
      // _refreshController.loadComplete();
    } catch (error) {
      _refreshController.refreshCompleted();
      // _refreshController.loadComplete();
      print(error);
      setState(() {
        loader = false;
      });
      throw (error);
    }
  }

  // Future<void> fetchMore(int number) async {
  //   try {
  //     var provider =
  //         Provider.of<SearchLatAndLagProvider>(context, listen: false);
  //     var nextLength = provider.searchLatAndLag.length + 20;
  //     await provider.fetchSearch(widget.id, 20, number, widget.lat, widget.lag ,widget.searchType);

  //     // _refreshController.refreshCompleted();
  //     if (provider.searchLatAndLag.length >= nextLength)
  //       _refreshController.loadComplete();
  //     else
  //       _refreshController.loadNoData();
  //   } catch (error) {
  //     print(error);
  //     setState(() {
  //       loader = false;
  //     });
  //     // _refreshController.refreshCompleted();
  //     _refreshController.loadComplete();
  //     throw (error);
  //   }
  // }

  // int pageNumber = 0;
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
    print(widget.id);
    final List<AllProduct> list =
        Provider.of<SearchLatAndLagProvider>(context).searchLatAndLag;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "researchResults".tr,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: loader
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        "NoSearch".tr,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        childAspectRatio:
                            MediaQuery.of(context).size.width * .0025,
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              ServicesDetails(
                                id: list[index].prodId,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          list[index].productImage),
                                    ),
                                  ),
                                  height: hight * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * .3),
                              Text(list[index].productName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        );
                      }),
            ),
    );
  }
}
