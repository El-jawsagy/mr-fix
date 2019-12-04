import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network_utils/Pages_Network.dart';
import 'UI/SimilarWidgets.dart';

class MakeOrder extends StatefulWidget {
  String title, description, image;
  int serviceId;
  MakeOrder(this.serviceId, this.title, this.description, this.image);
  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = new TextEditingController();
  PagesNetwork pagesNetwork = new PagesNetwork();
  SimilarWidgets similarWidgets = new SimilarWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: widget.image == "" || widget.image == null
                      ? Icon(
                          Icons.build,
                          size: 37,
                        )
                      : Image.network("http://mr-fix.org" + widget.image),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Text(
                  'Description : ',
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
                Center(
                  child: FlatButton(
                    onPressed: () {
                      // TODO: implement validate function
                      // validateForm();
                      //validateForm();
                      validateForm();
                    },
                    child: Text(
                      "Make Order",
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
          'http://mr-fix.org/en/api/services/' +
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
        similarWidgets.showDialogWidget(
            "Your Order is placed successfully, We will contact with you as soon as possible",
            context);
      } else {
        similarWidgets.showDialogWidget(
            "Your Order is failed please try again", context);
      }

      formState.reset();
    }
  }
}
