import 'package:day10/model/tvshow.dart';
import 'package:day10/web_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TvShowDetailsScreen extends StatelessWidget {
  TvShowDetailsScreen({super.key, required this.tvShowId});
  final int tvShowId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('TV Show Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<TvShow>(
        future: ApiService().getTvShowById(tvShowId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingUI();
          } else if (snapshot.hasError) {
            return _buildErrorUI(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return _buildErrorUI("No Data Available");
          }

          final tvShow = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(tvShow.posterPath),
                SizedBox(height: 10),
                Text(
                  tvShow.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Release Date: ${tvShow.firstAirDate}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  tvShow.overview.isNotEmpty
                      ? tvShow.overview
                      : 'No description available',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 10),
                _buildRating(tvShow.voteAverage, tvShow.voteCount),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔵 **Loading Shimmer UI**
  Widget _buildLoadingUI() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 15,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  /// ❌ **Error UI**
  Widget _buildErrorUI(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  /// 🖼️ **TV Show Image with Placeholder**
  Widget _buildImage(String imagePath) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            )
          ],
          image: imagePath.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w500$imagePath'),
                  fit: BoxFit.cover,
                )
              : null,
          color: imagePath.isEmpty ? const Color.fromARGB(255, 255, 255, 255) : null,
        ),
        child: imagePath.isEmpty
            ? Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  /// ⭐ **Rating UI**
  Widget _buildRating(double rating, int votes) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.orange[800], size: 22),
        SizedBox(width: 5),
        Text(
          '${rating.toStringAsFixed(1)} ⭐ ($votes votes)',
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange[800],
          ),
        ),
      ],
    );
  }
}
