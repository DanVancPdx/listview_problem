import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

void main() => runApp(new MaterialApp(home: new ItemsSelect(), theme: new ThemeData(primarySwatch: Colors.green), routes: <String, WidgetBuilder>{}));

class FruitList {
  FruitList({
    this.fruitName,
    this.fruitPhotoAsset,
  });

  String fruitName;
  String fruitPhotoAsset;
}

class ItemsSelect extends StatefulWidget {
  ItemsSelect({
    Key key,
  })
      : super(key: key);

  ItemsSelectState createState() => new ItemsSelectState();
}

class ItemsSelectState extends State<ItemsSelect> with RouteAware {
  List<FruitList> fruitsList;

  @override
  initState() {
    super.initState();
    fruitsList = <FruitList>[
      new FruitList(
        fruitName: "{Empty}",
      ),
    ];
    fruitsList.clear();
    this.getData();
  }

  Future<String> getData() async {
    this.setState(() {
      fruitsList.add(new FruitList(
        fruitName: "apple",
        fruitPhotoAsset: "assets/apple.png",
      ));
      fruitsList.add(new FruitList(
        fruitName: "banana",
        fruitPhotoAsset: "assets/banana.png",
      ));
      fruitsList.add(new FruitList(
        fruitName: "pear",
        fruitPhotoAsset: "assets/pear.png",
      ));
      fruitsList.add(new FruitList(
        fruitName: "pineapple",
        fruitPhotoAsset: "assets/pineapple.png",
      ));
      fruitsList.add(new FruitList(
        fruitName: "strawberry",
        fruitPhotoAsset: "assets/strawberry.png",
      ));
    });
    return "Success!";
  }

  _changePhoto(int index) async {
    int _selectedValue = 1;
    var alert = new AlertDialog(
        title: new Text('Set selected image:'),
        content: new SingleChildScrollView(
          child: new ListBody(children: <Widget>[
            new FlatButton(
                color: Theme.of(this.context).primaryColor,
                child: const Text('Set image to watermellon.'),
                onPressed: () {
                  Navigator.of(this.context).pop();
                  _updatePhotoAsset(index, "assets/watermellon.png");
                }),
          ]),
        ));
    showDialog(context: this.context, child: alert);
  }

  _updatePhotoAsset(int i, String asset) {
    setState(() {
      //*** This is the problem area.  The photoAsset is changed, but it usually
      //*** now goes blank on the device.
      //***
      //*** However, the text field does get updated with the appended x.
      fruitsList[i].fruitPhotoAsset = asset;
      fruitsList[i].fruitName += 'x';
      print("photo asset $i updated to: $asset");
    });
  }

  _sortAscending() {
    setState(() {
      fruitsList.sort((x, y) => x.fruitName.compareTo(y.fruitName));
    });
  }

  _sortDescending() {
    setState(() {
      fruitsList.sort((y, x) => x.fruitName.compareTo(y.fruitName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          color: Colors.blue.shade100,
          child: new Column(children: <Widget>[
            new Text("\n\n\n"),
            new Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue.shade100,
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: new Text(" ")),
                    new RaisedButton(
                      child: new Text("Sort Asc"),
                      onPressed: () {
                        setState(() {
                          _sortAscending();
                        });
                      },
                    ),
                    new RaisedButton(
                      child: new Text("Sort Desc"),
                      onPressed: () {
                        setState(() {
                          _sortDescending();
                        });
                      },
                    ),
                    new Text("       Tap image to change"),
                  ],
                )),
            new Expanded(
                child: new ListView.builder(
                    itemCount: fruitsList == null ? 0 : fruitsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: new Container(
                              color: Colors.red.shade100,
                              height: 60.0,
                              child: new ListTile(
                                trailing: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _changePhoto(index);
                                          });
                                        },
                                        child: new Image.asset(
                                          fruitsList[index].fruitPhotoAsset,
                                          //*** this photo should get changed by onTap, but doesn't
                                          width: 55.0,
                                          height: 55.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: new Text('${fruitsList[index].fruitName}', style: new TextStyle(fontWeight: FontWeight.bold)),
                                //*** while this text does get updated by the above onTap
                              )));
                    })),
          ])),
    );
  }
}
