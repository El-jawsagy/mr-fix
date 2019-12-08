import 'package:flutter/material.dart';

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
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.yellow[700],
            ),
        itemCount: snap.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MakeOrder(
                    serviceId: snap[i]['product_id'],
                    title: snap[i]['title'],
                    description: snap[i]['content'],
                    image: snap[i]['image']);
              }));
            },
            child: ListTile(
              leading: snap[i]['image'] == "" || snap[i]['image'] == null
                  ? Icon(
                      Icons.build,
                      size: 37,
                    )
                  : Image.network("http://mr-fix.org" + snap[i]['image']),
              title: Container(
                child: Container(
                  //color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: buildTitle(snap[i]['title']),
                ),
              ),
            ),
          );
        });
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
}
