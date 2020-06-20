import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection(AppConstants.prod + "userData");
final concreteEntryRef =
    Firestore.instance.collection(AppConstants.prod + 'concreteEntries');
final progressRef =
    Firestore.instance.collection(AppConstants.prod + 'concreteProgress');

int lastDateYear = 2022;
