import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skincare_app/users/item/item_details_screen.dart';
import 'package:skincare_app/users/model/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:get/get.dart';
import 'package:skincare_app/users/model/skincare.dart';
import 'package:skincare_app/users/userPreferences/current_user.dart';

class FavoritesFragmentScreen extends StatelessWidget
{
  final currentOnlineUser = Get.put(CurrentUser());


  Future<List<Favorite>> getCurrentUserFavoriteList() async
  {
    List<Favorite> favoriteListOfCurrentUser = [];
    try
    {
      var res = await http.post(
          Uri.parse(Api.readFavorite),
          body:
          {
            "user_id": currentOnlineUser.user.user_id.toString(),
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if (responseBodyOfCurrentUserFavoriteListItems['success'] == true)
        {
          (responseBodyOfCurrentUserFavoriteListItems['currentUserFavoriteData'] as List).forEach((eachCurrentUserFavoriteItemData)
          {
            favoriteListOfCurrentUser.add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
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

    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "My Wishlist",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Ganteng Doang jemput cewe depan gang :)",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 24),

          //---------- DISPLAY USER WISHLIST ---------------------------------//
          favoriteLitItemDesignWidget(context),
        ],
      ),
    );
  }

  favoriteLitItemDesignWidget(context)
  {
    return FutureBuilder
      (
        future: getCurrentUserFavoriteList(),
        builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null)
          {
            return const Center(
                child: Text(
                  "No Favorite Items Found",
                )
            );
          }
          if(dataSnapShot.data!.length > 0)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                Skincare clickedskincareItem = Skincare(
                  item_id: eachFavoriteItemRecord.item_id,
                  varians: eachFavoriteItemRecord.varians,
                  image: eachFavoriteItemRecord.image,
                  name: eachFavoriteItemRecord.name,
                  price: eachFavoriteItemRecord.price,
                  rating: eachFavoriteItemRecord.rating,
                  sizes: eachFavoriteItemRecord.sizes,
                  description: eachFavoriteItemRecord.description,
                  tags: eachFavoriteItemRecord.tags,
                );

                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailsScreen(itemInfo: clickedskincareItem));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow:
                      const [
                        BoxShadow(
                          offset: Offset(0,0),
                          blurRadius: 6,
                          // color: Colors.pinkAccent,
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        //--------- DISPLAY NAME, PRICE AND TAGS OF ITEMS---//
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //----------------- NAME OF ITEMS ----------//
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachFavoriteItemRecord.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),

                                    //----------- PRICE OF ITEMS------------//
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Text(
                                        "Rp" + eachFavoriteItemRecord.price.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16,),

                                //------------ TAGS OF ITEMS ---------------//
                                Text(
                                  "Tags: \n"+ eachFavoriteItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //------ DISPLAY ALL ITEM IMAGES -------------------//
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)
                          ),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/placeholder.png"),
                            image: NetworkImage(
                              eachFavoriteItemRecord.image!,
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
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text("Empty, No Data"),
            );
          }
        }
    );
  }
}
