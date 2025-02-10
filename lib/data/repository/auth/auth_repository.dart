import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reentry/data/model/create_account_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository_interface.dart';
import 'package:reentry/exception/app_exceptions.dart';
import 'package:reentry/main.dart';

import '../../../domain/usecases/auth/login_usecase.dart';

class AuthRepository extends AuthRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  Future<UserDto> appleSignIn() {
    // TODO: implement appleSignIn
    throw UnimplementedError();
  }

  @override
  Future<UserDto> createAccount(UserDto createAccount) async {
    if (createAccount.userId == null) {
      throw BaseExceptions('Unable to create account');
    }
    final doc = collection.doc(createAccount.userId!);
    await doc.set(createAccount
        .copyWith(
            userId: doc.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now())
        .toJson());

    return createAccount;
  }

  Future<UserDto?> findUserById(String id) async {
    final doc = collection.doc(id);
    final result = await doc.get();
    if (result.exists) {
      return UserDto.fromJson(result.data() ?? {});
    }
    return null;
  }

  @override
  Future<UserDto> googleSignIn() async {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse?> login(
      {required String email, required String password}) async {
    try {
      final loginResponse = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final authUser = loginResponse.user;
      if (authUser == null) {
        throw BaseExceptions('Account not found');
      }
      final userId = authUser.uid;
      final user = await findUserById(userId);
      if (user?.deleted ?? false) {
        throw BaseExceptions('Your account have been deleted');
      }
      return LoginResponse(authUser.uid, user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw BaseExceptions('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw BaseExceptions('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw BaseExceptions("Invalid credential");
      }
      throw BaseExceptions('Something went wrong');
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }

  @override
  Future<void> updateUser(UserDto payload) async {
    try {
      final doc = collection.doc(payload.userId!);
      await doc.set(payload.toJson());
      return;
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }

  @override
  Future<User?> createAccountWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //create db account
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String error = 'Something went wrong';
      if (e.code == 'weak-password') {
        error = ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error = ('The account already exists for that email.');
      }
      throw BaseExceptions(error);
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
