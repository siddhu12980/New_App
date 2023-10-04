// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:third_proj2/navbar.dart';
import 'package:third_proj2/recipe_card.dart';
import 'package:third_proj2/box.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<void> loadImage(String imageUrl) async {
  //   await CachedNetworkImageProvider(imageUrl).loadImage(ImageConfiguration());

  // }
  List<String> imgs = <String>[
    'images/main.jpeg',
    'images/side.jpeg',
    'images/snack.jpeg',
    'mages/rice.jpeg',
    'images/soup.jpeg',
  ];
  late Future<Map<String, dynamic>> recipe;

  final String appId = '6bab5ee9';
  final String appKey = 'ca133d2a2fa905d51c234a369df08f74';
  final String query = 'chicken';

  Future<Map<String, dynamic>> fetchRecipes() async {
// Sample query (I can change it)

    try {
      final url = Uri.parse(
          'https://api.edamam.com/api/recipes/v2?type=public&beta=true&q=chicken&app_id=6bab5ee9&app_key=ca133d2a2fa905d51c234a369df08f74');
      // .replace(queryParameters: params);

      final res = await http.get(url);
      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    recipe = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      bottomNavigationBar: navbar(),
      body: FutureBuilder(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            String chaaka = snapshot.error.toString();
            return Center(child: Text(chaaka));
          }

          final data = snapshot.data!;
          // final recp = data['hits'][1]['recipe']['label'];

          // final img = data['hits'][1]['recipe']['image'];

          // print(recp);

          // return           FutureBuilder(
          //   future: loadImage(img),
          //   builder: (context, imageSnapshot) {
          //     if (imageSnapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //           child: CircularProgressIndicator.adaptive());
          //     }
          //     if (imageSnapshot.hasError) {
          //       String imageErrorMessage = imageSnapshot.error.toString();
          //       return Center(
          //           child: Text('Error loading image: $imageErrorMessage'));
          //     }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 160,
                    child: Image.asset(
                      'images/ban1.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: Image.asset(
                      'images/ban2.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 255,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final recp = data['hits'][index]['recipe']['label'];
                        final img = data['hits'][index]['recipe']['image'];

                        return recipecard(
                          label: recp,
                          image: img,
                        );
                      },
                    ),
                  ),

                  // for (int i = 1; i <= imgs.length;i++)
                  // {

                  // }

                  box(link: imgs[0]),
                  box(link: imgs[1]),
                  box(link: imgs[2]),
                  box(link: imgs[3]),
                  box(link: imgs[4]),
                ],
              ),
            ),
          );
          // }, //{ fro builder}
          // ); // for future builder
        },
      ),
    );
  }
}
