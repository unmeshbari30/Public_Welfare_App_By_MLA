enum PrefrencesKeyEnum{

  userName("user_name"),  //string
  isLoggedin("isLogin"),    // bool
  localPin("loginPin"), //string 
  isfirstLocalPin("firstLoginPin"), // bool
  acessToken("accessToken"),
  rememberMe("rememberMe"),  // bool
  accessToken("accessToken"), //string
  refreshToken("refreshToken")
  ;

  final String key;
  const PrefrencesKeyEnum(this.key,);
}
