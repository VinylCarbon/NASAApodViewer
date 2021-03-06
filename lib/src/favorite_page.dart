import 'dart:async';

import 'package:club.swimmingbeaver.apodviewerflutter/database/database.dart';
import 'package:club.swimmingbeaver.apodviewerflutter/model/apod_model.dart';
import 'package:club.swimmingbeaver.apodviewerflutter/src/data_util.dart';
import 'package:flutter/material.dart';
import 'package:simple_coverflow/simple_coverflow.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Apod> favoriteList = List();
  Apod apod;
  ApodDatabase db = ApodDatabase();

  @override
  void initState() {
    super.initState();
    favoriteList = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFavorite();
  }

  Future setupList() async {
    favoriteList = await db.getFavoriteApodList();
  }

  void _removeFavorite(int index) async {
    var unfavoriteApod = favoriteList[index % favoriteList.length];
    unfavoriteApod.isFavorite = false;
    favoriteList.removeAt(index % favoriteList.length);
    await db.updateApod(unfavoriteApod);
    _buildFavorite();
  }

  Widget _buildCoverFlow() {
    return CoverFlow(
      itemBuilder: favoriteBuilder,
      dismissibleItems: true,
      dismissedCallback: (int index, _) => _removeFavorite(index),
    );
  }

  Widget _buildFavorite() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: FutureBuilder(
        future: setupList(),
        builder: (_, snapshot) => _buildCoverFlow(),
      ),
    );
  }

  Widget favoriteBuilder(BuildContext context, int index) {
    final cards = favoriteList.map(
      (apod) {
        var titleWidget = Text(apod.title);
        var dateWidget = Text(apod.date);
        var explanationWidget = Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                apod.explanation,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        );
        var mediaWidget = getMediaWdiget(apod);

        return Container(
          child: Card(
              margin: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
              child: Column(
                children: <Widget>[
                  dateWidget,
                  titleWidget,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: mediaWidget,
                  ),
                  explanationWidget,
                ],
              )),
        );
      },
    ).toList();

    if (cards.length == 0) {
      return new Container();
    } else {
      return cards[index % cards.length];
    }
  }
}
