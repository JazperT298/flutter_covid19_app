import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttercovid19app/data_source.dart';
import 'package:fluttercovid19app/pages/country_page.dart';
import 'package:fluttercovid19app/panels/info_panel.dart';
import 'package:fluttercovid19app/panels/most_affected_countries.dart';
import 'package:fluttercovid19app/panels/world_wide_panel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async{
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetCountryData() async{
    http.Response response = await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWorldWideData();
    fetCountryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.lightbulb_outline
                      : Icons.highlight
              ),
              onPressed: (){
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light
              );
          }),
        ],
        centerTitle: false,
        title: Text(
          'COVID-19 Tracker'
        ),
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.yellow[300]
              ),
              height: 200,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.yellow[300],
                  child: Text(
                    DataSource.quote,
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'World statistics',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CountryPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryBlack,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Regional',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                worldData == null
                    ? CircularProgressIndicator()
                    : WorldwidePanel(
                    worldData:worldData
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Top 5 Affected Countries',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                countryData == null
                    ? Container()
                    : MostAffectedPanel(
                    countryData: countryData
                ),
                SizedBox(
                  height: 10.0,
                ),
                InfoPanel(),
                SizedBox(
                  height: 10.0,
                ),
//                Center(
//                  child: Text(
//                    'WE ARE TOGETHER IN THE FIGHT',
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 16.0
//                    ),
//                  ),
//                ),
                SizedBox(
                  height: 30.0,
                )
              ],
            ),
          )
        ],

      ),
    );
  }
}
