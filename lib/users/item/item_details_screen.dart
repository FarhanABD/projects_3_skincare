import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/controllers/item_details_controller.dart';
import 'package:skincare_app/users/model/skincare.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/users/userPreferences/current_user.dart';


class ItemDetailsScreen extends StatefulWidget
{
  final Skincare? itemInfo;
  ItemDetailsScreen({this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  final itemDetailsController = Get.put(ItemDetailsController());
  //------ MEMANGGIL ID USER YANG MEMASUKKAN PESANAN KE KERANJANG ------------//
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(Api.addToCart),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "varian": widget.itemInfo!.varians![itemDetailsController.varian],
          "size": widget.itemInfo!.sizes![itemDetailsController.size],
        },
      );
      if(res.statusCode == 200) //from flutter app the connection with api to server - success
          {
        var resBodyOfAddCart = jsonDecode(res.body);
        if(resBodyOfAddCart['success'] == true)
        {
          Fluttertoast.showToast(msg: "item saved to Cart Successfully.");
        }
        else
        {
          Fluttertoast.showToast(msg: "Error Occur. Item not saved to Cart and Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch (errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Stack(
        children: [
          //----------- DISPLAY DETAILS ITEM IMAGES--------------------------//
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/placeholder.png"),
            image: NetworkImage(
              widget.itemInfo!.image!,
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

          //---------- DISPLAY DETAILS ITEM INFORMATIONS ---------------------//
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
        ],
      ),
    );
  }

  itemInfoWidget(){
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -13),
            blurRadius: 6,
            color: Colors.pinkAccent,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 30,),

            //----------------- DISPLAY ITEMS NAME FROM DATABASE -------------//
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10,),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //---------- DSIPLAY ITEMS RATING + TAGS + PRICE -------------//
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //---RATING BAR + RATING NUMBER--//
                      Row(
                        children: [
                          //------------- DISPLAY RATING BAR ---------------//
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c)=> const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (updateRating){},
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "(" + widget.itemInfo!.rating.toString() + ")",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),

                      //---- RATING TAGS ------//
                      Text(
                        widget.itemInfo!
                            .tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 16,),

                      //---- RATING PRICE -----//
                      Text(
                        "Rp" + widget.itemInfo!.price.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //----- DISPLAY ITEMS COUNTER --------------------------------//
                Obx(
                      ()=> Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          //--- FUNGSI MENAMBAH QUANTITY PADA ITEM DETAILS ---//
                          itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                        },
                        icon: Icon(Icons.add_circle_outline,color: Colors.black,),
                      ),
                      Text(
                        itemDetailsController.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          //--- FUNGSI KURANGI QUANTITY PADA ITEM DETAILS ---//
                          if(itemDetailsController.quantity -1 >= 1)
                          {
                            itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1);
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Quantity Can't be 0");
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline,color: Colors.black,),
                      ),
                    ],
                  ),
                ),

              ],
            ),

            //SIZE
            const Text(
              "Size:",
              style:TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8,),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.sizes!.length, (index)  {
                return Obx(
                      ()=> GestureDetector(
                    onTap: ()
                    {
                      itemDetailsController.setSizeItem(index);
                    },
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: itemDetailsController.size == index ? Colors.pinkAccent : Colors.pinkAccent,

                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: itemDetailsController.size == index ?
                        Colors.pinkAccent.withOpacity(0.4) : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemInfo!.sizes![index].replaceAll("[", "").replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pinkAccent[700],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            //VARIAN
            const Text(
              "Varian:",
              style:TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8,),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.varians!.length, (index)  {
                return Obx(
                      ()=> GestureDetector(
                    onTap: ()
                    {
                      itemDetailsController.setVarianItem(index);
                    },
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: itemDetailsController.varian == index ? Colors.pinkAccent
                              : Colors.pinkAccent,

                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: itemDetailsController.varian == index ?
                        Colors.pinkAccent.withOpacity(0.4) : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemInfo!.varians![index].replaceAll("[", "").replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pinkAccent[700],
                        ),
                      ),
                    ),
                  ),
                );
              },
              ),
            ),

            const SizedBox(height: 20),

            // DESCRIPTION ITEMS
            const Text(
              "Description:",
              style:TextStyle(
                fontSize: 18,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.itemInfo!.description!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 30,),

            //ADD TO CART BUTTON
            Material(
              elevation: 4,
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: ()
                {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}