import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  CardSwiper({ @required this.movies });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width*0.7,
        itemHeight: _screenSize.height*0.5,
        itemBuilder: (BuildContext context,int index){
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( movies[index].getPoster() ),
              placeholder: AssetImage('assets/img/loading.gif'),
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: movies.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl(),
      ),
    );
  }
}

// bbfb7914ea065584601635ffee2cccb3
// https://image.tmdb.org/t/p/w500{{/kjMbDciooTbJPofVXgAoFjfX8Of.jpg}}