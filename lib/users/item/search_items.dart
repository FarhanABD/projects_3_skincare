import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/cart/cart_list_screen.dart';
import 'package:skincare_app/users/item/item_details_screen.dart';
import 'package:skincare_app/users/model/skincare.dart';
import 'package:http/http.dart' as http;

class SearchItems extends StatefulWidget {

  final String? typedKeyWords;

  SearchItems({this.typedKeyWords,});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  TextEditingController searchController = TextEditingController();

  Future<List<Skincare>> readSearchRecordsFound() async
  {
    List<Skincare> skincareSearchList = [];

    if(searchController.text != "")
    {
      try
      {
        var res = await http.post(
            Uri.parse(Api.searchItems),
            body:
            {
              "typedKeyWords": searchController.text,
            }
        );

        if (res.statusCode == 200)
        {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true)
          {
            (responseBodyOfSearchItems['itemsFoundData'] as List).forEach((eachItemData)
            {
              skincareSearchList.add(Skincare.fromJson(eachItemData));
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

    }

    return skincareSearchList;
  }

  @override
  void initState() {
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: ()
          {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget()
  {
    // TextEditingController searchController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              setState(() {

              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,

            ),
          ),
          hintText: "Search Item Here..",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: (){
             searchController.clear();

             setState(() {

             });
            },
            icon: const Icon(
              Icons.close,
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

  searchItemDesignWidget(context)
  {
    return FutureBuilder
      (
        future: readSearchRecordsFound(),
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
              // physics: NeverScrollableScrollPhysics(),
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
