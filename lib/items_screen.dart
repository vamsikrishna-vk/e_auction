import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class item extends StatelessWidget {
  var data;
  var docid;
  item(this.data, this.docid);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ContractLinking>(
        create: (_) => ContractLinking(
            "bf6e553fccf796895a950dba694ba896643198b4c34cd7822509b456ef9136fd"),
        child: item1(data, docid));
  }
}

class item1 extends StatefulWidget {
  var data;
  var docid;
  item1(this.data, this.docid);
  @override
  State<item1> createState() => _itemState(data, docid);
}

class _itemState extends State<item1> {
  var data;
  var docid;
  bool? admin;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final TextEditingController itemprice = TextEditingController();
  _itemState(this.data, this.docid);
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(data["productname"].toString().toUpperCase()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(data["productimage"].toString()),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Text("Product Name ",
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(":  " + data["productname"],
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ]),
                  TableRow(children: [
                    Text("Product Description ",
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(":  " + data["productdescription"],
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ]),
                  TableRow(children: [
                    Text("Price",
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(":  \₹" + data["productprice"],
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ]),
                ],
              ),
            ),
            firebaseUser.uid == data["admin"]
                ? Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Highest Bidder " +
                              contractLink.deployedName.toString(),
                        ),
                        Text("Bid Price \₹" +
                            contractLink.deployedprice.toString()),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          onPressed: () => {close()},
                          color: Colors.red,
                          child: Text("close bid"),
                        )
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("Current Higest Bid : " +
                            "\₹" +
                            contractLink.deployedprice.toString()),
                        SizedBox(
                          height: 20,
                        ),
                        text(itemprice, "bid price"),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () => {
                            if (BigInt.from(int.parse(itemprice.text.trim())) >
                                contractLink.deployedprice)
                              {
                                contractLink.setName(
                                    firebaseUser.email.toString(),
                                    BigInt.from(
                                        int.parse(itemprice.text.trim())))
                              }
                            else
                              {
                                Fluttertoast.showToast(
                                  msg:
                                      "Bid price sould be greater than currrent highest bid",
                                )
                              }
                          },
                          child: Text("place bid"),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget text(controller, name) {
    return SizedBox(
        height: 50.0,
        child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: name,
              filled: true,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            )));
  }

  close() async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection("products")
        .doc(docid)
        .set({"active": false}, SetOptions(merge: true))
        .then((_) {})
        .whenComplete(() => {Navigator.pop(context)});
  }
}
