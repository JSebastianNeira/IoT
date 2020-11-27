import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp>{
  String tempString;
  String humString;
  String acString;
  String doorString;
  static const IconData DeviceThermostat = IconData(50591, fontFamily: 'MaterialIcons');
  Color changeColor;

  @override
  Widget build(BuildContext context){
        String usuario = 'Joel';

    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child(usuario).onValue.listen((event){
      var snapshot = event.snapshot;
      double temp = snapshot.value['HeatIndex'];
      int hum = snapshot.value['Humidity']; //deberia ser double
      bool acStatus = snapshot.value['ACStatus'];
      bool door = snapshot.value['Door'];
      tempString = temp.toString();
      humString = hum.toString();

      if (acStatus == true){
        acString = "ON";
        changeColor = Colors.green;
      }
      else {
        acString ="OFF";
        changeColor = Colors.red;
      }

      if (door == true){
        doorString = "The door is open";
      }
      else {
        doorString ="The door is close";
      }
    });

    return MaterialApp(
    home: Botones(tempString: tempString, humString: humString, acString: acString, doorString: doorString, DeviceThermostat: DeviceThermostat, changeColor: changeColor,),
    );

  }
}

class Botones extends StatefulWidget {
  final String tempString;
  final String humString;
  final String acString;
  final String doorString;
  final IconData DeviceThermostat;
  final Color changeColor;
  Botones({Key key, this.tempString, this.humString, this.acString, this.doorString, this.DeviceThermostat, this.changeColor}) : super(key: key);

  @override
  _Botones createState() =>
      _Botones();
}

class _Botones extends
  State<Botones>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  static List<Widget> _widgetOptions;



   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context){
  _widgetOptions = <Widget>[

  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            color: Colors.blue,
            height: 200.0,
            width: 300.0,
          child: Row(
            children: <Widget>[
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "   TEMPERATURE", style: TextStyle(fontSize: 28.0, color: Colors.white)),
                        TextSpan(text: '\n' + '  ' + widget.tempString + 'º',  style: TextStyle(fontSize: 58.0, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: Icon(MdiIcons.thermometer,
                color: Colors.white,
                size: 100.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.blue,
          height: 200.0,
          width: 300.0,
          child: Row(
            children: <Widget>[
              Center(
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "    HUMIDITY", style: TextStyle(fontSize: 28.0, color: Colors.white)),
                      TextSpan(text: '\n' + '   ' + widget.humString + '%',  style: TextStyle(fontSize: 58.0, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Icon(MdiIcons.water,
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
            ],
          ),
        ),
          FlatButton(
            color: Colors.blueGrey,
            textColor: Colors.white,
            disabledTextColor: Colors.white12,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              runApp(MyApp());
              },
            child: Text(
            "Refresh",
            style: TextStyle(fontSize:20.0),
          )
          )
      ],
    )
  ),

    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: widget.changeColor,
              height: 200.0,
              width: 300.0,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "AC STATUS", style: TextStyle(fontSize: 30.0, color: Colors.white)),
                      TextSpan(text: '\n' + widget.acString,  style: TextStyle(fontSize: 80.0, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              color: Colors.amber,
              height: 150.0,
              width: 300.0,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "AVERAGE USE OF ENERGY", style: TextStyle(fontSize: 23.0, color: Colors.white)),
                      TextSpan(text: '\n' + "5.3 KW/H",  style: TextStyle(fontSize: 65.0, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            FlatButton(
                color: Colors.blueGrey,
                textColor: Colors.white,
                disabledTextColor: Colors.white12,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  runApp(MyApp());
                },
                child: Text(
                  "Refresh",
                  style: TextStyle(fontSize:20.0),
                )
            )
          ],
        )
    ),

    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              Container(
                color: Colors.black,
                height: 300.0,
                width: 300.0,
                child: Center(
                  child: Image(image:
                  AssetImage('assets/Graph.png'),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your AC Kw/h',
                      hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                  ),
                  FlatButton(
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      disabledTextColor: Colors.white12,
                      padding: EdgeInsets.all(7.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        runApp(MyApp());
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize:15.0),
                      )
                  )
                ],
              ),
              FlatButton(
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                  disabledTextColor: Colors.white12,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    runApp(MyApp());
                  },
                  child: Text(
                    "Refresh",
                    style: TextStyle(fontSize:20.0),
                  )
              )
            ],
          )
      ),

  ];

  return Scaffold(
    backgroundColor: Colors.black,
  appBar: AppBar(
  backgroundColor : Colors.blue,
  title: const Text("DROSER",
    textAlign: TextAlign.center,
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
    )
  ),
  body: Center(
  //
  child: _widgetOptions.elementAt(_selectedIndex),
  ),
  bottomNavigationBar:
  BottomNavigationBar(
  items: const <BottomNavigationBarItem>
  [
  BottomNavigationBarItem(
  backgroundColor: Colors.grey,
  icon: Icon(Icons.home),
  title: Text('Home'), //Temperatura, humedad, hora
  ),
  BottomNavigationBarItem(
  icon: Icon(Icons.ac_unit),
  title: Text('AC status') //AC off on, barrita de temperatura
  ),
  BottomNavigationBarItem(
  icon: Icon(Icons.insert_chart),
  title: Text('Consumption') //Grafica de consumo de energia (KW/Hora)
  )
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.amber,
  onTap: _onItemTapped,
  ),
  );
  }
}