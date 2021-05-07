import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todoooo/constants.dart';

showAlertDialogBiometric(BuildContext context, bool colorHandler,
    {Function(bool) okPressed,
    Function(bool) cancelPressed,
    VoidCallback disabledPressed}) {
  bool isEnabled = colorHandler;

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Stack(
      children: [
        Column(
          children: [
            Center(
              child: Image.asset(
                "images/fingerprint.png",
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
            ),
            Text("Biometric", style: TextStyle(color: AppColors.appTheme)),
          ],
        ),
        GestureDetector(
          child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.red,
              )),
          onTap: () {
            cancelPressed(isEnabled);
          },
        )
      ],
    ),
    content: Container(
      height: MediaQuery.of(context).size.height / 4,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "You will be able to use your face or Fingerprint instead of your password to log in to MobilitySQR.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(),
          Text("To set this up Enable Biometric.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: AppColors.appTheme)),
                  color: isEnabled
                      ? AppColors.appTheme
                      : AppColors.TextColour_light,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    okPressed(isEnabled);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: AutoSizeText(
                      "Enable".toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                        color: AppColors.appTheme,
                      )),
                  color: isEnabled
                      ? AppColors.appTheme
                      : AppColors.TextColour_light,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2.0),
                  onPressed: () {
                    disabledPressed();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Disable".toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(),
          Text("Your User ID will be saved to this Device.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
