import 'package:firebase_dart/firebase_dart.dart';
import 'package:get/get.dart';
import '../../../firebase_for_all.dart';
import 'bridge.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'models.dart' as models;
import 'package:firebase_dart/firebase_dart.dart' as firebase_dart;

PutStringFormat putStringFormatConverter(firebase_storage.PutStringFormat state) {
  if (state == firebase_storage.PutStringFormat.raw) {
    return PutStringFormat.raw;
  } else if (state == firebase_storage.PutStringFormat.base64) {
    return PutStringFormat.base64;
  } else if (state == firebase_storage.PutStringFormat.base64Url) {
    return PutStringFormat.base64Url;
  } else {
    return PutStringFormat.dataUrl;
  }
}
models.TaskState taskStateConverterWindows(firebase_dart.TaskState state) {
  if (state == firebase_dart.TaskState.paused) {
    return models.TaskState.paused;
  } else if (state == firebase_dart.TaskState.running) {
    return models.TaskState.running;
  } else if (state == firebase_dart.TaskState.success) {
    return models.TaskState.success;
  } else if (state == firebase_dart.TaskState.canceled) {
    return models.TaskState.canceled;
  } else {
    return models.TaskState.error;
  }
}

Future<dynamic> initStorageWindows() async {
  FirebaseDart.setup(storagePath: 'users/');
  var options = Get.find<FirebaseControlPanel>().options!;
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: options.apiKey,
          authDomain: options.authDomain,
          projectId: options.projectId,
          storageBucket: options.storageBucket,
          messagingSenderId: options.messagingSenderId,
          appId: options.appId));
}

FirebaseStorage instanceStorageWindows() {
  return FirebaseStorage.instance;
}

Future<ListResultForAll> listAllWindows(Reference ref) async {
  Reference reference = ref;
  ListResult originalResult = await reference.listAll();
  return ListResultForAll(
      originalResult.items.map((e) => StorageRef.withReference(e)).toList(),
      originalResult.prefixes.map((e) => StorageRef.withReference(e)).toList());
}

Future<void> deleteFilesWindows(Reference ref) async {
  Reference reference = ref;
  ListResult result = await reference.listAll();
  for (var item in result.items) {
    await ref.child(item.name).delete();
  }
  var dirs = result.prefixes;
  for (var dir in dirs) {
    await deleteFilesWindows(reference.child(dir.name));
  }
}
