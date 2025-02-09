import 'package:flutter/material.dart';
import 'package:day10/web_services/firebase_service_movie.dart';

class MovieDashboard extends StatefulWidget {
  const MovieDashboard({super.key});

  @override
  State<MovieDashboard> createState() => _MovieDashboardState();
}

class _MovieDashboardState extends State<MovieDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  Map<String, dynamic> movies = {};
  bool _isEditing = false;
  String? _editedMovieId;

  @override
  void initState() {
    super.initState();
    getMoviesData();
  }

  void _saveData() async {
    final title = _titleController.text.trim();
    final rating = _ratingController.text.trim();

    if (title.isEmpty || rating.isEmpty) return;

    var newMovie = {'title': title, 'rating': double.parse(rating)};
    if (_isEditing && _editedMovieId != null) {
      await _firebaseService.editMovie(_editedMovieId!, newMovie);
      setState(() {
        _isEditing = false;
        _editedMovieId = null;
      });
    } else {
      await _firebaseService.addMovie(newMovie);
    }

    _titleController.clear();
    _ratingController.clear();
    getMoviesData();
  }

  void getMoviesData() async {
    var response = await _firebaseService.getMovies();
    setState(() {
      movies = response;
    });
  }

  void deleteMovie(String id) async {
    await _firebaseService.deleteMovieData(id);
    getMoviesData();
  }

  void _editMovie(String movieId, Map<String, dynamic> movieData) {
    setState(() {
      _isEditing = true;
      _editedMovieId = movieId;
      _titleController.text = movieData['title'];
      _ratingController.text = movieData['rating'].toString();
    });
  }

  void _showMovieDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_isEditing ? "Edit Movie" : "Add Movie"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Movie Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.movie),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Movie Rating',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _titleController.clear();
                _ratingController.clear();
                setState(() {
                  _isEditing = false;
                  _editedMovieId = null;
                });
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text(_isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Movie Dashboard'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: movies.isEmpty
            ? Center(child: Text("No movies added yet!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movieId = movies.keys.elementAt(index);
                  final movieData = movies[movieId];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.movie, color: Colors.deepPurple),
                      ),
                      title: Text(
                        movieData['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Rating: ⭐ ${movieData['rating']}',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editMovie(movieId, movieData),
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => deleteMovie(movieId),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _showMovieDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
