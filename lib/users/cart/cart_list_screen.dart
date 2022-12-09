import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/controllers/cart_list_controller.dart';
import 'package:skincare_app/users/model/cart.dart';
import 'package:skincare_app/users/model/skincare.dart';
import 'package:skincare_app/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen>
{
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfcurrentUser = [];
    try
    {
      var res = await http.post(
          Uri.parse(Api.getCartList),
          body:
          {
            "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

        if (responseBodyOfGetCurrentUserCartItems['success'] == true)
        {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List).forEach((eachCurrentUserCartItemData)
          {
            cartListOfcurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Error occured in querry");
        }

        cartListController.setList(cartListOfcurrentUser);
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
    calculateTotalAmount();
  }

  //---------------- FUNGSI MENGHITUNG TOTAL AMOUNT OF ITEMS------------------//
  calculateTotalAmount()
  {
    cartListController.setTotal(0);

    if(cartListController.selectedItemList.length > 0)
    {
      cartListController.cartList.forEach((itemInCart)
      {
        if(cartListController.selectedItemList.contains(itemInCart.item_id))
        {
          double eachItemtotalAmount = (itemInCart.price!) * (double.parse(itemInCart.quantity.toString()));

          cartListController.setTotal(cartListController.total + eachItemtotalAmount);
        }
      });
    }
  }
  //---------------- END OF COUNTING TOTAL AMOUNT OF ITEMS -------------------//

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[500],
        title: const Text(
          "My Cart"
        ),
        actions: [
          Obx(() =>
          //--------- TO SELECT ALL ITEMS -----------------------------------//
              IconButton(
                onPressed: ()
                {
                  cartListController.setIsSelectedAllItems();
                  cartListController.clearAllSelectedItems();

                  if(cartListController.isSelectedAll)
                    {
                      cartListController.cartList.forEach((eachItem)
                      {
                        cartListController.addSelectedItem(eachItem.item_id!);
                      });
                    }

                  calculateTotalAmount();
                },
                icon: Icon(
                  cartListController.isSelectedAll
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: cartListController.isSelectedAll
                      ? Colors.pinkAccent
                      : Colors.grey,
                ),
              ),
          ),

          //------- TO DELETE ALL SELECTED ITEMS -----------------------------//
          GetBuilder(
            init: CartListController(),
            builder: (c)
            {
              if(cartListController.selectedItemList.length > 0)
              {
                return IconButton(
                  onPressed: () async{
                    var responseFromDialogBox = await Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.grey,
                        title: const Text("Delete"),
                        content: const Text("Do you want to delete the item ?"),
                        actions: [
                          TextButton(
                            onPressed: ()
                            {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: ()
                            {
                              Get.back(result: "DeletingItems");
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if(responseFromDialogBox == "DeletingItems")
                    {
                      cartListController.selectedItemList.forEach((eachSelectedItem)
                      {

                      });
                    }
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 26,
                    color: Colors.pinkAccent,
                  ),
                );
              }
              else
              {
                return Container();
              }
            },
          ),

        ],
      ),
      body: Obx( ()=>
          cartListController.cartList.length > 0
              ? ListView.builder(
                  itemCount: cartListController.cartList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index)
                  {
                    Cart cartModel = cartListController.cartList[index];

                    Skincare skincareModel = Skincare(
                      item_id: cartModel.item_id,
                      varians: cartModel.varians,
                      image: cartModel.image,
                      name: cartModel.name,
                      price: cartModel.price,
                      rating: cartModel.rating,
                      sizes: cartModel.sizes,
                      description: cartModel.description,
                      tags: cartModel.tags,
                    );

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          GetBuilder(
                            init: CartListController(),
                            builder: (c){
                              return IconButton(
                                  onPressed: ()
                                  {
                                    cartListController.addSelectedItem(cartModel.item_id!);

                                    calculateTotalAmount();
                                  },
                                icon: Icon(
                                  cartListController.selectedItemList.contains(cartModel.item_id) ?
                                  Icons.check_box : Icons.check_box_outline_blank,
                                  color: cartListController.isSelectedAll ? Colors.pinkAccent :
                                  Colors.grey,
                                ),
                              );
                            },
                          ),


                          Expanded(
                            child: GestureDetector(
                              onTap: ()
                              {

                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                  0,
                                  index == 0 ? 16 : 8,
                                  16,
                                  index == cartListController.cartList.length - 1 ? 16 : 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: Colors.pinkAccent,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //-------- DISPLAY NAME --------//
                                              Text(
                                                skincareModel.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.pinkAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(height: 20),

                                              //--- DISPLAY VARIAN & SIZE ----//
                                              Row(
                                                children: [
                                                  //---- varian & size -------//
                                                  Expanded(
                                                      child: Text(
                                                      "Varian : ${cartModel.varian!.replaceAll('[', '').replaceAll(']', '')}" + "\n" + "Size : ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.pinkAccent,
                                                      ),
                                                      ),
                                                  ),

                                                  Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 12,
                                                        right: 12.0
                                                      ),
                                                    child: Text(
                                                      "Rp" + skincareModel.price.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.pinkAccent,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                              const SizedBox(height: 20),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  //----- ICONS (-) ----------//
                                                  IconButton(
                                                      onPressed: ()
                                                      {

                                                      },
                                                    icon: const Icon(
                                                      Icons.remove_circle_outline,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 10,),

                                                  Text(
                                                    cartModel.quantity.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.pinkAccent,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 10,),

                                                  //------ ICONS (+) ---------//
                                                  IconButton(
                                                    onPressed: ()
                                                    {

                                                    },
                                                    icon: const Icon(
                                                        Icons.add_circle_outline,
                                                        color: Colors.black,
                                                        size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),),

                                    //------ DISPLAY ITEM IMAGE -------------//
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(22),
                                        bottomRight: Radius.circular(22),

                                      ),
                                      child: FadeInImage(
                                        height: 185,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage("images/placeholder.png"),
                                        image: NetworkImage(
                                          cartModel.image!,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("Cart Is Empty"),),
        ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c)
        {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                //------ TOTAL AMOUNT --------------------------------------//
                const Text(
                  "Total Amount:",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4),

                Obx(() =>
                    Text(
                      "Rp " + cartListController.total.toStringAsFixed(2),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),

                const Spacer(),
                //------------ BUTTON ORDER NOW ------------------------------//
                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Colors.pinkAccent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: ()
                    {

                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}