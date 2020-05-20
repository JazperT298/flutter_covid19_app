import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttercovid19app/pages/search.dart';
import 'package:http/http.dart' as http;

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {

  List countryData;

  fetchCountryData() async{
    http.Response response = await http.get('https://corona.lmao.ninja/v2/countries');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Country Stats'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search
            ),
            onPressed: () {
              showSearch(context: context, delegate: Search(countryData));
            },
          ),
        ],
      ),
      body: countryData == null
        ? Center(child: CircularProgressIndicator(),)
        : ListView.builder(
           itemCount: countryData == null ? 0 : countryData.length,
           itemBuilder: (context, index){
             return Card(
                child: GestureDetector(
                  onTap: () {
                    print(countryData[index]);
                  },
                  child: Container(
                    height: 90.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 200.0,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                countryData[index]['country'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
                                height: 50.0,
                                width: 60.0,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'CONFIRMED : ' + countryData[index]['cases'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                  ),
                                ),
                                Text(
                                  'ACTIVE : ' + countryData[index]['active'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                  ),
                                ),
                                Text(
                                  'RECOVERED : ' + countryData[index]['recovered'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green
                                  ),
                                ),
                                Text(
                                  'DEATHS : ' + countryData[index]['deaths'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[100]
                                      : Colors.grey[900]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
             );
           },
      ),
    );
  }
}
