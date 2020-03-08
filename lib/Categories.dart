
import 'package:flutter/material.dart';
import 'package:mr_fix/UI/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network_utils/Pages_Network.dart';
import 'RegistrationForm/LoginPage.dart';
import 'ServicePage.dart';
import 'UI/SimilarWidgets.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PagesNetwork pagesNetwork = new PagesNetwork();
  SimilarWidgets similarWidgets = new SimilarWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate == 'en' ? "Categories" : 'الاقسام'),
          centerTitle: false,
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
                    child: Text(
                      translate == 'ar' ? 'EN' : 'AR',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                    ))),
            IconButton(
                icon: Icon(Icons.mode_edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/EditProfile');
                }),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      ModalRoute.withName('/MyHomePage'));
                })
          ],
        ),
        // drawer: buildDrawer(),
        body: FutureBuilder(
            future: pagesNetwork.serviceCategories('http://mr-fix.org/' +
                translate +
                '/api/servicescatogries?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv'),
            builder: (context, snapshots) {
              switch(snapshots.connectionState ){

                case ConnectionState.none:
                case ConnectionState.waiting:
                return LoadingScreen();
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                 if(snapshots.hasData){
                   return buildBody(snapshots.data);
                 }else
                   return similarWidgets.emptyPage(context);
                  break;
                default:
                  return similarWidgets.emptyPage(context);

              }
            }));
  }

  Widget buildBody(List<dynamic> snap) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: snap.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                      new ServicePage(snap[i]['id'], snap[i]['image'])));

              print(snap[i]['slug']);
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child:
                          snap[i]['image'] == null || snap[i]['image'] == ""
                              ? Image.asset(
                            'img/logo.png',
                          )
                              : Image.network(
                            "http://mr-fix.org" + snap[i]['image'],
                          ),
                        ),
                        Expanded(flex: 1, child: buildTitle(snap[i]['title']))
                      ],
                    ))),
          );
        });
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    );
  }


}