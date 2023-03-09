import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Busca en todo el arbol de WIDGETS los provider y los instancia a una variable deseada
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final popularProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon:  const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            MovieSlider( movies: popularProvider.popularMovies, title: 'Populares', onNextPage: () => {moviesProvider.getPopularMovies()},),
          ],
        ),
      )
    );
  }
}