import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuth  {

  signInWithGoogle() async{



    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();//begin sign in process

    final GoogleSignInAuthentication gauth = await guser!.authentication;//take auth details from sign process

    final credential = GoogleAuthProvider.credential(

        accessToken: gauth.accessToken,
        idToken: gauth.idToken

    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

}
