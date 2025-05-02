abstract class Validators{

  static  validateEmptyField(String? value){
    if(value == "" || value == null){
      return "Mandatory field*";
    }else{
      return null;
    }

  }


   static  validateMobileNumber(String? value){
    if((value?.length ?? 0) > 10){
      return "Incorrect Mobile Number...";
    }else{
      return null;
    }

  }

   static String? usernameOrEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9._]{3,}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!usernameRegex.hasMatch(value) && !emailRegex.hasMatch(value)) {
      return 'Enter a valid username or email';
    }

    return null;
  }
}