import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/controllers/cart_list_controller.dart';
import 'package:skincare_app/users/item/item_details_screen.dart';
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
          Fluttertoast.showToast(msg: "No Items Found");
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
          double eachItemTotalAmount = (itemInCart.price!) * (double.parse(itemInCart.quantity.toString()));

          cartListController.setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }
  }
  //---------------- END OF COUNTING TOTAL AMOUNT OF ITEMS -------------------//

  //--------- DELETE USER ITEMS CART FROM CART ------------------------------//
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
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Deleted Succesfully");
      }
    }
    catch (errorMsg)
    {
      print("Error" + errorMsg.toString());

      Fluttertoast.showToast(msg: "Error" + errorMsg.toString());
    }
  }
  //============== ENDS OF DELETING USER ITEMS FROM CART METHOD ==============//

//---------------------- UPDATE QUANTITY FROM USER CART ----------------------//
  updateQuantityInUserCart(int cartID, int newQuantity) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(Api.updateItemInCartList),
          body:
          {
            "cart_id": cartID.toString(),
            "quantity": newQuantity.toString(),
          }
      );
      if(res.statusCode == 200)
      {
        var responseBodyOfUpdateCartQuantity = jsonDecode(res.body);

        if(responseBodyOfUpdateCartQuantity["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch (errorMsg)
    {
      print("Error" + errorMsg.toString());

      Fluttertoast.showToast(msg: "Error, status code is not 200");
    }
  }
  //======= ENDS OF UPDATE QUANTITY FROM USER CART ===========================//

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
        backgroundColor: Colors.pinkAccent[100],
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
                  // cartListController.addSelectedItem(eachItem.cart_id!);
                  // ^^^^^^^^^^^^^^^^^ SYNTAX YG BENER ^^^^^^^^^^^^^^^^^^//
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
                  : Colors.white,
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
                        backgroundColor: Colors.white,
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
                      cartListController.selectedItemList.forEach((SelectedItemUserCartID)
                      {
                        deleteSelectedItemFromUserCartList(SelectedItemUserCartID);
                      });
                    }
                    calculateTotalAmount();
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 26,
                    color: Colors.white,
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
                //----------- CHECK BOX --------------------------------------//
                GetBuilder(
                  init: CartListController(),
                  builder: (c){
                    return IconButton(
                      onPressed: ()
                      {
                        if(cartListController.selectedItemList.contains(cartModel.cart_id))
                        {
                          cartListController.deleteSelectedItem(cartModel.cart_id!);
                          calculateTotalAmount();
                        }
                        else
                        {
                          cartListController.addSelectedItem(cartModel.cart_id!);
                          // cartListController.addSelectedItem(cartModel.item_id!);
                          calculateTotalAmount();
                        }

                        calculateTotalAmount();
                      },
                      icon: Icon(
                        cartListController.selectedItemList.contains(cartModel.cart_id) ?
                        Icons.check_box : Icons.check_box_outline_blank,
                        color: cartListController.isSelectedAll ? Colors.pinkAccent :
                        Colors.pinkAccent,
                      ),
                    );
                  },
                ),


                Expanded(
                  child: GestureDetector(
                    onTap: ()
                    {
                      Get.to(ItemDetailsScreen(itemInfo: skincareModel));
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
                                          "Varian: ${cartModel.varian!.replaceAll('[', '').replaceAll(']', '')}" + "\n" + "Size: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                          maxLines: 2,
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
                                            fontSize: 16,
                                            color: Colors.pinkAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  //---- DIPLAY (+) & (-) ICON BUTTON --------//
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //----- ICONS (-) ----------//
                                      IconButton(
                                        onPressed: ()
                                        {
                                          if(cartModel.quantity! - 1 >= 1)
                                          {
                                            updateQuantityInUserCart(
                                              cartModel.cart_id!,
                                              cartModel.quantity! - 1,
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),

                                      const SizedBox(width: 8,),

                                      Text(
                                        cartModel.quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(width: 8,),

                                      //------ ICONS (+) ---------//
                                      IconButton(
                                        onPressed: ()
                                        {
                                          updateQuantityInUserCart(
                                            cartModel.cart_id!,
                                            cartModel.quantity! + 1,
                                          );
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
                              width: 140,
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
                  "Total Price:",
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
                      ? Colors.white
                      : Colors.white,
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
                          color: Colors.pinkAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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