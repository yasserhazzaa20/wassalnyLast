import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:wassalny/Components/CustomWidgets/customTextField.dart';
import 'package:wassalny/Components/CustomWidgets/showdialog.dart';
import 'package:wassalny/Components/networkExeption.dart';
import 'package:wassalny/Screens/BattomBar/view.dart';
import 'package:wassalny/Screens/endOrderScreen/selectUrLocation.dart';
import 'package:wassalny/model/endOrderProvider.dart';

class EndOrderScreen extends StatefulWidget {
  final int id;

  const EndOrderScreen({Key key, this.id}) : super(key: key);
  @override
  _EndOrderScreenState createState() => _EndOrderScreenState();
}

class _EndOrderScreenState extends State<EndOrderScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController adress = TextEditingController();
  TextEditingController anotherAdress = TextEditingController();
  String addresss;
  double lat;
  double lng;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String lang = Get.locale.languageCode;

  Future<void> _submit() async {
    bool done = Provider.of<EndOrderProvider>(context, listen: false).doneSub;
    if (!key.currentState.validate()) {
      return;
    }
    key.currentState.save();
    showDaialogLoader(context);

    try {
      done = await Provider.of<EndOrderProvider>(context, listen: false)
          .subscribtion(
              adress: adress.text,
              anotherAdress: anotherAdress.text,
              language: lang,
              name: name.text,
              phone: phone.text,
              lat: lat,
              lng: lng,
              orderId: widget.id);
    } on HttpExeption catch (error) {
      Navigator.of(context).pop();
      showErrorDaialog(error.message, context);
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      showErrorDaialog("NoInternet".tr, context);
    } finally {
      Navigator.of(context).pop();
      if (done == true) {
        qrWithFunctionDaialog(
          "DoneSendingOrder".tr,
          context,
          "OrderDone".tr,
          () => Get.offAll(
            BottomNavyView(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ShippingDetails".tr,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Form(
                key: key,
                child: Column(
                  children: [
                    ProfileTextField(
                      hint: "name".tr,
                      controller: name,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Thisfieldisrequired".tr;
                        } else if (val.length <= 4) {
                          return "NameMust4Cracters".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileTextField(
                      hint: "phone".tr,
                      controller: phone,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Thisfieldisrequired".tr;
                        } else if (val.length <= 7) {
                          return "PhoneMust7Cracters".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileTextField(
                      hint: "adress".tr,
                      controller: adress,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Thisfieldisrequired".tr;
                        } else if (val.length <= 7) {
                          return "AdressMust7Cracters".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileTextField(
                      hint: "adress".tr,
                      controller: anotherAdress,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push<LocationModel>(
                            PageRouteBuilder(pageBuilder: (_, __, ___) {
                          return SelectUrLocationScreen();
                        })).then((LocationModel location) {
                          addresss = location.address;
                          lat = location.lat;
                          lng = location.lng;
                          print('$addresss adress ++++++++++++');
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: lat == null
                              ? Text(
                                  "ChooseLocation".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontFamily: 'GE-Snd-Book'),
                                )
                              : Text(
                                  addresss,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontFamily: 'GE-Snd-Book'),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              InkWell(
                onTap: _submit,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      'اتمام الطلب',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

qrWithFunctionDaialog(
    String masseage, BuildContext context, String title, Function function) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        title: Text(title),
        content: Text(
          masseage,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [FlatButton(onPressed: function, child: Text('ok'.tr))],
      );
    },
  );
}

class LocationModel {
  final double lat;
  final double lng;
  final String address;
  const LocationModel({
    this.lat,
    this.lng,
    this.address,
  });
}
