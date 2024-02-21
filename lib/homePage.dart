import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:galerie_/apikey.dart';
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

TextEditingController control = TextEditingController();
List<dynamic> Foto = [];
String q = '';

class _MyWidgetState extends State<MyWidget> {
  Future<void> getFotos() async {
    String getFotosApi =
        'https://pixabay.com/api/?key=${ApiKey.PixabayApiKey}&q=$q&image_type=photo&per_page=200';
    final get = await http.get(Uri.parse(getFotosApi));
    try {
      final body = get.body;
      final response = jsonDecode(body);
      final fotos = response['hits'];
      setState(() {
        Foto = fotos;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getFotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            SizedBox(
              height: 60,
              width: 400,
              child: TextField(
                controller: control,
                onChanged: (value) {
                  q = value;
                  setState(() {
                    getFotos();
                  });
                },
              ),
            ),
          ],
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 2,
          ),
          itemCount: Foto.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Image.network(
                    '${Foto[index]['previewURL']}',
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      Text('${Foto[index]['likes']}'),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(Icons.comment_outlined),
                      Text('${Foto[index]['comments']}')
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
