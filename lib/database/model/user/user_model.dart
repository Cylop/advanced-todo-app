import 'package:advanced_todo/database/model/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends BaseModel{
   final String uid;
   final String firstName;
   final String lastName;
   final String email;
   final String initials;
   final String photoURL;
   final String bio;
   final Timestamp joinedAt;

  UserModel({this.uid, this.firstName, this.lastName, this.email, this.initials, this.photoURL, this.bio, this.joinedAt});

  static UserModel userModelFromFirebase(User user) {
    List<String> nameSplit = user.displayName.split(" ");
    String firstName, lastName;
    if(nameSplit.length > 0) {
      firstName = nameSplit.isNotEmpty ? nameSplit[0] : '';
    }
    if(nameSplit.length > 1) {
      lastName = nameSplit.isNotEmpty ? nameSplit[1] : '';
    }
    String initials = firstName.split("")[0].toUpperCase() + lastName.split("")[0].toUpperCase();
    return UserModel(
      uid: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: user.email,
      initials: initials,
      photoURL: user.photoURL,
      joinedAt: Timestamp.now(),
    );
  }

  factory UserModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return UserModel(
      uid: snapshot.id  ?? 'Unknown',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      initials: data['initials'] ?? '',
      photoURL: data['photoURL'] ?? '',
      bio: data['bio'] ?? '',
      joinedAt: data['joinedAt'] ?? Timestamp.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'initials': this.initials,
      'photoURL': this.photoURL,
      'bio': this.bio,
      'joinedAt': this.joinedAt
    };
  }
}