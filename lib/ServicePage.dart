import 'package:flutter/material.dart';
import 'package:mr_fix/MakeReview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MakeOrder.dart';
import 'Network_utils/Pages_Network.dart';
import 'UI/SimilarWidgets.dart';
import 'UI/loading_screen.dart';
import 'main.dart';

class ServicePage extends StatefulWidget {
  int slug;
  String img;

  ServicePage(this.slug, this.img);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  PagesNetwork pagesNetwork = new PagesNetwork();
  SimilarWidgets similarWidgets = new SimilarWidgets();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate == 'en' ? "Services" : 'الخدمات'),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    if (translate == 'en') {
                      translate = 'ar';
                    } else if (translate == 'ar') {
                      translate = 'en';
                    }
                  });
                },
                child: Center(
                    child: Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 50),
                  child: Text(
                    translate == 'ar' ? 'EN' : 'AR',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                  ),
                ))),
          ],
        ),
        body: FutureBuilder(
            future: pagesNetwork.service('http://mr-fix.org/' +
                translate +
                '/api/servicescatogries/' +
                '${widget.slug}' +
                '?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv'),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting)
                return LoadingScreen();
              if (snapshots.hasData && snapshots.data.length > 0) {
                return buildBody(snapshots.data);
              } else {
                return similarWidgets.emptyPage(context);
              }
            }));
  }

  Widget buildBody(List<dynamic> snap) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, right: 10, left: 10, bottom: 16),
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.yellow[700],
              ),
          itemCount: snap.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                int id = prefs.get("idPref");
                await pagesNetwork.IsOrdered('http://mr-fix.org/' +
                        translate +
                        '/api/servicestatus?service_id=' +
                        '${snap[i]['id']}' +
                        '&user_id=$id')
                    .then((val) {
                  print(val);
                  if (val == "false") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MakeOrder(
                        serviceId: snap[i]['product_id'],
                        title: snap[i]['title'],
                        description: snap[i]['content'],
                        image: snap[i]['image'],
                        fees: snap[i]['fees'],
                      );
                    }));
                  } else if (val == "true") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MakeReview(
                          serviceId: snap[i]['product_id'],
                          title: snap[i]['title'],
                          description: snap[i]['content'],
                          image: snap[i]['image']);
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MakeOrder(
                        serviceId: snap[i]['product_id'],
                        title: snap[i]['title'],
                        description: snap[i]['content'],
                        image: snap[i]['image'],
                        rating: double.parse(val),
                        fees: snap[i]['fees'],
                      );
                    }));
                  }
                });
              },
              child: ListTile(
                leading: snap[i]['image'] == "" || snap[i]['image'] == null
                    ? Icon(
                        Icons.build,
                        size: 37,
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Image.network(
                            "http://mr-fix.org" + snap[i]['image']),
                      ),
                title: Container(
                  child: Container(
                    //color: Color.fromRGBO(0, 0, 0, 0.4),
                    child: buildTitle(snap[i]['title']),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildTitle(String title) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.only(right: 10),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
