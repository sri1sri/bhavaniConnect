  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection("userData");