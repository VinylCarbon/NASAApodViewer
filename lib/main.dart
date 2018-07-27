import 'package:flutter/material.dart';
import 'src/NASAApi.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:apod_viewer/src/apodpic.dart';
import 'dart:convert' as json;

void main() => runApp(new MyApp());

// final NASAApi nasaApi;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'APOD Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Column(children: <Widget>[
          Stack(children: <Widget>[
            Center(
                child: FutureBuilder<Apodpic>(
              future: getApodData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data.url,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )),
          ]),
        ]));
  }
}

Future<Apodpic> getApodData() async {
  final apiCall = NASAApi();
  final requestUrl = apiCall.getUrl();
  final res = await http.get(requestUrl);
  if (res.statusCode == 200) {
    final parsed = json.jsonDecode(res.body);
    return Apodpic.fromJson(parsed);
  } else{
    throw Exception('Fail to get pictures;');
  }
}
