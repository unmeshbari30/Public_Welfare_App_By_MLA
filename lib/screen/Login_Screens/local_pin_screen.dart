// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test_app/controllers/authentication_controller.dart';
// import 'package:test_app/helpers/enum.dart';
// import 'package:test_app/screen/home_screen.dart';

// class LocalPinScreen extends ConsumerStatefulWidget {
//   const LocalPinScreen({super.key});

//   @override
//   ConsumerState<LocalPinScreen> createState() => _LocalPinScreenState();
// }

// class _LocalPinScreenState extends ConsumerState<LocalPinScreen> {
//   String _pin = "";
//   bool isFirstLogin = true;
//   int exitCounter = 1;

//   @override
//   void initState() {
//     super.initState(); // Always call super first

//     _checkFirstLogin();
//   }

//   Future<void> _checkFirstLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//     isFirstLogin =prefs.getBool(PrefrencesKeyEnum.isfirstLocalPin.key) ?? true;
//     });
//   }

//   Future<void> _savePin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (_pin.length == 4 && isFirstLogin) {
//       prefs.setString(PrefrencesKeyEnum.localPin.key, _pin);
//       prefs.setBool(PrefrencesKeyEnum.isfirstLocalPin.key, false);

//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()));

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: const Text("PIN Set Successfully"),
//         backgroundColor: Colors.green.shade600,
//         duration: const Duration(seconds: 2),
//         behavior:SnackBarBehavior.fixed,
//         )
//       );
//       //await prefs.setString(SharedPreferencesEnum.loginPin.key, _pin);
//     }
//     if (isFirstLogin == false) {
//       bool currentPin =
//           prefs.getString(PrefrencesKeyEnum.localPin.key) == _pin;
//       if (currentPin) {
//         setState(() {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()));
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: const Text("Entered Correct PIN"),
//         backgroundColor: Colors.green.shade600,
//         duration: const Duration(seconds: 3),
//         behavior:SnackBarBehavior.fixed,
//         ));
//       } else {
//         setState(() {
//           _pin = _pin.substring(0, _pin.length - 4);
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text(
//               "Entered Wrong PIN",
//               style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.red.shade900,
//             duration: const Duration(seconds: 3),
//             behavior:
//                 SnackBarBehavior.fixed, // Optional: Makes the snackbar float
//           ),
//         );
//       }
//     }
//   }

//   void _onKeyPress(String value) {
//     if (_pin.length < 4) {
//       setState(() {
//         _pin += value;
//       });
//       if (_pin.length == 4) {
//         _savePin();
//       }
//     }
//   }

//   void _onDelete() {
//     if (_pin.isNotEmpty) {
//       setState(() {
//         _pin = _pin.substring(0, _pin.length - 1);
//       });
//     }
//   }

//   Widget _buildNumberButton(String number) {
//     return GestureDetector(
//       onTap: () => _onKeyPress(number),
//       child: Container(
//         width: 70,
//         height: 70,
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Color(0xFF757575),
//         ),
//         child: Text(
//           number,
//           style: const TextStyle(
//               fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   // Widget loginMessage() {
//   //   return isFirstLogin
//   //       ? const Text("Enter New PIN", style: TextStyle(color: Colors.white))
//   //       : const Text("Enter PIN", style: TextStyle(color: Colors.white));
//   // }


//   Widget getScaffold(AuthenticationState state){
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle:true,
//         title: Text(
//         isFirstLogin ? "Enter New PIN" : "Enter PIN",
//         style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
//           ),  

//         automaticallyImplyLeading: false,
//       ),
//       backgroundColor: Colors.black,
//       body: PopScope(
//         canPop: false,
//         onPopInvokedWithResult:(didPop, result) {
//           if(exitCounter == 2){
//             exit(0);
//           }
//           exitCounter++;

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Press back again to exit", style: TextStyle(color: Colors.black),),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.amber,
              
//               )


//           );
          
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _pin.padRight(4, '-'),
//               style: const TextStyle(
//                   fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white), //color: Colors.black
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 15,
//                   crossAxisSpacing: 15,
//                 ),
//                 itemCount: 9,
//                 itemBuilder: (context, index) {
//                   return _buildNumberButton('${index + 1}');
//                 },
//               ),
//             ),
//             // const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildNumberButton('0'),
//                   const SizedBox(width: 20),
//                   IconButton(
//                     onPressed: _onDelete,
//                     icon: const Icon(Icons.backspace, size: 35),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
    
//     );

//   }


//   @override
//   Widget build(BuildContext context) {
//     var asyncAuthenticationState = ref.watch(authenticationControllerProvider);
//     return asyncAuthenticationState.when(
//       data: (authenticationState) {
//         return getScaffold(authenticationState);
        
//       }, 
      
//       error: (error, stackTrace) {
//         return getScaffold(AuthenticationState());
//       },
      
//       loading: () => CircularProgressIndicator(),);
//   }
// }