import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'imagePicker.dart';
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

List<String> selectableFruitPhotoAssets;
List<String> selectableFruitNames;

typedef void BannerPhotoCallback(String photoAsset);

class ItemsSelect extends StatefulWidget {
  ItemsSelect({
    Key key,
  })
      : super(key: key);

  ItemsSelectState createState() => new ItemsSelectState();
}

class ItemsSelectState extends State<ItemsSelect> with RouteAware {
  List<FruitList> fruitsList;
  List results;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    fruitsList = <FruitList>[
      new FruitList(
        fruitName: "{Empty}",
      ),
    ];
    fruitsList.clear();

    selectableFruitPhotoAssets = <String>[" "];
    selectableFruitNames = <String>[" "];

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

    selectableFruitPhotoAssets = <String>[" "];
    selectableFruitPhotoAssets.clear();

    selectableFruitPhotoAssets.add("assets/apple.png");
    selectableFruitPhotoAssets.add("assets/banana.png");
    selectableFruitPhotoAssets.add("assets/pear.png");
    selectableFruitPhotoAssets.add("assets/pineapple.png");
    selectableFruitPhotoAssets.add("assets/strawberry.png");

    selectableFruitNames = <String>[" "];
    selectableFruitNames.clear();

    selectableFruitNames.add("apple");
    selectableFruitNames.add("banana");
    selectableFruitNames.add("pear");
    selectableFruitNames.add("pineapple");
    selectableFruitNames.add("strawberry");

    return "Success!";
  }

  _updatePhotoAsset(int i, String asset) {
    setState(() {
      fruitsList[i].fruitPhotoAsset = asset;
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
                        child: new ListViewFruitItem.fruitListSelectItem(
                          formkey: _formKey,
                          fruitsList: fruitsList[index],
                          onPhotoChange: (String photoAsset) {
                            setState(() {
                              fruitsList[index].fruitName = fruitsList[index].fruitName;
                              fruitsList[index].fruitPhotoAsset = photoAsset;
                              _updatePhotoAsset(index, photoAsset);
                            });
                          },
                          contextPassed: context,
                        ),
                      ));
                    }))
          ])),
    );
  }
}

class ListViewFruitItem extends StatefulWidget {
  ListViewFruitItem.fruitListSelectItem(
      {Key key, @required this.formkey, @required this.fruitsList, @required this.onPhotoChange, this.contextPassed})
      : super(key: key);

  final GlobalKey<FormState> formkey;
  final FruitList fruitsList;
  final BannerPhotoCallback onPhotoChange;
  final BuildContext contextPassed;

  ListViewFruitItemState createState() => new ListViewFruitItemState();
}

class ListViewFruitItemState extends State<ListViewFruitItem> {
  _handleItemLocation() async {
    int _selectedValue = 1;
    var alert = new AlertDialog(
        title: new Text('Select a new image:'),
        content: new SingleChildScrollView(
          child: new ListBody(children: <Widget>[
            new Icon(
              Icons.arrow_drop_up,
              size: 68.0,
              color: Colors.grey.shade200,
            ),
            new Row(children: <Widget>[
              new Text("->"),
              new ImagePicker.integer(
                  initialValue: 1,
                  minValue: 0,
                  maxValue: 4,
                  selectablePhotoAssets: selectableFruitPhotoAssets,
                  selectableNames: selectableFruitNames,
                  listViewWidth: 150.0,
                  itemExtent: 50.0,
                  onChanged: (newValue) {
                    _selectedValue = newValue;
                  }),
              new Text("<-"),
            ]),
            new Icon(Icons.arrow_drop_down, size: 68.0, color: Colors.grey.shade200),
            new FlatButton(
                color: Theme.of(this.context).primaryColor,
                child: const Text('Set'),
                onPressed: () {
                  Navigator.of(this.context).pop();
                  widget.onPhotoChange(selectableFruitPhotoAssets[_selectedValue]);
                }),
          ]),
        ));
    showDialog(context: this.context, child: alert);
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      trailing: new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                setState(() {
                  _handleItemLocation();
                });
              },
              child: new Image.asset(
                widget.fruitsList.fruitPhotoAsset,
                width: 55.0,
                height: 55.0,
              ),
            ),
          ],
        ),
      ),
      title: new Text('${widget.fruitsList.fruitName}', style: new TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
