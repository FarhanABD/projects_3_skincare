import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/users/controllers/order_now_controller.dart';
import 'package:skincare_app/users/order/order_confirmation.dart';

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
          displaySelectedItemsFromUserCart(),

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
                  "No Rekening: 0264420300 \nPhone Number Seller : 081353401336",
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
                 if(phoneNumberController.text.isNotEmpty && shipmentAddressController.text.isNotEmpty)
                 {
                   Get.to(OrderConfirmationScreen(
                     selectedCartIDs: selectedCartIDs,
                     selectedCartListItemsInfo: selectedCartListItemsInfo,
                     totalAmount: totalAmount,
                     deliverySystem: orderNowController.deliverySys,
                     paymentSystem: orderNowController.paymentSys,
                     phoneNumber: phoneNumberController.text,
                     shipmentAddress: shipmentAddressController.text,
                     note: noteToSellerController.text,
                   ));
                 }
                 else
                 {
                   Fluttertoast.showToast(msg: "Please Insert To The Blank Form!");
                 }
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
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Spacer(),

                      const Text(
                        "Pay Amount Now",
                        style: TextStyle(
                          color: Colors.white,
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

  displaySelectedItemsFromUserCart()
  {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index)
      {
        Map<String, dynamic> eachSelectedItem = selectedCartListItemsInfo![index];
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == selectedCartListItemsInfo!.length - 1 ? 16 : 8,
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
                    eachSelectedItem["image"],
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
                          eachSelectedItem["name"],
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
                          eachSelectedItem["varian"].replaceAll("[", "").replaceAll("]", "") + "\n" +
                          eachSelectedItem["size"].replaceAll("[", "").replaceAll("]", ""),
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
                          "Rp" + eachSelectedItem["totalAmount"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          eachSelectedItem["price"].toString() + " x " + eachSelectedItem["quantity"].toString()
                          + " = " + eachSelectedItem["totalAmount"].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),

                      ],
                    ),
                  ),
              ),

              //------------ DISPLAY THE QUANTITY ---------------------------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q: " + eachSelectedItem["quantity"].toString(),
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
