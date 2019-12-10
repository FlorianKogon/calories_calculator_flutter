import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

MaterialColor color = Colors.blue;

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
  Map activities = {
    0: "Faible",
    1: "Modere",
    2: "Forte"
  };
  int itemSelected;
  int caloriesBase;
  int caloriesTotal;
  int age;
  int weight;
  DateTime date;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
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
                          weight = int.parse(string);
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
                    rowRadio(),
                  ],
                ),
              ),
            ),
            RaisedButton(
              color: color,
              onPressed: calculCalories,
              child: Text('Calculez',
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

  Row rowRadio() {
    List<Widget> l = [];
    activities.forEach((key, value) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: key,
            activeColor: color,
            groupValue: itemSelected,
            onChanged: (Object i) {
              setState(() {
                itemSelected = i;
              });
            }),
          Text(value, style: TextStyle(
            color: color,
            ),
          ),
        ],
      );
      l.add(column);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  void calculCalories() {
    if (age != null && weight != null && itemSelected != null) {
      if (!gender) {
        caloriesBase = (66.4730 + (weight * 13.7516) + (height * 5.0033) - (age * 6.7550)).floor();
      } else {
        caloriesBase = (65.0955 + (weight * 9.5634) + (height * 1.8496) - (age * 4.6756)).floor();
      }
      switch(itemSelected) {
        case 0:
          caloriesTotal = (caloriesBase * 1.2).toInt();
          break;
        case 1:
          caloriesTotal = (caloriesBase * 1.5).toInt();
          break;
        case 2:
          caloriesTotal = (caloriesBase * 1.8).toInt();
          break;
        default:
          caloriesTotal = caloriesBase;
          break;
      }
      setState(() {
          result();
      });
    } else {
      alert();
    }
  }

  Future result() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
       return AlertDialog(
         title: Text("Résultat :"),
         content: Text("Votre montant de calories journalier est de : $caloriesTotal"),
         actions: <Widget>[
           FlatButton(
             onPressed: () {
               Navigator.pop(buildContext);
             },
             child: Text('Retour',
               style: TextStyle(
                 color: Colors.green,
               ),
             ),
           ),
         ],
       );
      }
    );
  }

  Future alert() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text('Tous les champs ne sont pas remplis'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(buildContext);
              },
              child: Text('OK', style: TextStyle(
                color: Colors.red,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
