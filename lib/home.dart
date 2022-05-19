import 'package:e_auction/new_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'helloUI.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'items_screen.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return homepage();
  }
}

class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("E- Auction App"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () =>
                    {context.read<AuthenticationService>().signOut()},
                icon: Icon(Icons.logout))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: IconButton(
          color: Colors.deepOrange[200],
          onPressed: () => {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => newItem()))
          },
          icon: Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where("active", isEqualTo: true)
                .snapshots(), // async work
            builder: (BuildContext context, AsyncSnapshot snapshot1) {
              switch (snapshot1.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                default:
                  if (snapshot1.hasData) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: listview(context, snapshot1));
                  }
                  return Container();
              }
            }));
  }

  Widget listview(BuildContext context, snapshot) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (Widget) => item(snapshot.data.docs[index],
                              snapshot.data.docs[index].documentID)))
                },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(snapshot
                                .data.docs[index]["productimage"]
                                .toString()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data.docs[index]["productname"]
                                    .toString()
                                    .toUpperCase()),
                                Text(snapshot.data.docs[index]
                                    ["productdescription"])
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Price"),
                                Text("\₹" +
                                    snapshot.data.docs[index]["productprice"])
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
      },
      itemCount: snapshot.data.docs.length,
    );
  }
}
