enum PrefrencesKeyEnum{

  userName("user_name"),  //string
  isLoggedin("isLogin"),    // bool
  localPin("loginPin"), //string 
  isfirstLocalPin("firstLoginPin"), // bool
  acessToken("accessToken"),
  rememberMe("rememberMe"),  // bool
  accessToken("accessToken"), //string
  refreshToken("refreshToken"),

  firstName("firstName"),
  lastName("LastName"),
  mobileNumber("mobileNumber"),
  taluka("taluka"),
  gender("gender"),
  age("age"),
  mailId("mailId"),
  bloodGroup("bloodGroup")
  ;

  final String key;
  const PrefrencesKeyEnum(this.key,);
}
