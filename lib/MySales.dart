// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:bodykitmaster/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MySales extends StatefulWidget {
  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  List<String> customers = [];
  List<bool> selectedCustomers = [];

  final TextEditingController _customerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customersString = prefs.getString('customers');
    if (customersString != null) {
      List<dynamic> customersJson = json.decode(customersString);
      setState(() {
        customers = customersJson.map((e) => e.toString()).toList();
        selectedCustomers = List<bool>.generate(customers.length, (index) => false);
      });
    }
  }

  Future<void> _saveCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customersString = json.encode(customers);
    await prefs.setString('customers', customersString);
  }

  void _addCustomer() {
    if (_customerController.text.isNotEmpty) {
      setState(() {
        customers.add(_customerController.text);
        selectedCustomers.add(false);
        _customerController.clear();
        _saveCustomers();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Müşteri adı boş olamaz!'),
        ),
      );
    }
  }

  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
      selectedCustomers.removeAt(index);
      _saveCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = selectedCustomers.where((c) => c).length;
    int totalCount = customers.length;

    double percentage = totalCount > 0 ? (selectedCount / totalCount) * 100 : 0;

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customerController,
                            decoration: const InputDecoration(
                              labelText: 'Müşteri Adı',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addCustomer,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(customers[index]),
                            leading: Checkbox(
                              value: selectedCustomers[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedCustomers[index] = value!;
                                });
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteCustomer(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ), Column(children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('İşlem Sayısı: $selectedCount'),
                    Text('Toplam Müşteri Sayısı: $totalCount'),
                  ],
                ),
              ), Padding(
              padding: const EdgeInsets.only(right: 50),
              child: SizedBox(height: height*0.45,width: width*0.3,
                child: Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomPaint(
                            painter: DoughnutChartPainter(
                              selectedCount: selectedCount,
                              totalCount: totalCount,
                            ),
                            child: Center(
                              child: Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
              ),
            ),
            ],),
           
          ],
        ),
      ),
    );
  }
}

class DoughnutChartPainter extends CustomPainter {
  final int selectedCount;
  final int totalCount;

  DoughnutChartPainter({required this.selectedCount, required this.totalCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    double radius = size.width / 2;

    // Draw background circle (total)
    paint.color = const Color.fromARGB(255, 206, 85, 77);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // Draw foreground arc (selected)
    double sweepAngle = totalCount > 0 ? (selectedCount / totalCount) * 360 : 0;
    paint.color = const Color.fromARGB(255, 65, 158, 7);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      -90 * 3.14159 / 180,
      sweepAngle * 3.14159 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant DoughnutChartPainter oldDelegate) {
    return oldDelegate.selectedCount != selectedCount || oldDelegate.totalCount != totalCount;
  }
}

