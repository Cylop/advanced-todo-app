import 'package:advanced_todo/database/abstract_database.dart';
import 'package:advanced_todo/database/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabaseService extends AbstractDatabase {
  static const String USER_COLLECTION = 'users';

  static UserModel _currentUser;

  UserDatabaseService(User user) : super(user);

  Future<bool> doesUserExist({String uid}) async {
    if (uid == null) {
      uid = FirebaseAuth.instance.currentUser.uid;
    }
    try {
      var docRef =
          await this.getDatabase.collection(USER_COLLECTION).doc(uid).get();
      return docRef.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> getOrCreateUser() async {
    if(_currentUser != null) {
      return Future.value(_currentUser);
    }
    bool exists = await this.doesUserExist();
    if(!exists) {
        UserModel model = await this.createUser();
        _currentUser = model;
        return Future.value(model);
    }

    UserModel model = await this._getUserById(FirebaseAuth.instance.currentUser.uid);
    _currentUser = model;
    return Future.value(model);
  }

  Future<UserModel> _getUserById(String uid) async {
    DocumentSnapshot snapshot = await this.getDatabase.collection(USER_COLLECTION).doc(uid).get();
    try {
      if (snapshot.exists) {
        return Future.value(UserModel.fromFirebase(snapshot));
      }
      throw NullThrownError();
    }catch(e) {
      throw e;
    }
  }

  Future<UserModel> createUser() {
    DocumentReference ref = this.getDatabase.collection(USER_COLLECTION).doc(user.uid);
    UserModel userModel = UserModel.userModelFromFirebase(user);
    ref.set(userModel.toJson());

    return this.getDatabase.runTransaction((Transaction tx) async {
      await ref.set(userModel.toJson());
    }).then((value) => Future.value(userModel)).catchError((e) => throw e);
  }

  UserModel get getUser => _currentUser;

   void unsetUser() => _currentUser = null;
}
