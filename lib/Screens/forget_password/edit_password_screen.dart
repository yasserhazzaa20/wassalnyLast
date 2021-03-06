import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:wassalny/Components/CustomWidgets/CustomButton.dart';
import 'package:wassalny/Components/CustomWidgets/customTextField.dart';
import 'package:wassalny/Components/CustomWidgets/showdialog.dart';
import 'package:wassalny/Screens/login/view.dart';
import 'package:wassalny/network/auth/auth.dart';

class EditPassword extends StatefulWidget {
  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  var phone = TextEditingController();

  var newPassword = TextEditingController();

  var confirmNewPassword = TextEditingController();

  IconData icon = Icons.visibility;
  IconData icon2 = Icons.visibility;

  bool isPassword = true;
  bool confirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 80,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                  controller: phone,
                  hint: "phoneNumber".tr,
                  type: TextInputType.phone),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: newPassword,
                  hint: "newPassword".tr,
                  suffixIcon: icon,
                  isPassword: isPassword,
                  suffixPress: () {
                    isPassword = !isPassword;
                    isPassword
                        ? icon = Icons.visibility
                        : icon = Icons.visibility_off_outlined;
                    setState(() {});
                  },
                  type: TextInputType.visiblePassword),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: confirmNewPassword,
                  hint: "confirmNewPassword".tr,
                  suffixIcon: icon2,
                  isPassword: confirmPassword,
                  suffixPress: () {
                    confirmPassword = !confirmPassword;
                    confirmPassword
                        ? icon2 = Icons.visibility
                        : icon2 = Icons.visibility_off_outlined;
                    setState(() {});
                  },
                  type: TextInputType.visiblePassword),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blue,
                  isShadow: 1,
                  onTap: () async {
                    bool auth =
                        Provider.of<Auth>(context, listen: false).editPassword;
                    showDaialogLoader(context);
                    try {
                      auth = await Provider.of<Auth>(context, listen: false)
                          .changePassword(
                              phoneNumber: phone.text,
                              password: newPassword.text,
                              confirmPassword: confirmNewPassword.text);
                      // ignore: unused_catch_clause
                    } catch (error) {
                      print(error);
                      Navigator.of(context).pop();
                      showErrorDaialog('No internet connection', context);
                    } finally {}
                    if (auth) {
                      Get.offAll(Login());
                    }
                  },
                  textColor: Colors.white,
                  label: 'changePassword'.tr),
            ],
          ),
        ),
      ),
    );
  }
}
