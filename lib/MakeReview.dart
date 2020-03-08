import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'Network_utils/Pages_Network.dart';
import 'UI/SimilarWidgets.dart';
import 'main.dart';

class MakeReview extends StatefulWidget {
  String title, description, image;
  int serviceId;

  MakeReview({
    this.serviceId,
    this.title,
    this.description,
    this.image,
  });

  @override
  _MakeReviewState createState() => _MakeReviewState();
}

class _MakeReviewState extends State<MakeReview> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = new TextEditingController();
  PagesNetwork pagesNetwork = new PagesNetwork();
  SimilarWidgets similarWidgets = new SimilarWidgets();
  bool isChecked;
  double rating;

  @override
  void initState() {
    isChecked = false;
    // TODO: implement initState
    rating = 0;
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
        padding: const EdgeInsets.all(8.0),
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
                          : Image.network("http://mr-fix.org" + widget.image),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Text(
                  translate == 'en' ? "Your Review" : "تقييمك"
                  /*AppLocalizations.of(context).translate("Description")*/,
                  style: TextStyle(
                      //fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SmoothStarRating(
                        allowHalfRating: true,
                        onRatingChanged: (v) {
                          setState(() {
                            rating = v;
                          });
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        color: Colors.yellow,
                        borderColor: Colors.yellow,
                        spacing: 0.0)
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                rating > 0
                    ? Center(
                        child: FlatButton(
                          onPressed: () {
                            validateForm();
                          },
                          child: Text(
                            translate == 'en'
                                ? "Make your review"
                                : "ضع تقيمك الان",
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
                            translate == 'en'
                                ? "Make your review"
                                : "ضع تقيمك الان",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.get("idPref");
    String result = await pagesNetwork.MakeReview(
        'http://mr-fix.org/ar/api/postreview', id, widget.serviceId, rating);
    if (result == 'true') {
      Navigator.pop(context);
      similarWidgets.showDialogWidget(
          translate == 'en'
              ? "Your review is placed successfully, thank you for rating"
              : "تم ارسال التقييم بنجاح, شكرا لك للتقييم",
          context);
    } else {
      similarWidgets.showDialogWidget(
          translate == 'en'
              ? "Your review is failed please try again"
              : "لم ارسال التقييم بنجاح, برجاء حاول مرة اخري",
          context);
    }
  }
}
