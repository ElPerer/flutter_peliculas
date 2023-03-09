import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget{
  const MovieSlider({Key? key, required this.movies, this.title, required this.onNextPage }) : super(key: key);

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  //EL ScrollController nos permite en el initState crear un listener
  final ScrollController scrollController = new ScrollController();

  //En el initState se ejecuta el código la primera vez que este  WIDGET es construido
  @override
  void initState(){
    super.initState();
    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        //El objeto WIDGET es un objeto que hace referencia al mismo WIDGET donde estamos ubicados
        widget.onNextPage();
      }
    });
  }

  //En el dispose es cuando el WIDGET va a ser destruido
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(this.widget.title != null)
            Padding(
              child: Text(this.widget.title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(horizontal: 20)
            ),
          SizedBox(height: 5,),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) => _MoviePoster( widget.movies[index], '${widget.title}-$index-${widget.movies[index].id}' ),
              itemCount: widget.movies.length,
            ),
          )
        ],
      ),
      height: 260,
      width: double.infinity,
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster( this.movie, this.heroId);

  final Movie movie;
  final String heroId;

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(movie.fullPosterImg),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  height: 190,
                  width: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Text(movie.title, overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center,)
        ],
      ),
      height: 190,
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 10,),
    );
  }
}