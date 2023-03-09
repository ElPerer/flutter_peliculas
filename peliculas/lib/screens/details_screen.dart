import 'package:flutter/material.dart';
import 'package:peliculas/widgets/widgets.dart';

import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Esta línea es para leer u obtener los argumentos que nos llegan desde otras clases .dart
    // final String movie = ModalRoute.of(context)?.settings.arguments.toString() ?? 'no-movie';
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    print(movie.title);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                _PosterAndTitle(movie: movie),
                _Overview(movie: movie),
                CastingCards(movieId: movie.id)
              ]
            )
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: EdgeInsets.only(bottom: 17, left: 10, right: 10),
          child: Text(movie.title, style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black26,
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        background: FadeInImage(
          image: NetworkImage(movie.fullBackdropPath),
          placeholder: const AssetImage('assets/no-image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget{
  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context){
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              child: FadeInImage(
                image: NetworkImage(movie.fullPosterImg),
                placeholder: AssetImage('assets/no-image.jpg'),
                height: 150,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(width: 20,),
          ConstrainedBox(
            constraints: BoxConstraints (maxWidth: size.width - 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),
                Text(movie.originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,),
          
                Row(
                  children: [
                    Icon(Icons.star_border_outlined, size: 15, color: Colors.grey,),
                    SizedBox(width: 5,),
                    
                    Text('${movie.voteAverage}', style: textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}


class _Overview extends StatelessWidget{
  const _Overview({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(movie.overview, 
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,),
    );
  }
}
