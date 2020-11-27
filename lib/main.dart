import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
    home: botones(),
    );
  }
}

class botones extends StatefulWidget {
  botones({Key key}) : super(key: key);

  @override
  _botones createState() =>
      _botones();
}


class _botones extends
    State<botones>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  static const List<Widget> _widgetOptions =
      <Widget>[

        Image(image:
        AssetImage(
        'assets/covidStatus.png'
        ),
       ),

        Image(image:
        AssetImage(
            'assets/covidMap.png'
        ),
        ),

        Image(image:
        AssetImage(
            'assets/covidStatus.png'
        ),
        ),

        Image(image:
        AssetImage(
            'assets/covidStatus.png'
        ),
        ),
  ];


   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor : Colors.green,
        title: const Text("PrevenTech"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>
          [
            BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(Icons.location_on),
              title: Text('MyTrack'),
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('MyStatus')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings')
          ),
        ],
    currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}

