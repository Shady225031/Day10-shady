// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:day10/screens/categories.dart';
import 'package:day10/screens/home.dart';
import 'package:day10/screens/product_list.dart';
import 'package:day10/screens/settings.dart';
import 'package:flutter/material.dart';

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
          backgroundColor: Colors.green,
          bottom: TabBar(tabs: [
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Products',
              icon: Icon(Icons.shopify_outlined),
            ),
            Tab(
              text: 'Categories',
              icon: Icon(Icons.category),
            ),
            Tab(
              text: 'Settings',
              icon: Icon(Icons.settings),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            HomePage(),
            ProductListPage(),
            CategoriesPage(),
            SettingPage()
          ],
        ),
      ),
    );
  }
}