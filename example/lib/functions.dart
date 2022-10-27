import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:firebase_for_all/firebase_for_all.dart' as firebase_for_all;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebaseforall/main.dart';
import 'package:path_provider/path_provider.dart';

void getCollection() {
  FirestoreForAll.instance
      .collection('users')
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });
}

void getDocument() {
  FirestoreForAll.instance
      .collection('users')
      .doc("47tlB8z60akW8wcEdv7y")
      .get()
      .then((DocumentSnapshotForAll documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document data: ${documentSnapshot.data()}');
    } else {
      print('Document does not exist on the database');
    }
  });
}

query() async {
  await FirestoreForAll.instance
      .collection('users')
      .where('age', isGreaterThan: 10)
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });

  print("--------------------------");
  await FirestoreForAll.instance
      .collection('users')
      .where('age', isLessThan: 10)
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });

  print("--------------------------");
  await FirestoreForAll.instance
      .collection('users')
      .where('array', arrayContains: "test")
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });

  print("--------------------------");
  await FirestoreForAll.instance
      .collection('users')
      .orderBy("age", descending: true)
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });

  print("--------------------------");
  await FirestoreForAll.instance
      .collection('users')
      .limit(2)
      .get()
      .then((QuerySnapshotForAll querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["name"]);
    });
  });
}

addDocument() {
  ColRef users = FirestoreForAll.instance.collection('users');
  users
      .add({'name': "John", 'surname': "Doe", 'age': 42})
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

setDocument() {
  ColRef users = FirestoreForAll.instance.collection('users');
  users
      .doc("12345")
      .set({'name': "John", 'surname': "Doe", 'age': 42})
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

updateDocument() {
  ColRef users = FirestoreForAll.instance.collection('users');
  users
      .doc('12345')
      .update({'surname': 'Doe'})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

deleteDocument() {
  ColRef users = FirestoreForAll.instance.collection('users');
  users
      .doc('12345')
      .delete()
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

withConverter() async {
  final userRef =
      FirestoreForAll.instance.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.map!),
            toFirestore: (movie, _) => movie.toJson(),
          );

  List<DocumentSnapshotForAll<User>> users = await userRef
      .where('age', isEqualTo: 31)
      .get()
      .then((snapshot) => snapshot.docs);

  print(users[0].data()!.name);
  // Add a movie
  await userRef.add(
    User(name: 'Chris', surname: 'Doe', age: 20),
  );

  // Get a movie with the id 42
  User user = await userRef
      .doc('TWDSKB4PizqQVDv4vN4D')
      .get()
      .then((snapshot) => snapshot.data()!);
  print(user.name);
}

uploadFile() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final mountainsRef = storageRef.child("mountains.jpg");
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.absolute}/file-to-upload.png';
  File file = File(filePath);
  UploadTaskForAll task = mountainsRef.putFile(file);
}

uploadString() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final mountainsRef = storageRef.child("mountains.jpg");
  String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';
  UploadTaskForAll task = mountainsRef.putString(dataUrl,
      format: firebase_storage.PutStringFormat.dataUrl);
}

uploadRawData() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final mountainsRef = storageRef.child("mountains.jpg");
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.absolute}/file-to-upload.png';
  File file = File(filePath);
  UploadTaskForAll task = mountainsRef.putData(file.readAsBytesSync());
}

getDownloadUrl() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final mountainsRef = storageRef.child("mountains.jpg");
  String url = await mountainsRef.getDownloadURL();
}

manageUploads() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final mountainsRef = storageRef.child("mountains.jpg");
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.absolute}/file-to-upload.png';
  File file = File(filePath);
  mountainsRef.putFile(file).snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // ...
        break;
      case TaskState.paused:
        // ...
        break;
      case TaskState.success:
        // ...
        break;
      case TaskState.canceled:
        // ...
        break;
      case TaskState.error:
        // ...
        break;
    }
  });
}

downloadInMemory() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final islandRef = storageRef.child("images/island.jpg");
  const oneMegabyte = 1024 * 1024;
  final Uint8List? data = await islandRef.getData(oneMegabyte);
}

downloadToLocalFile() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final islandRef = storageRef.child("images/island.jpg");

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.absolute}/images/island.jpg";
  final file = File(filePath);

  DownloadTaskForAll downloadTask = await islandRef.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // TODO: Handle this case.
        break;
      case TaskState.paused:
        // TODO: Handle this case.
        break;
      case TaskState.success:
        // TODO: Handle this case.
        break;
      case TaskState.canceled:
        // TODO: Handle this case.
        break;
      case TaskState.error:
        // TODO: Handle this case.
        break;
    }
  });
}

deleteFile() async {
  final storageRef = FirebaseStorageForAll.instance.ref();
  final desertRef = storageRef.child("images/desert.jpg");
  await desertRef.delete();
}

listAllFiles() async {
  final storageRef = FirebaseStorageForAll.instance.ref().child("files/uid");
  final listResult = await storageRef.listAll();
  for (var prefix in listResult.prefixes) {
    // The prefixes under storageRef.
    // You can call listAll() recursively on them.
  }
  for (var item in listResult.items) {
    // The items under storageRef.
  }
}

getFiles() async {
  final storageRef = FirebaseStorageForAll.instance.ref().child("files/uid");

  List<StorageFile> files = await storageRef.getFiles();
}

getSize() async {
  final desertRef = FirebaseStorageForAll.instance.ref().child("images/desert.jpg");

  int size = await desertRef.getSize();
}
getDirectories() async {
  final storageRef = FirebaseStorageForAll.instance.ref().child("files/uid");

  List<firebase_for_all.StorageDirectory> dirs= await storageRef.getDirectories();
}

getDirSize() async {
  final storageRef = FirebaseStorageForAll.instance.ref().child("files/uid");

  int size = await storageRef.getDirSize();
}


class User {
  User({required this.name, required this.surname, required this.age});

  User.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          surname: json['surname']! as String,
          age: json['age']! as int,
        );

  final String name;
  final String surname;
  final int age;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'surname': surname,
      'age': age,
    };
  }
}
