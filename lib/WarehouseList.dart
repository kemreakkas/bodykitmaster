// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:bodykitmaster/Constants.dart';
import 'package:flutter/material.dart';

class WarehouseItem {
  final String id;
  final String stockNumber;
  final String productName;
  final String warehouse;
  final String stock;
  final String purchasePrice;
  final String salePrice;

  WarehouseItem({
    required this.id,
    required this.stockNumber,
    required this.productName,
    required this.warehouse,
    required this.stock,
    required this.purchasePrice,
    required this.salePrice,
  });
}

class WarehouseList extends StatefulWidget {
  const WarehouseList({super.key});

  @override
  _WarehouseListState createState() => _WarehouseListState();
}

class _WarehouseListState extends State<WarehouseList> {
  List<WarehouseItem> items = [
    WarehouseItem(id: '1', stockNumber: 'Sak12345', productName: 'saksı', warehouse: 'A Deposu', stock: '987', purchasePrice: '100', salePrice: '123'),
    WarehouseItem(id: '2', stockNumber: 'TPRK12345', productName: 'toprak', warehouse: 'A Deposu', stock: '987', purchasePrice: '111', salePrice: '222'),
    WarehouseItem(id: '3', stockNumber: 'Elma123', productName: 'Elma', warehouse: 'B Deposu', stock: '5432', purchasePrice: '2345', salePrice: '5432'),
    WarehouseItem(id: '4', stockNumber: 'armut312312', productName: 'armut', warehouse: 'B Deposu', stock: '324', purchasePrice: '3245', salePrice: '97867'),
     WarehouseItem(id: '1', stockNumber: 'Sak12345', productName: 'saksı', warehouse: 'A Deposu', stock: '987', purchasePrice: '100', salePrice: '123'),
    WarehouseItem(id: '2', stockNumber: 'TPRK12345', productName: 'toprak', warehouse: 'A Deposu', stock: '987', purchasePrice: '111', salePrice: '222'),
    WarehouseItem(id: '3', stockNumber: 'Elma123', productName: 'Elma', warehouse: 'B Deposu', stock: '5432', purchasePrice: '2345', salePrice: '5432'),
    WarehouseItem(id: '4', stockNumber: 'armut312312', productName: 'armut', warehouse: 'B Deposu', stock: '324', purchasePrice: '3245', salePrice: '97867'),
    // Diğer örnek verileri buraya ekleyebilirsiniz.
  ];

  List<WarehouseItem> filteredItems = [];
  String searchQuery = '';
  String searchType = 'stockNumber';

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = items;
      });
      return;
    } else {
      setState(() {
        filteredItems = items.where((item) {
          switch (searchType) {
            case 'stockNumber':
              return item.stockNumber.toLowerCase().contains(query.toLowerCase());
            case 'productName':
              return item.productName.toLowerCase().contains(query.toLowerCase());
            case 'warehouse':
              return item.warehouse.toLowerCase().contains(query.toLowerCase());
            default:
              return false;
          }
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Bilgileri'),
        backgroundColor: canvasColor,
        foregroundColor: white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                      filterSearchResults(searchQuery);
                    },
                    items: <String>['stockNumber', 'productName', 'warehouse']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'stockNumber'
                            ? 'Stok Numarası'
                            : value == 'productName'
                                ? 'Ürün Adı'
                                : 'Depo'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stok\nNumarası',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Ürün\nAdı',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Depo',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stok',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Alış\nFiyatı',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Satış\nFiyatı',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: filteredItems.map((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(item.id)),
                        DataCell(Text(item.stockNumber)),
                        DataCell(Text(item.productName)),
                        DataCell(Text(item.warehouse)),
                        DataCell(Text(item.stock)),
                        DataCell(Text(item.purchasePrice)),
                        DataCell(Text(item.salePrice)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
