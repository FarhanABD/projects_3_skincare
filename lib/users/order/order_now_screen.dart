import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skincare_app/users/controllers/order_now_controller.dart';

class OrderNowScreen extends StatelessWidget
{
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["JNE", "J&T" ,"SiCepat"];
  List<String> paymentSystemNamesList = ["Transfer", "DANA" ,"GoPAY"];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  OrderNowScreen({
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text(
          "Order Now",
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          //------------ DISPLAY SELECTED ITEMS FROM CART --------------------//
          const SizedBox(height: 30),


          //------------- DELIVERY SYSTEM ------------------------------------//
           const Padding(
             padding: EdgeInsets.symmetric(horizontal: 16.0),
             child: Text(
              "Delivery System",
              style: TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
          ),
           ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: deliverySystemNamesList.map((deliverySystemName)
              {
                return Obx(() =>
                    RadioListTile<String>(
                      tileColor: Colors.pink[100],
                      dense: true,
                      activeColor: Colors.pinkAccent,
                      title: Text(
                        deliverySystemName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.pinkAccent,),
                      ),
                      value: deliverySystemName,
                      groupValue: orderNowController.deliverySys,
                      onChanged: (newDeliverySystemValue)
                      {
                        orderNowController.setDeliverySystem(newDeliverySystemValue!);
                      },
                    )
                );
              }).toList(),
            ),

          ),

          const SizedBox(height: 16),

          //------------ PAYMENT SYSTEM --------------------------------------//
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Payment System",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                 SizedBox(height: 2,),

                Text(
                  "No Rekening: 0264420300 \n Phone Number Seller : 081353401336",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: paymentSystemNamesList.map((paymentSystemName)
              {
                return Obx(() =>
                    RadioListTile<String>(
                      tileColor: Colors.pink[100],
                      dense: true,
                      activeColor: Colors.pinkAccent,
                      title: Text(
                        paymentSystemName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.pinkAccent),
                      ),
                      value: paymentSystemName,
                      groupValue: orderNowController.paymentSys,
                      onChanged: (newPaymentSystemValue)
                      {
                        orderNowController.setPaymentSystem(newPaymentSystemValue!);
                      },
                    )
                );
              }).toList(),
            ),

          ),

          const SizedBox(height: 16),

          //------------- PHONE NUMBER INPUT ---------------------------------//
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Phone Number:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.black
              ),
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "Your Phone Number..",
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //------------- SHIPMENT ADRESS INPUT ------------------------------//
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Shipment Address:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                  color: Colors.black
              ),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintText: "Your Shipment Address...",
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //------------- NOTE TO SELLER INPUT ------------------------------//
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Note To Seller:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                  color: Colors.black
              ),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintText: "Your Note To Seller...",
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          //--------------- PAY AMOUNT NOW BUTTON ----------------------------//
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {

                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  child: Row(
                    children: [
                      Text(
                        "Rp" + totalAmount!.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Spacer(),

                      const Text(
                        "Pay Amount Now",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            ),
          ),

          const SizedBox(height: 30),


        ],


      ),
    );
  }
}
