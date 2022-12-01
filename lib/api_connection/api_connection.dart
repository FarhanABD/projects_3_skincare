class Api{
  static const hostConnect = "http://192.168.8.207/api_skincare";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostUploadItem = "$hostConnect/items";
  static const hostItems = "$hostConnect/skincare";


  // Signup User
  static const signup = "$hostConnectUser/signup.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static  const login = "$hostConnectUser/login.php";

  // LOGIN ADMIN
  static const adminlogin = "$hostConnectAdmin/login.php";

  // UPLOAD NEW ITEMS TO DATABASE
  static const uploadNewItem = "$hostUploadItem/upload.php";

  // API ITEMS FROM DATABASE
  static const getTrendingMostPopularItem = "$hostUploadItem/trending.php";



}