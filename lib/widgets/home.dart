import 'package:flutter/material.dart';
import 'dart:async';

MaterialColor color = Colors.pink;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String submitted;
  bool gender = false;
  double height = 100.0;
  List<String> activities = ["Faible", "Modere", "Forte"];
  int itemSelected;
  int age;
  DateTime date;

  List<Widget> radios() {
    List<Widget> l = [];
    for (int x = 0 ; x < activities.length ; x++) {
      Row row = Row(
        children: <Widget>[
          Text(activities[x]),
          Radio(value: x, groupValue: itemSelected, activeColor: color, onChanged: (int i) {
            setState(() {
              itemSelected = i;
            });
          }),
        ],
      );
      l.add(row);
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Remplisser tous les champs pour obtenir votre besoin journalier en calories',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Card(
              elevation: 15.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Homme'),
                        Switch(
                          value: gender,
                          activeColor: color,
                          inactiveThumbColor: color,
                          inactiveTrackColor: color,
                          onChanged: (bool b) {
                            setState(() {
                              gender = b;
                              gender ? color = Colors.pink : color = Colors.blue;
                            });
                          },
                        ),
                        Text('Femme'),
                      ],
                    ),
                    RaisedButton(
                      color: color,
                      child: Text((date == null) ? 'Choisir votre date de naissance': 'Votre âge est de : $age ans'),
                      onPressed: montrerDate,
                      textColor: Colors.white,
                    ),
                    Text('Votre taille est de ${height.floor()} cm'),
                    Slider(value: height,
                      activeColor: color,
                      min: 100.0,
                      max: 215.0,
                      onChanged: (double d) {
                        setState(() {
                          height = d;
                        });
                      },
                    ),
                    TextField(
                      onSubmitted: (String string) {
                        setState(() {
                          submitted = "Votre poids est de $string kg";
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Entre votre poids en kilos',
                      ),
                    ),
                    Text(submitted ?? ''),
                    Text("Quelle est votre fréquence d'activité?"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: radios(),
                    )
                  ],
                ),
              ),
            ),
            RaisedButton(
              color: color,
              onPressed: (() => print('coucou')),
              child: Text('Calculez votre besoin',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future montrerDate() async {
    DateTime choix = await showDatePicker(context: context, initialDatePickerMode: DatePickerMode.year, initialDate: DateTime.now(), firstDate: DateTime(1983), lastDate: DateTime.now());
    if (choix != null) {
      setState(() {
        date = choix;
        age = (DateTime.now().difference(date).inDays / 365.25).floor();
      });
    }
  }
}
