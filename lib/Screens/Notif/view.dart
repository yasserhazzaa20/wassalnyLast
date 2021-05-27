import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wassalny/Components/CustomWidgets/appBar.dart';
import 'package:wassalny/model/notifications.dart';

import 'notificationDetails.dart';

class Notififications extends StatefulWidget {
  @override
  _NotifificationsState createState() => _NotifificationsState();
}

class _NotifificationsState extends State<Notififications> {
  ScrollController _scrollController = new ScrollController();

  bool loader = false;
  String lang = Get.locale.languageCode;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // ignore: override_on_non_overriding_member
  Future<void> future() async {
    setState(() {
      loader = true;
    });
    var provider = Provider.of<NotificationsProvider>(context, listen: false);
    provider.allNotification.clear();

    try {
      await provider.fetchNotifications(100, 0);

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

  Future<void> fetchMore(int pageNumberr) async {
    var provider = Provider.of<NotificationsProvider>(context, listen: false);
    var nextLength = provider.allNotification.length + 20;
    try {
      await provider.fetchNotifications(20, pageNumberr);
      if (provider.allNotification.length >= nextLength)
        _refreshController.loadComplete();
      else
        _refreshController.loadNoData();
      _refreshController.loadComplete();
    } catch (error) {
      print(error);
      _refreshController.loadComplete();
      throw (error);
    }
  }

  Future<void> delete(int id) async {
    var provider = Provider.of<NotificationsProvider>(context, listen: false);

    try {
      await provider.deleteNotifications(id, lang);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  int pageNumber = 0;
  @override
  void initState() {
    future();

    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<AllNotification> notifications =
        Provider.of<NotificationsProvider>(context, listen: false)
            .allNotification;
    return Scaffold(
      appBar: newAppBar(context, "notifications".tr),
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    "ThereAreNoNotifications".tr,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(NotificationsDetails(
                              id: notifications[index].id,
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: notifications[index].isRead == 1
                                  ? Colors.grey.shade300
                                  : Colors.blue[100],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      notifications[index].createdAt.toString(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        delete(notifications[index].id)
                                            .then((value) => future());
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(notifications[index].body,
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
