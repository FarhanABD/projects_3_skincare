class Api{
  static const hostConnect = "http://192.168.8.207/api_skincare";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";


  // Signup User
  static const signup = "$hostConnectUser/signup.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static  const login = "$hostConnectUser/login.php";

  // LOGIN ADMIN
  static const adminlogin = "$hostConnectAdmin/login.php";


}