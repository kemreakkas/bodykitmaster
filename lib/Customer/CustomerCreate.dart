// ignore_for_file: file_names, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors

// customer post işlemi
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

Future<User> createUser(
    String customerName,
    String customerPhone,
    String customerOwner,
    String location,
    String customerContact,
    String customerContactPhone,
    String customerDescription) async {
  final response = await http.post(
    Uri.parse('https://depo-server.vercel.app/api/customer'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerOwner': customerOwner,
      'customerContact': customerContact,
      'customerContactPhone': customerContactPhone,
      'location': location,
      'customerDescription': customerDescription,
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

class CustomerCreate extends StatefulWidget {
  @override
  _CustomerCreateState createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerOwnerController = TextEditingController();
  final TextEditingController _customerContactController =
      TextEditingController();
  final TextEditingController _customerContactPhoneController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _customerDescriptionController =
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
            controller: _customerNameController,
            decoration: const InputDecoration(labelText: 'Firma Adı'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma Adı Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _customerPhoneController,
            decoration: const InputDecoration(labelText: 'Firma Numarası'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma Telefon Numarası Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _customerOwnerController,
            decoration: const InputDecoration(labelText: 'Firma sahibi'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Firma sahibi Giriniz';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _customerContactController,
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
            controller: _customerContactPhoneController,
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
            controller: _customerDescriptionController,
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
                      _customerNameController.text,
                      _customerPhoneController.text,
                      _customerOwnerController.text,
                      _customerContactController.text,
                      _customerContactPhoneController.text,
                      _locationController.text,
                      _customerDescriptionController.text,
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
            return Text('User Created: ${snapshot.data!.customerName}');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
