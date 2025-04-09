abstract class Validators{

  static  validateEmptyField(String? value){
    if(value == ""){
      return "Can't be Empty";
    }else{
      return null;
    }

  }
}