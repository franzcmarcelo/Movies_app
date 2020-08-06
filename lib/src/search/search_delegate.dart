import 'package:flutter/material.dart';

import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/models/movie_model.dart';

class DataSearch extends SearchDelegate {

  final moviesProvider = new MoviesProvider();

  // final movies = [
  //   'SpiderMan 1',
  //   'SpiderMan 2',
  //   'Capitan America',
  //   'Aquaman',
  //   'Shazam',
  //   'Scooby',
  //   'Harry Potter'
  // ];

  // final recentMovies = [
  //   'SpiderMan',
  //   'Capitan America'
  // ];

  String movieSelected;

  @override
  List<Widget> buildActions(BuildContext context) {
      // Acciones de nuestro Appbar, ej: icono para limpiar el input
      return [
        IconButton(
          icon: Icon( Icons.clear ),
          onPressed: (){
            query = '';
          }
        ),
      ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izq del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(movieSelected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen al escribir

    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map((movie){
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(movie.getPoster()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: (){
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(
                    context,
                    'detail',
                    arguments: movie
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }




  // ---------------------------------------------------------------------------
  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que aparecen al escribir

  //   // FIXME:
  //   // query ~ value de un input
  //   // Si esta vacio (el input), se muestran se muestran las rencenMovies
  //   // Sino, las que coincidan con el inicio del texto ingresado
  //   final suggestionList = (query.isEmpty)
  //                             ? recentMovies
  //                             : movies.where(
  //                                 (movie) => movie.toLowerCase().startsWith(query.toLowerCase())
  //                               ).toList();

  //   return ListView.builder(
  //     itemCount: suggestionList.length,
  //     itemBuilder: (context, i){
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(suggestionList[i]),
  //         onTap: (){
  //           movieSelected = suggestionList[i];
  //           showResults(context);
  //         },
  //       );
  //     }
  //   );
  // }

}