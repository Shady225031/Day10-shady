// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:day10/web_services/api_service.dart';
import 'package:day10/model/tvshow.dart';
import 'package:day10/screens/tvshow_details.dart'; // Import the details screen
import 'package:shimmer/shimmer.dart';

class TvShowListPage extends StatefulWidget {
  const TvShowListPage({super.key});

  @override
  State<TvShowListPage> createState() => _TvShowListPageState();
}

class _TvShowListPageState extends State<TvShowListPage> {
  late Future<List<TvShow>> tvShows;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    tvShows = ApiService().getTvShows(currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        getMoreTvShows();
      }
    });
  }

  void getMoreTvShows() async {
    setState(() {
      isLoadingMore = true;
    });

    List<TvShow> newShows = await ApiService().getTvShows(currentPage + 1);
    setState(() {
      currentPage++;
      tvShows = Future.value([...newShows]);
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('TV Shows'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TvShow>>(
        future: tvShows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingUI();
          } else if (snapshot.hasError) {
            return _buildErrorUI(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildErrorUI("No TV Shows Available");
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final tvShow = snapshot.data![index];
                    return _buildTvShowCard(tvShow);
                  },
                ),
              ),
              if (isLoadingMore) CircularProgressIndicator(),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  /// 🔵 **Loading Shimmer UI**
  Widget _buildLoadingUI() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Container(
                width: 100,
                height: 100,
                color: Colors.white,
              ),
              title: Container(
                height: 16,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ❌ **Error UI**
  Widget _buildErrorUI(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  /// 📺 **TV Show Card**
  Widget _buildTvShowCard(TvShow tvShow) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TvShowDetailsScreen(tvShowId: tvShow.id),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildImage(tvShow.posterPath),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvShow.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      tvShow.overview.isNotEmpty ? tvShow.overview : "No Description Available",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🖼️ **Image with Placeholder**
  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imagePath.isNotEmpty
          ? Image.network(
              'https://image.tmdb.org/t/p/w500$imagePath',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
              ),
            ),
    );
  }
}
