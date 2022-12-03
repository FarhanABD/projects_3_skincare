import 'package:flutter/material.dart';
import 'package:skincare_app/users/model/skincare.dart';

class ItemDetailsScreen extends StatefulWidget
{
  final Skincare? itemInfo;

  ItemDetailsScreen({this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>

{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
