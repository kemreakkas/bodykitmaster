// ignore_for_file: file_names, prefer_const_constructors_in_immutables, unused_import, unused_element

import 'package:bodykitmaster/Calendar/events_example.dart';
import 'package:bodykitmaster/Company/CompanyList.dart';
import 'package:bodykitmaster/Constants.dart';
import 'package:bodykitmaster/Homesidebar.dart';
import 'package:bodykitmaster/Pages/MySales.dart';
import 'package:bodykitmaster/Pages/SellProduct.dart';
import 'package:bodykitmaster/Pages/SettingsPage.dart';
import 'package:bodykitmaster/WarehouseList.dart';
import 'package:bodykitmaster/notes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return SafeArea(
            child: Scaffold(
              key: _key,
              drawer: HomeSidebarX(controller: _controller),
              body: Row(
                children: [
                  if (!isSmallScreen) HomeSidebarX(controller: _controller),
                  Expanded(
                    child: Center(
                      child: _Screens(
                        controller: _controller,
                        isDarkMode: _isDarkMode,
                        onThemeChanged: (isDark) {
                          setState(() {
                            _isDarkMode = isDark;
                            _saveTheme(isDark);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.blue,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 46,
      fontWeight: FontWeight.w800,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.grey[850],
  canvasColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 46,
      fontWeight: FontWeight.w800,
    ),
  ),
);

class _Screens extends StatefulWidget {
  final SidebarXController controller;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  _Screens({
    required this.controller,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<_Screens> createState() => _ScreensState();
}

class _ScreensState extends State<_Screens> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final SidebarXController _controller =
      SidebarXController(selectedIndex: 0, extended: true);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale(
        'tr_TR',
      ),
      initialDate: focusedDay,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2050, 3, 14),
    );
    if (picked != null && picked != focusedDay) {
      setState(() {
        focusedDay = picked;
        selectedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        switch (widget.controller.selectedIndex) {
          case 0:
            return Scaffold(
              drawer: _buildSidebar(),
              body: Row(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                     //   _buildCalendar(),
                        /*NotesSection(
                          notes: notes[selectedDay] ?? [],
                          onNotesChanged: (updatedNotes) {
                            setState(() {
                              notes[selectedDay] = updatedNotes;
                            });
                          },
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ); 
                 //_selectDate(context);
                },
                child: const Icon(Icons.calendar_today),
              ),
            );
          case 1:
            return const WarehouseList();
          case 2:
            return const SellProduct();
          case 3:
            return CompanyList();
          case 4:
            
            return MySales();
          case 6:
            return SettingsPage(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,
            );
          default:
            return const Text('default state');
        }
      },
    );
  }

  Widget _buildSidebar() {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.grey[850],
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[900]!),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.withOpacity(0.37)),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.grey],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme:
            IconThemeData(color: Colors.white.withOpacity(0.7), size: 20),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('LOGO'),
          ),
        );
      },
      items: const [
        SidebarXItem(icon: Icons.home, label: 'Ana Sayfa'),
        SidebarXItem(icon: Icons.warehouse, label: 'Depo Bilgileri'),
        SidebarXItem(icon: Icons.sell, label: 'Ürün Satış'),
        SidebarXItem(icon: Icons.business_center, label: 'Firmalar'),
        SidebarXItem(icon: Icons.attach_money, label: 'Satışlar'),
        SidebarXItem(icon: Icons.settings, label: 'Ayarlar'),
      ],
    );
  }

  Widget _buildCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Takvim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TableCalendar(
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                locale: 'tr_TR',
                firstDay: DateTime.utc(2015, 1, 1),
                lastDay: DateTime.utc(2050, 3, 14),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


 