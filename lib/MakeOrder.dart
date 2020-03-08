import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network_utils/Pages_Network.dart';
import 'UI/SimilarWidgets.dart';
import 'main.dart';

class MakeOrder extends StatefulWidget {
  String title, description, image;
  int serviceId;
  int fees;
  double rating;

  MakeOrder(
      {this.serviceId,
      this.title,
      this.description,
      this.fees,
      this.image,
      this.rating});

  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = new TextEditingController();
  PagesNetwork pagesNetwork = new PagesNetwork();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 16.0, right: 10, left: 10, bottom: 16),
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
                              "http://mr-fix.org" + widget.image,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Text(
                  translate == 'en' ? "Description" : "تفاصيل"
                  /*AppLocalizations.of(context).translate("Description")*/,
                  style: TextStyle(
                      //fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Center(
                  child: Html(
                    data: widget.description == null ? '' : widget.description,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Text(
                  translate == 'en' ? "Rating for service" : "تقييم الخدمة"
                  /*AppLocalizations.of(context).translate("Description")*/,
                  style: TextStyle(
                      //fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                widget.rating == null
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 30,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.76,
                            child: Text(
                              translate == 'en'
                                  ? "Wating for your rating"
                                  : "بانتظار تقيمك",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          )
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 35,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.76,
                            child: Text(
                              translate == 'en'
                                  ? "${widget.rating.toString()}"
                                  : "${widget.rating.toString()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                Container(
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Your description",
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
                (widget.fees==1)? Row(
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
                    SizedBox(width: MediaQuery.of(context).size.width / 30),
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
                ):Container(),
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                (widget.fees==1)?(isChecked
                    ? Center(
                        child: FlatButton(
                          onPressed: () {
                            // TODO: implement validate function
                            // validateForm();
                            //validateForm();
                            validateForm();
                          },
                          child: Text(
                            translate == 'en' ? "Make Order" : "اطلب الان",
                            style: TextStyle(color: Colors.black, fontSize: 20),
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
                            translate == 'en' ? "Make Order" : "اطلب الان",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      )):Center(
                  child: FlatButton(
                    onPressed: () {
                      // TODO: implement validate function
                      // validateForm();
                      //validateForm();
                      validateForm();
                    },
                    child: Text(
                      translate == 'en' ? "Make Order" : "اطلب الان",
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int id = prefs.get("idPref");
      String loct = prefs.get("locationPref");
      Map<String, dynamic> list = await pagesNetwork.certainService(
          'http://mr-fix.org/' +
              translate +
              '/api/services/' +
              '${widget.serviceId}' +
              '?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv');

      bool result = await pagesNetwork
          .makeOrder('http://mr-fix.org/en/api/makeorder', body: {
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
}
