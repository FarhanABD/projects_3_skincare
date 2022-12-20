import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/admin/admin_get_all_orders.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/authentication/login_screen.dart';

class AdminUploadItemsScreen extends StatefulWidget {
  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();

  //--------------- Controller TextFormField---------------------------------//
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var varianController = TextEditingController();
  var sizeController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";

  //--------- Default Screen Method------------------------------------------//
  captureImageWithPhone()async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(()=>pickedImageXFile);
  }
  pickImageFromPhone()async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(()=>pickedImageXFile);
  }
  showDialogBoxForImagePickingAndCapturing(){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Item Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,

              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: (){
                  //------- MEMANGGIL FUNGSI AMBIL GAMBAR DARI KAMERA----------//
                  captureImageWithPhone();

                },
                child: const Text(
                  "Capture With camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                  //------ MEMANGGIL FUNGSI AMBIL GAMBAR DARI GALLERY---------//
                  pickImageFromPhone();

                },
                child: const Text(
                  "Select Image From Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                  Get.back();

                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        }
    );
  }
  //---------- Default ends -------------------------------------------------//
  Widget defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        flexibleSpace: Container(
          decoration: const BoxDecoration(

          ),
        ),
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: ()
          {
            Get.to(AdminGetAllOrdersScreen());
          },
          child: const Text(
              "New Orders",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: ()
              {
                Get.to(LoginScreen());
              },
            icon: const Icon(
              Icons.logout,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.pink,
                size: 200,
              ),

              //Button
              Material(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: (){
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30) ,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Add New Items",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //-------- Upload ItemForm Screen methods ----------------------------------//
  uploadItemImage() async
  {
    var requestImgurApi = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.imgur.com/3/image")
    );
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    // requestImgurApi.headers['Authorization'] = "Client-ID " + "97f174c40b9a6e4";
    requestImgurApi.headers['Authorization'] = "Client-ID " + "ec8c74ecd4356a8";


    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );
    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    //-------- Hasil Request Image Dari Imgur API----------------------------//
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    print("Result :: ");
    print(resultFromImgurApi);


    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();



    saveItemInfoToDatabase();

  }

  saveItemInfoToDatabase() async
  {
    //--------------- LIST UNTUK MEMBERI PILIHAN OPSI-------------------------//
    List<String> tagsList = tagsController.text.split(',');
    List<String> varianList = varianController.text.split(',');
    List<String> sizeList = sizeController.text.split(',');

    try
    {
      var response = await http.post(
        Uri.parse(Api.uploadNewItem),
        body: {
          'item_id':'1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'varians': varianList.toString(),
          'sizes': sizeList.toString(),
          'description': descriptionController.text.trim().toString(),
          'image': imageLink.toString(),
        },
      );

      if(response.statusCode == 200){

        var ResBodyOfUploadItem = jsonDecode(response.body);
        if(ResBodyOfUploadItem['success'] == true)
        {
          Fluttertoast.showToast(msg: "New Item Uploaded Succesfully :)");


          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            varianController.clear();
            sizeController.clear();
            descriptionController.clear();
          });
          Get.to(AdminUploadItemsScreen());
        }
        else{
          Fluttertoast.showToast(msg: "Unsuccesfull To Upload New Items :(");
        }
      }
      else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch (errorMsg)
    {
      print("Error: " + errorMsg.toString());

    }
  }


  Widget uploadItemsFormScreen(){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.pinkAccent
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Upload Form",
          style: TextStyle(
              color: Colors.black
          ),

        ),
        centerTitle: true,
        leading: IconButton(
          //------------- FUNGSI TOMBOL "X" DI FORM UPLOAD BARANG ------------//
          onPressed: (){
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              varianController.clear();
              sizeController.clear();
              descriptionController.clear();
            });
            Get.to(AdminUploadItemsScreen());
          },
          icon: const Icon(
              Icons.clear
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Fluttertoast.showToast(msg: "Uploading Now....");

              uploadItemImage();
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          //------ Image--------//
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(
                    File(pickedImageXFile!.path),
                  ),
                  fit: BoxFit.cover
              ),
            ),
          ),

          //------- Upload Items Form-----//
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [

                    // email-password-login btn
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //Item Name Textfield
                          TextFormField(
                            controller: nameController,
                            validator: (val) => val == "" ? "Please Insert Item Name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black26,
                              ),
                              hintText: "Items Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item Ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) => val == "" ? "Please Insert Item Ratings" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black26,
                              ),
                              hintText: "Item Ratings",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item Tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) => val == "" ? "Please Insert Item Tags" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black26,
                              ),
                              hintText: "Item Tags",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item Price
                          TextFormField(
                            controller: priceController,
                            validator: (val) => val == "" ? "Please Insert Item Price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black26,
                              ),
                              hintText: "Item Price",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item Varian
                          TextFormField(
                            controller: varianController,
                            validator: (val) => val == "" ? "Please Insert Item Varian" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black26,
                              ),
                              hintText: "Item Varian",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item size
                          TextFormField(
                            controller: sizeController,
                            validator: (val) => val == "" ? "Please Insert Item Size" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.balance_outlined,
                                color: Colors.black26,
                              ),
                              hintText: "Item Size Netto",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),

                          //Item Description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == "" ? "Please Insert Item Description" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black26,
                              ),
                              hintText: "Item Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18,),


                          // Button Upload
                          Material(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: (){
                                if (formKey.currentState!.validate())
                                {
                                  Fluttertoast.showToast(msg: "Uploading Now..");
                                  uploadItemImage();

                                }

                              },
                              borderRadius: BorderRadius.circular(30) ,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Upload Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,

                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16,),

                    // Admin Login Btn

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    //-------- TERNARY OPERATIONS (?) = IF & (:) = ELSE ----------------------//
    return pickedImageXFile == null ? defaultScreen() : uploadItemsFormScreen();
  }
}
