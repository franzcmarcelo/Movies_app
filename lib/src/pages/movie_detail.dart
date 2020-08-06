import 'package:flutter/material.dart';

import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/models/cast_model.dart';

import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar( movie ),
          // Similar el ListView
          SliverList(
            delegate: new SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                _posterTitle(context, movie),
                _description(movie),
                _createCasting(movie),
              ]
            ),
          ),
        ],
      )
    );
  }

  Widget _createAppbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
              image: NetworkImage(movie.getPoster()),
              height: 150.0,
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: Theme.of(context).textTheme.button, overflow: TextOverflow.ellipsis,),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.caption)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvider = new MoviesProvider();
    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: ( context, AsyncSnapshot<List> snapshot) {
        if( snapshot.hasData ){
          return _createActorsPageView( snapshot.data );
        } else{
          return Center( child: CircularProgressIndicator() );
        }
      },
    );
  }

  Widget _createActorsPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemCount: actors.length,
        itemBuilder: (context, i){
          return _actorCard(actors[i]);
        }
      ),
    );
  }

  Widget _actorCard( Actor actor ){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhotoCast()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}