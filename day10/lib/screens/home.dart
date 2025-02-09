import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttons = [
      {'icon': Icons.settings, 'text': 'Settings', 'route': 'settings'},
      {'icon': Icons.category, 'text': 'Categories', 'route': 'categories'},
      {'icon': Icons.shopping_cart, 'text': 'Products', 'route': 'products'},
      {'icon': Icons.movie, 'text': 'Movies', 'route': 'movies'},
      {'icon': Icons.dashboard, 'text': 'Product Dashboard', 'route': 'productDashbord'},
      {'icon': Icons.movie_filter, 'text': 'Movies Dashboard', 'route': 'moviesDashbord'},
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.pink.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.pink.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 buttons per row for symmetry
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return _buildGridButton(
                context,
                icon: buttons[index]['icon'],
                text: buttons[index]['text'],
                route: buttons[index]['route'],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context,
      {required IconData icon, required String text, required String route}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.pink.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
