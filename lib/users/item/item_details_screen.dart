import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:skincare_app/users/controllers/item_details_controller.dart';
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
  final itemDetailsController = Get.put(ItemDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        color: Colors.white54,
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
                color: Colors.pink,
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

          ],
        ),
      ),
    );
  }
}
