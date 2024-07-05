import 'package:flutter/material.dart';

class NavBarItemModel {
  final String path;
  final String value;
  final IconData icon;

  NavBarItemModel({
    required this.path,
    required this.value,
    required this.icon,
  });
}

final drawerPublicItems = [
  NavBarItemModel(
    path: '/',
    value: 'Home',
    icon: Icons.home,
  ),
  NavBarItemModel(
    path: '/xtreme',
    value: 'Xtreme',
    icon: Icons.emoji_events,
  ),
  NavBarItemModel(
    path: '/scouting',
    value: 'Scouting',
    icon: Icons.person_search,
  ),
];

final drawerPrivateItems = [
  NavBarItemModel(
    path: '/squad',
    value: 'Team',
    icon: Icons.people,
  ),
  NavBarItemModel(
    path: '/training',
    value: 'Training',
    icon: Icons.self_improvement,
  ),
];
