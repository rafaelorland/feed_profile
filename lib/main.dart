import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Projeto {
  final String id;
  final String created;
  final String title;
  final String description;
  final String img;
  final String owner;

  Projeto({
    required this.id,
    required this.created,
    required this.title,
    required this.description,
    required this.img,
    required this.owner,
  });

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      id: json['id'],
      created: json['created'],
      title: json['title'],
      description: json['description'],
      img: json['img'],
      owner: json['owner'],
    );
  }
}

Future<List<Projeto>> fetchProjetos() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.10:8000/api/projetos/'));
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    List<Projeto> projetos =
        data.map((item) => Projeto.fromJson(item)).toList();

    return projetos;
  } else {
    throw Exception(
        'Falha na solicitação. Código de status: ${response.statusCode}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amberAccent,
        body: MyHedline(),
      ),
    );
  }
}

class MyHedline extends StatefulWidget {
  const MyHedline({super.key});

  @override
  State<MyHedline> createState() => _MyHedlineState();
}

class _MyHedlineState extends State<MyHedline> {
  bool indexdescription = false;
  double poY = .0;
  @override
  Widget build(BuildContext context) {
    poY = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 65,
          bottom: 60,
          child: FutureBuilder<List<Projeto>>(
            future: fetchProjetos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Nenhum projeto encontrado.');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final projeto = snapshot.data![index];

                    return PageApp(
                      username: projeto.owner,
                      description: projeto.description,
                      imagenet:
                          'http://192.168.0.10:8000' + projeto.img.toString(),
                      created: projeto.created,
                    );
                  },
                );
              }
            },
          ),
        ),

        ///PageApp(username: 'Rafael', imagenet: 'https://oimparcial.com.br/app/uploads/2021/04/azul-caneta.jpg',),
        ///PageApp(username: 'Orlando',),
        ///PageApp(username: 'Python',),
        AppBar(),
        BottomBar(),
      ],
    );
  }
}

class PageApp extends StatelessWidget {
  final String username;
  final String description;
  final String imagenet;
  final double pY = .0;
  final bool indexdescription = false;
  final String created;

  const PageApp({
    super.key,
    required this.username,
    this.imagenet =
        'https://ouch-cdn2.icons8.com/LTBk5i7gqDjzRF1QROh1WfEsyOc-2-niV64P3P_w6AQ/rs:fit:256:242/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzc5/L2Q2NWExYmQ4LWM1/ZjItNDA5OS04OWYw/LTJjMzJjZjU4ZGNi/OC5zdmc.png',
    required this.description,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.white54,
              height: MediaQuery.of(context).size.height * .65,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Icon(Icons.person),
                          SizedBox(
                            width: 10,
                          ),
                          Text(username),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 50,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .40,
                      child: Image.network(
                        imagenet,
                        scale: .01,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * .45,
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width: 25),
                          Icon(Icons.favorite),
                          SizedBox(width: 20),
                          Icon(Icons.comment),
                          SizedBox(width: 20),
                          Icon(Icons.send)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    right: 25,
                    top: MediaQuery.of(context).size.height * .50,
                    child: Container(
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 100,
                              child: ListView(
                                children: [Text(description)],
                              )),
                          Container(
                            height: 20,
                            child: Text(created),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ],
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).systemGestureInsets.top * .65,
      child: Container(
        height: 50,
        color: Colors.amberAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
                'https://ouch-cdn2.icons8.com/zXwePE3vsyLBJIzJDDncCxqU1JJ06XbVTnNB9vA4g08/rs:fit:256:256/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMzQ5/LzYzNGZjYTM2LTdi/MzItNDZlMC05Nzkx/LTQ2MWIxNzNkZDZl/Yy5zdmc.png')
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 60,
        color: Colors.amberAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                print('click home');
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                print('click search');
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                print('click person');
              },
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
