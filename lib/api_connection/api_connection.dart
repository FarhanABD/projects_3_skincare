class Api{
  static const hostConnect = "http://192.168.24.38/api_skincare";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostUploadItem = "$hostConnect/items";
  static const hostItems = "$hostConnect/skincare";
  static const hostCart = "$hostConnect/cart";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";

  // Signup User
  static const signup = "$hostConnectUser/signup.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static  const login = "$hostConnectUser/login.php";

  // LOGIN ADMIN
  static const adminlogin = "$hostConnectAdmin/login.php";

  // UPLOAD NEW ITEMS TO DATABASE
  static const uploadNewItem = "$hostUploadItem/upload.php";

  // API TRENDING ITEMS FROM DATABASE
  static const getTrendingMostPopularItem = "$hostItems/trending.php";

  // API ALL COLLECTIONS ITEMS FROM DATABASE
  static const getAllItems = "$hostItems/all.php";

  // API CART ITEMS FROM DATABASE
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteSelectedItemsFromCartList = "$hostCart/delete.php";
  static const updateItemInCartList = "$hostCart/update.php";

  // API FOR SAVING USER WISHLIST
  static const validateFavorite = "$hostFavorite/validate_favorite.php";
  static const addFavorite = "$hostFavorite/add.php";
  static const deleteFavorite = "$hostFavorite/delete.php";
  static const readFavorite = "$hostFavorite/read.php";

  // API TO SEARCH ITEMS IN SEARCH BAR
  static const searchItems = "$hostUploadItem/search.php";

  // API ORDER
  static const addOrder = "$hostOrder/add.php";
}