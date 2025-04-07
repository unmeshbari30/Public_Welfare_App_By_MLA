enum PrefrencesKeyEnum{

  userName("user_name"),  //string
  isLogin("isLogin"),    // bool
  localPin("loginPin"), //string 
  isfirstLocalPin("firstLoginPin"), // bool
  acessToken("accessToken");

  final String key;
  const PrefrencesKeyEnum(this.key,);
}
