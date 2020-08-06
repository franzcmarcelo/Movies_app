import 'package:flutter/material.dart';

import 'package:movies/src/models/movie_model.dart';

class MovieHorizonral extends StatelessWidget {

  final List<Movie> movies;
  final Function nextPage;

  MovieHorizonral({ @required this.movies, @required this.nextPage });

  final _pageController = new PageController(
    initialPage: 1,
    // Para que se muestren 3 a la vez
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    // Se va a disparar cada que se mueve el scroll horizontal
    _pageController.addListener(() {
      // Cuando se este acercando a casi el final del scroll horizontal maximo
      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent-200 ) {
        // print('Cargar siguientes peliculas');
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height*0.25,
      // FIXME: El PageView.builder renderiza sus elementos bajo demanda
      child: PageView.builder(
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int i) => _createCard(context, movies[i]),
        // Para que las cards mantenga el momentum
        pageSnapping: false,
      ),
    );
  }

  Widget _createCard( BuildContext context, Movie movie ){

    movie.uniqueId = '${movie.id}-carHorizontal';

    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          // FIXME: Hero Animation
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPoster()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 153.0,
              ),
            ),
          ),
          SizedBox(height: 3.0,),
          Center(
            child: Text(
              movie.title,
              // para los ... cuando no cabe el title
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );

    // FIXME: Para detectar acciones sobre el card
    return GestureDetector(
      child: card,
      onTap: (){
        // print('Titulo: ${movie.title}');
        Navigator.pushNamed(
          context,
          'detail',
          arguments: movie,
        );
      },
    );
  }
}