import 'package:flutter/material.dart';
import 'package:mr_fix/UI/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network_utils/Pages_Network.dart';
import 'RegistrationForm/LoginPage.dart';
import 'ServicePage.dart';
import 'UI/SimilarWidgets.dart';

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
          title: Text("Categories"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.update),
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
            future: pagesNetwork.serviceCategories(),
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
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7),
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
                elevation: 2,
                child: Container(
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    child: buildTitle(snap[i]['title']),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('img/logo.png'), fit: BoxFit.contain),
                  ),
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
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      //margin: EdgeInsets.only(left: 10, right: 10),
    );
  }

  /* Widget buildDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Mark"),
            accountEmail: Text("mark.george960@yahoo.com"),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: new BoxDecoration(color: Colors.green),
          ),

          //body of the drawer
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/Categories');
            },
            child: ListTile(
              title: Text("Home Page"),
              leading: Icon(Icons.home, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/MyAccount');
            },
            child: ListTile(
              title: Text("My Account"),
              leading: Icon(
                Icons.person,
                color: Colors.green,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text("My orders"),
              leading: Icon(Icons.shopping_basket, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/ShoppingPage');
            },
            child: ListTile(
              title: Text("Shopping Cart"),
              leading: Icon(Icons.shopping_cart, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/FavouritePage');
            },
            child: ListTile(
              title: Text("Favourite"),
              leading: Icon(Icons.favorite, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }*/
}