import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skincare_app/users/userPreferences/current_user.dart';

class CartListScreen extends StatefulWidget {

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen>
{
  final currentOnlineUser = Get.put(CurrentUser());
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
