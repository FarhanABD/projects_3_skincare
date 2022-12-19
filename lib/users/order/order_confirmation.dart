import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/fragments/dashboard_fragments.dart';
import 'package:skincare_app/users/fragments/home_fragment_screen.dart';
import 'package:skincare_app/users/model/order.dart';
import 'package:skincare_app/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class OrderConfirmationScreen extends StatelessWidget
{
  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final String? deliverySystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;

  OrderConfirmationScreen({
    this.selectedCartIDs,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.deliverySystem,
    this.paymentSystem,
    this.phoneNumber,
    this.shipmentAddress,
    this.note,
  });

  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();

  CurrentUser currentUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage)
  {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String SelectedImageName)
  {
    _imageSelectedName.value = SelectedImageName;
  }

  chooseImageFromGallery() async
  {
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedImageXFile != null)
    {
     final bytesOfImage = await pickedImageXFile.readAsBytes();

     //------- FUNGSI UNTUK MEMANGGIL GAMBAR DAN PATH TRANSACTION SCREENSHOOT //
     setSelectedImage(bytesOfImage);
     setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }

  saveNewOrderInfo() async
  {
    String selectedItemsString =
    selectedCartListItemsInfo!.map((eachSelectedItem)=> jsonEncode(eachSelectedItem)).toList().join("||");

    Order order = Order(
      order_id: 1,
      user_id: currentUser.user.user_id,
      selectedItems: selectedItemsString,
      deliverySystem: deliverySystem,
      paymentSystem: paymentSystem,
      note: note,
      totalAmount: totalAmount,
      image: DateTime.now().millisecondsSinceEpoch.toString() + "-" + imageSelectedName,
      status: "Processed",
      dateTime: DateTime.now(),
      shipmentAddress: shipmentAddress,
      phoneNumber: phoneNumber,
    );
    
    try
        {
          var res = await http.post(
            Uri.parse(Api.addOrder),
            body: order.toJson(base64Encode(imageSelectedByte)),
          );

          if(res.statusCode == 200)
          {
           var responseBodyOfAddNewOrder = jsonDecode(res.body);
           if(responseBodyOfAddNewOrder["success"] == true)
           {
             //---------- DELETE SELECTED ITEMS FROM USER CART ---------------//
             selectedCartIDs!.forEach((eachSelectedItemCartID)
             {
               deleteSelectedItemFromUserCartList(eachSelectedItemCartID);
             });
           }
           else
           {
             Fluttertoast.showToast(msg: "You Have some error :(");
           }
          }
        }
        catch (errorMsg)
        {
          Fluttertoast.showToast(msg: "Error" + errorMsg.toString());
        }
  }

  deleteSelectedItemFromUserCartList(int cartID) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(Api.deleteSelectedItemsFromCartList),
          body:
          {
            "cart_id": cartID.toString(),
          }
      );
      if(res.statusCode == 200)
      {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if(responseBodyFromDeleteCart["success"] == true)
        {
          Fluttertoast.showToast(msg: "New Order Successfully Added");
          Get.to(DashboardOfFragments());
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error Occured");
      }
    }
    catch (errorMsg)
    {
      print("Error" + errorMsg.toString());

      Fluttertoast.showToast(msg: "Error" + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //---- DISPLAY IMAGE ICONS ---------------//
            Image.asset(
              "images/payment.png",
              width: 150,
            ),

            const SizedBox(height: 4),
            //-------------------- TITLE -------------------------------------//
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please Insert Payment Screenhot",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            //-------------------- BUTTON ADD IMAGE --------------------------//
            Material(
              elevation: 8,
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {
                  chooseImageFromGallery();
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16,),

            //-------------- DISPLAY SELECTED IMAGE FROM USER ----------------//
            Obx(()=> ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
              child: imageSelectedByte.length > 0
                  ? Image.memory(imageSelectedByte, fit: BoxFit.contain,)
                  : const Placeholder(color: Colors.pinkAccent,),
            )),

            const SizedBox(height: 16),
            //-------------- CONFIRM AND PROCEED BUTTON ----------------------//
            Obx(() => Material(
              elevation: 8,
              color: imageSelectedByte.length > 0
                  ? Colors.pinkAccent
                  : Colors.grey,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {
                  if(imageSelectedByte.length > 0 )
                  {
                    //----------------- SAVE ORDER INFORMATION ---------------//
                    saveNewOrderInfo();
                  }
                  else
                  {
                    Fluttertoast.showToast(msg: "Please Insert The Transaction Screenshot");
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  child: Text(
                    "Confirmed & Proceed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
