import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task2/model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();

  List<User> users = [];
  List<User> filteredUsers = [];

  void fetchUser() async {
    final response = await http
        .get(Uri.parse(('https://jsonplaceholder.typicode.com/users')));
    final List<dynamic> body = jsonDecode(response.body);
    setState(() {
      users = List.generate(body.length, (index) => User.fromJson(body[index]));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(22),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        trailing: IconButton(
                          onPressed: () {
                            textEditingController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        title: TextFormField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              filteredUsers = users
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(textEditingController.text
                                          .toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    users.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredUsers.isNotEmpty
                                ? filteredUsers.length
                                : users.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers.isNotEmpty
                                  ? filteredUsers[index]
                                  : users[index];
                              return Card(
                                child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.name),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          user.email,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                          "https://via.placeholder.com/40x40"),
                                    )),
                              );
                            },
                          )
                        : const CircularProgressIndicator()
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
