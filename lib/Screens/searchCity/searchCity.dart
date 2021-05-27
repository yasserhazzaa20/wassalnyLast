import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalny/Screens/service_details/servicesDetails.dart';
import 'package:wassalny/model/searchByCity.dart';

// package:wasalny/Screens/service_details/servicesDetails.dart

class SearchCityScreen extends StatefulWidget {
  final List<AllProductCC> search;
  SearchCityScreen({
    this.search,
  });
  @override
  _SearchCityScreenState createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);
    final hight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    print(widget.search.toString());
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: widget.search.isEmpty
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
                  childAspectRatio: MediaQuery.of(context).size.width * .0025,
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                ),
                itemCount: widget.search.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        ServicesDetails(
                          id: widget.search[index].prodId,
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
                                    widget.search[index].productImage),
                              ),
                            ),
                            height: hight * 0.2,
                            width: MediaQuery.of(context).size.width * .3),
                        Text(widget.search[index].productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.043),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
