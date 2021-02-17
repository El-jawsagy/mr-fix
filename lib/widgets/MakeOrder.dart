import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mr_fix/Network_utils/Service_Network.dart';
import 'package:mr_fix/Network_utils/order_Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UI/SimilarWidgets.dart';
import '../main.dart';

class MakeOrder extends StatefulWidget {
  String title, description, image, hintText, labelText;
  int serviceId;
  int fees;
  double rating;

  MakeOrder(
      {this.serviceId,
      this.title,
      this.description,
      this.fees,
      this.image,
      this.rating,
      this.labelText,
      this.hintText});

  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = new TextEditingController();
  OrderAndReviewNetwork orderNetwork =  OrderAndReviewNetwork();
  ServiceNetwork serviceNetwork =  ServiceNetwork();
  SimilarWidgets similarWidgets = new SimilarWidgets();
  bool isChecked;

  @override
  void initState() {
    isChecked = false;
    // TODO: implement initState
    super.initState();
  }

  // String translate =
  // 'en';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 24.0, right: 10, left: 10, bottom: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                        child: widget.image == "" || widget.image == null
                            ? Icon(
                                Icons.build,
                                size: 37,
                              )
                            : Image.network(
                                "https://mr-fix.org" + widget.image,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Row(
                    mainAxisAlignment: translate == 'en'
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        translate == 'en' ? "Description :" : ": تفاصيل"
                        /*AppLocalizations.of(context).translate("Description")*/,
                        style: TextStyle(
                            //fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600),
                        textAlign: translate == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Container(
                    padding: translate == 'en'
                        ? EdgeInsets.only(left: 16)
                        : EdgeInsets.only(right: 16),
                    child: Center(
                      child: Html(
                        data: widget.description == null
                            ? ''
                            : widget.description,
                        customTextAlign: (t) {
                          return TextAlign.center;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Row(
                    mainAxisAlignment: translate == 'en'
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        translate == 'en'
                            ? "Rating for service :"
                            : ": تقييم الخدمة"
                        /*AppLocalizations.of(context).translate("Description")*/,
                        style: TextStyle(
                            //fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600),
                        textAlign: translate == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  widget.rating == null
                      ? _drawNonRatingRow()
                      : _drawRatingRow(),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Container(
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText:
                            translate == 'ar' ? 'التفاصيل' : 'Description',
                        hintText:
                            translate == 'ar' ? 'ملاحظاتك' : 'Your Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide()),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Title field cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  (widget.fees == 1)
                      ? Row(
                          children: <Widget>[
                            Checkbox(
                              value: isChecked,
                              onChanged: (val) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              activeColor: Colors.amber,
                              checkColor: Colors.grey,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 30),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.76,
                              child: Text(
                                translate == 'en'
                                    ? "to complete your request you must confirm preview fees"
                                    : "لإكمال طلبك ، يجب عليك تأكيد رسوم المعاينة‎",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  (widget.fees == 1)
                      ? (isChecked
                          ? Center(
                              child: FlatButton(
                                onPressed: () {
                                  // TODO: implement validate function
                                  // validateForm();
                                  //validateForm();
                                  validateForm();
                                },
                                child: Text(
                                  translate == 'en'
                                      ? "Make Order"
                                      : "اطلب الان",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.yellow,
                                //splashColor: Colors.indigo,
                                padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width / 6,
                                    15,
                                    MediaQuery.of(context).size.width / 6,
                                    15),
                              ),
                            )
                          : Center(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width / 6,
                                    15,
                                    MediaQuery.of(context).size.width / 6,
                                    15),
                                child: Text(
                                  translate == 'en'
                                      ? "Make Order"
                                      : "اطلب الان",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ))
                      : Center(
                          child: FlatButton(
                            onPressed: () {
                              // TODO: implement validate function

                              validateForm();
                            },
                            child: Text(
                              translate == 'en' ? "Make Order" : "اطلب الان",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            shape: StadiumBorder(),
                            color: Colors.yellow,
                            //splashColor: Colors.indigo,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width / 6,
                                15,
                                MediaQuery.of(context).size.width / 6,
                                15),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int id = prefs.get("idPref");
      String loct = prefs.get("locationPref");
      print("here id $loct");
      if (loct == null || loct == "null") {
         similarWidgets.showDialogWidget(
            translate == 'en'
                ? "you"
                : "تحتاج تحديد مكانك الحالى لطلب الخدمة",
            context);
      }

      Map<String, dynamic> list = await serviceNetwork.certainService(
          'https://mr-fix.org/' +
              translate +
              '/api/services/' +
              '${widget.serviceId}' +
              '?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv');

      bool result = await orderNetwork
          .makeOrder('https://mr-fix.org/en/api/makeorder', body: {
        'token': 'hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',
        'user_id': '$id',
        'client_id':
            '${list['client_id'] == null || list['client_id'] == "" ? 3 : list['client_id']}',
        'service_id': '${widget.serviceId}',
        'order_details': descriptionController.text,
        'location': loct
      });

      if (result) {
        Navigator.of(context).pop();

        similarWidgets.showDialogWidget(
            translate == 'en'
                ? "Your Order is placed successfully, We will contact with you as soon as possible"
                : "تم ارسال الطلب بنجاح, سوف نتواصل معك",
            context);
      } else {
        similarWidgets.showDialogWidget(
            translate == 'en'
                ? "Your Order is failed please try again"
                : "لم يتم ارسال طلب, برجاء حاول مرة اخري",
            context);
      }

      formState.reset();
    }
  }

  Widget _drawNonRatingRow() {
    return Padding(
        padding: EdgeInsets.only(
          left: translate == 'en' ? 16 : 0,
          right: translate == 'en' ? 0 : 16,
        ),
        child: translate == 'en'
            ? Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Text(
                      "Wating for your rating",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Text("بانتظار تقيمك",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.right),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 30),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 30,
                  ),
                ],
              ));
  }

  Widget _drawRatingRow() {
    return Padding(
      padding: EdgeInsets.only(
        left: translate == 'en' ? 16 : 0,
        right: translate == 'en' ? 0 : 16,
      ),
      child: translate == 'en'
          ? Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 35,
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  child: Text(
                    "${widget.rating.toString()}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              ],
            )
          : Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  child: Text(
                    "${widget.rating.toString()}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 30),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 35,
                ),
              ],
            ),
    );
  }
}
