import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if(!snapshot.hasData) {
          return Container(
            child: CupertinoActivityIndicator(),
            height: 180,
          );
        }

        final List<Cast> cast = snapshot.data!;
        return Container(
          child: ListView.builder(
            itemBuilder: (_, int index) => _CastCard(actor: cast[index]),
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
          ),
          margin: EdgeInsets.only(bottom: 30),
          height: 180,
          width: double.infinity,
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;
  const _CastCard({Key? key, required this.actor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            child: FadeInImage(
              image: NetworkImage(actor.fullProfilePath),
              placeholder: AssetImage('assets/no-image.jpg'),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      width: 110,
    );
  }
}
