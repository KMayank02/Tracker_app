import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import 'auth_errors.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventLogIn>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user in
        try {
          final googleUser = await GoogleSignIn().signIn();

          final googleAuth = await googleUser?.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          final userLogged =
              await FirebaseAuth.instance.signInWithCredential(credential);

          final user = userLogged.user!;
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventInitialize>(
      (event, emit) async {
        // get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } else {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
            ),
          );
        }
      },
    );
    // log out event
    on<AppEventLogOut>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user out
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        // log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );
    // handle account deletion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // log the user out if we don't have a current user
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // delete the user folder
        try {
          // delete user folder
          final folderContents = await FirebaseStorage.instance
              .ref('profile_images/${user.uid}')
              .listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {}); // maybe handle the error?
          }
          // delete the folder itself
          await FirebaseStorage.instance
              .ref('profile_images/${user.uid}')
              .delete()
              .catchError((_) {});

          // delete the user
          await user.delete();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .delete();

          await FirebaseFirestore.instance
              .collection('favourites')
              .doc(user.uid)
              .delete();

          await FirebaseFirestore.instance
              .collection('watchlist')
              .doc(user.uid)
              .delete();
          // log the user out
          // await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          // log the user out in the UI as well
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // we might not be able to delete the folder
          // log the user out
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
