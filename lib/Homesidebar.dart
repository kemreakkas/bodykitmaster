// ignore_for_file: file_names, unused_element

import 'package:bodykitmaster/Constants.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeSidebarX extends StatelessWidget {
  const HomeSidebarX({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(padding: EdgeInsets.all(16.0), child: Text('LOGO')),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Ana Sayfa',
        ),
        const SidebarXItem(
          icon: Icons.warehouse,
          label: 'Stok Bilgileri',
        ),
        SidebarXItem(
          icon: Icons.sell,
          label: 'Müşteriler',
        ),
        SidebarXItem(
          icon: Icons.business_center,
          label: 'Firmalar',
          //  onTap: () => _showDisabledAlert(context),
        ),
        SidebarXItem(
          icon: Icons.attach_money,
          label: 'Satışlar',
          //    onTap: () => _showDisabledAlert(context),
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Ayarlar',
          //   onTap: () => _showDisabledAlert(context),
        ),
      ],
    );
  }

  void _showDisabledAlert(BuildContext context) {}
}
