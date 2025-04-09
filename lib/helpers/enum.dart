enum PrefrencesKeyEnum{

  userName("user_name"),  //string
  isLogin("isLogin"),    // bool
  localPin("loginPin"), //string 
  isfirstLocalPin("firstLoginPin"), // bool
  acessToken("accessToken"),
  rememberMe("rememberMe")  // bool
  ;

  final String key;
  const PrefrencesKeyEnum(this.key,);
}
