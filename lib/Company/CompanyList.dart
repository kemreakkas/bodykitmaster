// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:bodykitmaster/Company/CompanyCreate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String companyName;
  final String companyPhone;
  final String companyOwner;
  final String companyContact;
  final String companyContactPhone;
  final String location;
  final String companyDescription;

  User(
      {required this.id,
      required this.companyName,
      required this.companyPhone,
      required this.companyOwner,
      required this.companyContact,
      required this.companyContactPhone,
      required this.location,
      required this.companyDescription});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      companyName: json['companyName'],
      companyPhone: json['companyPhone'],
      companyOwner: json['companyOwner'],
      companyContact: json['companyContact'],
      companyContactPhone: json['companyContactPhone'],
      location: json['location'],
      companyDescription: json['companyDescription'],
    );
  }
}

Future<List<User>> fetchUsers() async {
  final response =
 await http.get(Uri.parse('https://depo-server-main.vercel.app/api/company'));
    
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load company');
  }
}

class CompanyList extends StatefulWidget {
  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  late Future<List<User>> futureUsers;
  List<User> filteredUsers = [];
  String searchQuery = '';
  String searchType = 'name';

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    futureUsers.then((users) {
      setState(() {
        filteredUsers = users;
      });
    });
  }

  void filterSearchResults(String query) {
    futureUsers.then((users) {
      if (query.isEmpty) {
        setState(() {
          filteredUsers = users;
        });
        return;
      } else {
        setState(() {
          if (searchType == 'name') {
            filteredUsers = users
                .where((user) => user.companyName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          } else if (searchType == 'owner') {
            filteredUsers = users
                .where((user) => user.companyOwner
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firma Listesi'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyCreate()),
              );
            },
            child: const Text('FİRMA EKLE'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      filterSearchResults(value);
                    },
                    decoration: const InputDecoration(
                      labelText: "Ara",
                      hintText: "Arama terimi girin",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: searchType,
                  onChanged: (String? newValue) {
                    setState(() {
                      searchType = newValue!;
                    });
                  },
                  items: <String>['name', 'owner']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(value == 'name' ? 'Firma Adı' : 'Firma Sahibi'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'FİRMA ADI',
                            style: TextStyle(),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'FİRMA TELEFON',
                            style: TextStyle(),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'FİRMA SAHİBİ',
                            style: TextStyle(),
                          ),
                        ), DataColumn(
                          label: Text(
                            'FİRMA iletişim kişisi',
                            style: TextStyle(),
                          ),
                        ), DataColumn(
                          label: Text(
                            'FİRMA iletişim kişi telefon',
                            style: TextStyle(),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'KONUMU',
                            style: TextStyle(),
                          ),
                        ), DataColumn(
                          label: Text(
                            'FİRMA Açıklama',
                            style: TextStyle(),
                          ),
                        ),
                      ],
                      rows: filteredUsers.map((user) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(user.companyName)),
                            DataCell(Text(user.companyPhone)),
                            DataCell(Text(user.companyOwner)),
                            DataCell(Text(user.companyContact)),
                            DataCell(Text(user.companyContactPhone)),
                            DataCell(Text(user.location)),
                            DataCell(Text(user.companyDescription)),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const Text("No data available");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
