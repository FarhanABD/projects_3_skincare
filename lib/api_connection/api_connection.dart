class Api{
  static const hostConnect = "http://192.168.24.43/api_skincare";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostUploadItem = "$hostConnect/items";
  static const hostItems = "$hostConnect/skincare";
  static const hostCart = "$hostConnect/cart";


  // Signup User
  static const signup = "$hostConnectUser/signup.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static  const login = "$hostConnectUser/login.php";

  // LOGIN ADMIN
  static const adminlogin = "$hostConnectAdmin/login.php";

  // UPLOAD NEW ITEMS TO DATABASE
  static const uploadNewItem = "$hostUploadItem/upload.php";

  // API ITEMS FROM DATABASE
  static const getTrendingMostPopularItem = "$hostItems/trending.php";

  // API ITEMS FROM DATABASE
  static const getAllItems = "$hostItems/all.php";

  // API CART ITEMS FROM DATABASE
  static const addToCart = "$hostCart/add.php";



}