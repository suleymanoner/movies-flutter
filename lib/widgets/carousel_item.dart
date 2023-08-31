import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movies/constants.dart';
import 'package:movies/models/movie.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.movies,
    required this.onTapMovie,
  });

  final List<Movie> movies;
  final void Function(int id) onTapMovie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        items: movies
            .map(
              (e) => GestureDetector(
                onTap: () {
                  onTapMovie(e.id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Image.network(
                        Constants.BASE_IMG_URL + e.posterPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
