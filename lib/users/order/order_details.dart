import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/model/order.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget
{
  final Order? clickOrderInfo;

  OrderDetailsScreen({
    this.clickOrderInfo
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  // RxString _status = "Delivered".obs;
  RxString _status = "Processed".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelReceived)
  {
    _status.value = parcelReceived;
  }

  // showDialogForParcelConfirmation() async
  // {
  //   if(widget.clickOrderInfo!.status == "Processed")
  //   {
  //     var response = await Get.dialog(
  //       AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Text(
  //           "Confirmation",
  //           style: TextStyle(
  //             color: Colors.black,
  //           ),
  //         ),
  //         content: const Text(
  //           "Have You Received Your Order ?",
  //           style: TextStyle(
  //             color: Colors.pinkAccent,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: ()
  //               {
  //                 Get.back();
  //               },
  //               child: const Text(
  //                 "No",
  //                 style: TextStyle(color: Colors.redAccent),
  //               )
  //           ),
  //           TextButton(
  //               onPressed: ()
  //               {
  //                 Get.back(result: "yesConfirmed");
  //               },
  //               child: const Text(
  //                 "Yes",
  //                 style: TextStyle(color: Colors.green),
  //               )
  //           )
  //         ],
  //       ),
  //     );
  //
  //     if(response == "yesConfirmed")
  //     {
  //       updateStatusValueInDatabase();
  //     }
  //   }
  // }

  // updateStatusValueInDatabase() async
  // {
  //   try
  //   {
  //     var response = await http.post(
  //         Uri.parse(Api.updateStatus),
  //         body:
  //         {
  //           "order_id": widget.clickOrderInfo!.order_id.toString(),
  //         }
  //     );
  //     if(response.statusCode == 200)
  //     {
  //       var responseBodyOfUpdateStatus = jsonDecode(response.body);
  //       if(responseBodyOfUpdateStatus["success"] == true)
  //       {
  //         updateParcelStatusForUI("Finished");
  //       }
  //     }
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateParcelStatusForUI(widget.clickOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.clickOrderInfo!.dateTime!),
          style: const TextStyle(fontSize: 14),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            // child: Material(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            //   child: InkWell(
            //     onTap: ()
            //     {
            //       if(status == "Processed")
            //       {
            //         // showDialogForParcelConfirmation();
            //       }
            //     },
            //     borderRadius: BorderRadius.circular(30),
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //       child: Row(
            //         children: [
            //           // const Text(
            //           //   "Processed",
            //           //   style: TextStyle(
            //           //     fontSize: 14,
            //           //     fontWeight: FontWeight.bold,
            //           //     color: Colors.pinkAccent,
            //           //   ),
            //           // ),
            //           // const SizedBox(width: 8,),
            //           // // Obx(() =>
            //           // // status == "Processed"
            //           // //     ? const Icon(Icons.help_outline_outlined, color: Colors.pinkAccent,)
            //           // //     : const Icon(Icons.check_circle_outline, color: Colors.greenAccent,)
            //           // // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--------- DISPLAY ITEMS BELONGS TO CLICKED ORDER -------------//
              displayClickedOrderItems(),

              const SizedBox(height: 16,),

              //------ PHONE NUMBER ------------------------------------------//
              showTitleText("Phone Number:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.phoneNumber!),

              const SizedBox(height: 26,),

              //------ SHIPMENT ADD ------------------------------------------//
              showTitleText("Shipment Address:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.shipmentAddress!),

              const SizedBox(height: 26,),

              //------ DELIVERY ------------------------------------------//
              showTitleText("Delivery System:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.deliverySystem!),

              const SizedBox(height: 26,),

              //------ PAYMENT ------------------------------------------//
              showTitleText("Payment System:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.paymentSystem!),

              const SizedBox(height: 26,),

              //------ NOTE TO SELLER ----------------------------------------//
              showTitleText("Note To Seller:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.note!),

              const SizedBox(height: 26,),

              //------ TOTAL AMOUNT ----------------------------------------//
              showTitleText("Total Amount:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.totalAmount.toString()),

              const SizedBox(height: 26),

              //---------- STATUS ORDER --------------------------------------//
              showTitleText("Status:"),
              const SizedBox(height: 8,),
              showContentText(widget.clickOrderInfo!.status.toString()),

              const SizedBox(height: 26),

              //------ PAYMENT PROOF IMAGES ----------------------------------//
              showTitleText("Payment Image:"),
              const SizedBox(height: 8,),
              FadeInImage(
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
                placeholder: const AssetImage("images/placeholder.png"),
                image: NetworkImage(
                    Api.hostImages + widget.clickOrderInfo!.image!
                ),
                imageErrorBuilder: (context, error, stackTraceError)
                {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  //----- REUSABLE WIDGET UNTUK MENAMPILKAN JUDUL ----------------------------//

  Widget showTitleText(String titleText)
  {
    return Text(
      titleText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.pinkAccent,
      ),
    );
  }

  //----- REUSABLE WIDGET UNTUK MENAMPILKAN INFORMASI PESANAN ----------------//

  Widget showContentText(String contentText)
  {
    return Text(
      contentText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.pinkAccent,
      ),
    );
  }

  Widget displayClickedOrderItems()
  {
    List<String> clickedOrderItemsInfo = widget.clickOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo!.length, (index)
      {
        Map<String, dynamic> itemInfo = jsonDecode(clickedOrderItemsInfo[index]);
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == clickedOrderItemsInfo.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.pink,
              )
            ],
          ),
          child: Row(
            children: [
              //------------ DISPLAY THE IMAGE -------------------------------//
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                ),
                child: FadeInImage(
                  height: 150,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/placeholder.png"),
                  image: NetworkImage(
                    itemInfo["image"],
                  ),
                  imageErrorBuilder: (context, error, stackTraceError)
                  {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME
                      Text(
                        itemInfo["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 16),

                      //---------------- DISPLAY VARIAN & SIZE -------------//
                      Text(
                        itemInfo["varian"].replaceAll("[", "").replaceAll("]", "") + "\n" +
                            itemInfo["size"].replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //---- TOTAL AMOUNT -------//
                      Text(
                        "Rp" + itemInfo["totalAmount"].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   eachSelectedItem["price"].toString() + " x " + eachSelectedItem["quantity"].toString()
                      //   + " = " + eachSelectedItem["totalAmount"].toString(),
                      //   style: const TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              //------------ DISPLAY THE QUANTITY ---------------------------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q: " + itemInfo["quantity"].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),


            ],
          ),
        );
      }),


    );
  }
}