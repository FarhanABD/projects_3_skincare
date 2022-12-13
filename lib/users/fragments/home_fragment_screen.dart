import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/cart/cart_list_screen.dart';
import 'package:skincare_app/users/item/item_details_screen.dart';
import 'package:skincare_app/users/item/search_items.dart';
import 'package:skincare_app/users/model/skincare.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class HomeFragmentScreen extends StatelessWidget
{
  TextEditingController searchController = TextEditingController();
  //------------ MENAMPILKAN ITEMS-ITEMS TRENDING DI HOMESCREEN---------------//
  Future<List<Skincare>> getTrendingSkincareItems() async
  {
    List<Skincare> trendingSkincareItemsList = [];
    try
    {
      var res = await http.post(
          Uri.parse(Api.getTrendingMostPopularItem)
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        if(responseBodyOfTrending["success"] == true)
        {
          (responseBodyOfTrending["skincareItemsData"] as List).forEach((eachRecord)
          {
            trendingSkincareItemsList.add(Skincare.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code Is Not 200");
      }
    }
    catch (errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
    return trendingSkincareItemsList;

  }

  //-------MENAMPILKAN SEMUA KOLEKSI ITEM UNTUK NEW COLLECTION SECTION -------//
  Future<List<Skincare>> getAllSkincareItems() async
  {
    List<Skincare> allSkincareItemsList = [];
    try
    {
      var res = await http.post(
          Uri.parse(Api.getAllItems)
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfAllSkincare = jsonDecode(res.body);
        if(responseBodyOfAllSkincare["success"] == true)
        {
          (responseBodyOfAllSkincare["skincareItemsData"] as List).forEach((eachRecord)
          {
            allSkincareItemsList.add(Skincare.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code Is Not 200");
      }
    }
    catch (errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
    return allSkincareItemsList;

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          //---search bar widget---------------------------------------------//
          showSearchBarWidget(),

          const SizedBox(height: 26,),

          //--- Trending Items ----------------------------------------------//
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Popular",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          trendingMostPopularSkincareItemsWidget(context),

          const SizedBox(height: 24,),

          //--- All New Collections -----------------------------------------//
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "New Collections",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          allItemsWidget(context),
        ],
      ),
    );
  }
  Widget showSearchBarWidget()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,

            ),
          ),
          hintText: "Search Item Here..",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: (){
              Get.to(CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),

          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),



        ),
      ),

    );
  }

  Widget trendingMostPopularSkincareItemsWidget(context)
  {
    return FutureBuilder(
      future: getTrendingSkincareItems(),
      builder: (context, AsyncSnapshot<List<Skincare>> dataSnapShot)
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
                "No Trending Items Found",
              )
          );
        }
        if(dataSnapShot.data!.length > 0)
        {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)
              {
                Skincare eachSkincareItemsData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailsScreen(itemInfo: eachSkincareItemsData));
                  },
                  //--------- UNTUK MENGATUR JARAK GAMBAR PRODUK WAKTU DI HOMESCREEN---//
                  child: Container
                    (
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      // color: Colors.pink,
                      boxShadow:
                      const [
                        BoxShadow(
                          offset: Offset(0,3),
                          blurRadius: 6,
                          color: Colors.pinkAccent,
                          // color: Colors.white
                        ),
                      ],
                    ),
                    child: Column(
                      children:
                      [
                        //-----ITEMS IMAGE
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/placeholder.png"),
                            image: NetworkImage(
                              eachSkincareItemsData.image!,
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // NAME AND PRICE OF ITEMS//
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachSkincareItemsData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Rp" + eachSkincareItemsData.price.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8,),

                              Row(
                                children: [
                                  //----RATING STAR & NUMBER -----------------//
                                  RatingBar.builder(
                                    initialRating: eachSkincareItemsData.rating!,
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
                                    "(" + eachSkincareItemsData.rating.toString() + ")",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        else
        {
          return const Center(
            child: Text("Empty, No Data"),
          );
        }
      },
    );
  }

  allItemsWidget(context)
  {
    return FutureBuilder
      (
      future: getAllSkincareItems(),
        builder: (context, AsyncSnapshot<List<Skincare>> dataSnapShot)
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
                  "No Trending Items Found",
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
                  Skincare eachSkincareItemsRecord = dataSnapShot.data![index];
                  return GestureDetector(
                    onTap: ()
                    {
                      Get.to(ItemDetailsScreen(itemInfo: eachSkincareItemsRecord));
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
                                          eachSkincareItemsRecord.name!,
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
                               "Rp" + eachSkincareItemsRecord.price.toString(),
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
                                    "Tags: \n"+ eachSkincareItemsRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
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
                                eachSkincareItemsRecord.image!,
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