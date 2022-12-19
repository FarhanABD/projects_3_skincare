import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/model/order.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/users/userPreferences/current_user.dart';
import 'package:get/get.dart';


class OrderFragmentScreen extends StatelessWidget
{
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Order>> getCurrentUserOrdersList() async
  {
    List<Order> ordersListOfCurrentUser = [];
    try
    {
      var res = await http.post(
          Uri.parse(Api.readOrders),
          body:
          {
            "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true)
        {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List).forEach((eachCurrentUserOrderData)
          {
            ordersListOfCurrentUser.add(Order.fromJson(eachCurrentUserOrderData));
          });
        }

      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code Is Not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error :: " + errorMsg.toString());
    }

    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------- DISPLAY USER ORDER LIST ------------------------//
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //------- ORDER ICONS IMAGE & My order
                Column(
                  children: [
                    Image.asset(
                      "images/order_icons.png",
                      width: 130,
                    ),
                    const Text(
                        "My Orders",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "images/order_history.png",
                        width: 50,
                      ),
                      const Text(
                        "History",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: displayOrderList(context),
          ),

        ],
      ),
    );
  }

  Widget displayOrderList(context)
  {
    return FutureBuilder(
        future: getCurrentUserOrdersList(),
        builder: (context, AsyncSnapshot<List<Order>> dataSnapshot)
        {
          if(dataSnapshot.connectionState == ConnectionState.waiting)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("Connection Waiting..",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],

            );
          }

          if(dataSnapshot.data == null)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("No Orders Found :(",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],

            );
          }

          if(dataSnapshot.data!.length > 0)
          {
           List<Order> orderlist = dataSnapshot.data!;
            return ListView.separated
              (
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index)
                {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
              itemCount: orderlist.length,
              itemBuilder: (context, index)
              {
                Order eachOrderData = orderlist[index];

                return Card(
                  color: Colors.pink[100],
                  child: Padding(padding: EdgeInsets.all(18),
                  child: ListTile(
                    onTap: ()
                    {

                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID #" + eachOrderData.order_id.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        Text(
                          "Amount: Rp " + eachOrderData.totalAmount.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //----------- DISPLAY THE DATE  ------------------//
                            Text(
                              DateFormat(
                                "dd MMMM, yyyy"
                              ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.black,

                              ),
                            ),

                            const SizedBox(height: 4),

                            //------------------- DISPLAY THE TIME -----------//
                            Text(
                              DateFormat(
                                  "hh:mm a"
                              ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 6),

                        Icon(
                          Icons.navigate_next,
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),
                  ),
                  ),
                );

              },
            );
          }
          else
          {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("Order Page Is Empty",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],

            );
          }
        },
    );
  }
}
