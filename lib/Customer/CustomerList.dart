// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:bodykitmaster/Customer/CustomerCreate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerOwner;
  final String customerContact;
  final String customerContactPhone;
  final String location;
  final String customerDescription;

  User(
      {required this.id,
      required this.customerName,
      required this.customerPhone,
      required this.customerOwner,
      required this.customerContact,
      required this.customerContactPhone,
      required this.location,
      required this.customerDescription});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerOwner: json['customerOwner'],
      customerContact: json['customerContact'],
      customerContactPhone: json['customerContactPhone'],
      location: json['location'],
      customerDescription: json['customerDescription'],
    );
  }
}

Future<List<User>> fetchUsers() async {
  final response =
      await http.get(Uri.parse('https://depo-server-main.vercel.app/api/customer'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load customer');
  }
}

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
                .where((user) => user.customerName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          } else if (searchType == 'owner') {
            filteredUsers = users
                .where((user) => user.customerOwner
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
                MaterialPageRoute(builder: (context) => CustomerCreate()),
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
                            DataCell(Text(user.customerName)),
                            DataCell(Text(user.customerPhone)),
                            DataCell(Text(user.customerOwner)),
                            DataCell(Text(user.customerContact)),
                            DataCell(Text(user.customerContactPhone)),
                            DataCell(Text(user.location)),
                            DataCell(Text(user.customerDescription)),
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
