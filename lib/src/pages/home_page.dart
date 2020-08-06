import 'package:flutter/material.dart';

import 'package:movies/src/providers/movies_provider.dart';

import 'package:movies/src/models/movie_model.dart';

import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

import 'package:movies/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    // Llamando la data inicial, donde tmb se ejecuta el Sink
    moviesProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cartelera'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch(),
                // query: 'Texto precargado en el input'
              );
            },
          )
        ],
      ),
      // FIXME: Solucion para el rendering al momento de regresar del Search
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        )
      )
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      // La data q regresa el future, lo tiene el snapshot
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot){
        if ( snapshot.hasData ) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          // Cuendo no se tiene data o se esta resolviendo
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
              )
            );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 23.0),
            child: Text('Populares', style: Theme.of(context).textTheme.headline6)
          ),
          SizedBox(height: 10.0,),
          StreamBuilder(
            stream: moviesProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot){
              // Se hace el forEach, si es que existe data
              // snapshot.data?.forEach((element) {print(element.title);});
              if ( snapshot.hasData ) {
                return MovieHorizonral(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPopular,
                );
              } else {
                return  Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

}