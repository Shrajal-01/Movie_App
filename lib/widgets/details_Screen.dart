import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final int movieId;

  DetailsScreen({required this.movieId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  dynamic movieDetails;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows/${widget.movieId}'));

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Details")),
      body: movieDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movieDetails['image']['original'],
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    movieDetails['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(movieDetails['genres'].join(", "),
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(movieDetails['summary'], style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
    );
  }
}
