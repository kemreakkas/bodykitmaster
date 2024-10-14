// ignore_for_file: file_names, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors

// company post işlemi
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

Future<User> createUser(
    String companyName,
    String companyPhone,
    String companyOwner,
    String location,
    String companyContact,
    String companyContactPhone,
    String companyDescription) async {
  final response = await http.post(
    Uri.parse('https://depo-server.vercel.app/api/company'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'companyName': companyName,
      'companyPhone': companyPhone,
      'companyOwner': companyOwner,
      'companyContact': companyContact,
      'companyContactPhone': companyContactPhone,
      'location': location,
      'companyDescription': companyDescription,
    }),
  );

  print(response.body + '\n');
  print(response.statusCode);

  if (response.statusCode == 201 || response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create user');
  }
}

class CompanyCreate extends StatefulWidget {
  @override
  _CompanyCreateState createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyOwnerController = TextEditingController();
  final TextEditingController _companyContactController =
      TextEditingController();
  final TextEditingController _companyContactPhoneController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FİRMA EKLE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (_futureUser == null) ? buildForm() : buildFutureBuilder(),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _companyNameController,
            decoration: const InputDecoration(labelText: 'Firma Adı'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma Adı Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _companyPhoneController,
            decoration: const InputDecoration(labelText: 'Firma Numarası'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma Telefon Numarası Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _companyOwnerController,
            decoration: const InputDecoration(labelText: 'Firma sahibi'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma sahibi Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _companyContactController,
            decoration:
                const InputDecoration(labelText: 'Firma iletişim Kişisi'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma İletişim Kişisi Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _companyContactPhoneController,
            decoration:
                const InputDecoration(labelText: 'Firma iletişim numarası'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma İletişim Numarası';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Konumu'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firmanın Konumunu Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _companyDescriptionController,
            decoration: const InputDecoration(labelText: 'Firma açıklama'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma açıklaması Giriniz';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _futureUser = createUser(
                      _companyNameController.text,
                      _companyPhoneController.text,
                      _companyOwnerController.text,
                      _companyContactController.text,
                      _companyContactPhoneController.text,
                      _locationController.text,
                      _companyDescriptionController.text,
                    );
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text('User Created: ${snapshot.data!.companyName}');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
