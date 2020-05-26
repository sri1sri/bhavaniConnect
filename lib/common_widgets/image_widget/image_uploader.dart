// import 'package:image/image.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';

class ImageUploader {
  static Stream<UploadStatus> processAvatarUpload(File imageFile,
      StorageReference storageReference, Function(String) doneCallback) async* {
    yield UploadStatus(true, 'Reading image file...', 0);
    var data = await imageFile.readAsBytes();

    if (!_isJpg(imageFile)) {
      yield UploadStatus(true, 'Decoding image...', 0);
      // var image = await compute(decodeImage, data);

      yield UploadStatus(true, 'Encoding image...', 0);
      // data = await compute(encodeJpg, image);
    }

    yield UploadStatus(true, 'Preparing upload...', 0);
    var uploadTask = storageReference.putData(
        data, StorageMetadata(contentType: 'image/jpeg'));

    yield* uploadTask.events
        .takeWhile((event) => uploadTask.isInProgress)
        .map((event) {
      var percentage =
          100 * event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      if (uploadTask.isInProgress) {
        return UploadStatus(
            true, "Uploading ${percentage.ceil()}%", percentage);
      }

      return UploadStatus(
          true, _convertToUploadStatusMessage(uploadTask), percentage);
    });

    yield UploadStatus(true, 'Getting ready...', 0);
    if (uploadTask.isSuccessful) {
      var url = await storageReference.getDownloadURL() as String;
      yield UploadStatus(false, 'Done', 100, downloadUrl: url);
      try {
        await doneCallback(url);
      } catch (err) {
        yield UploadStatus(false, 'Error', 0,
            errorMessage: "Failed with error $err");
      }
    } else {
      yield UploadStatus(false, 'Error', 0,
          errorMessage:
              "Failed with error number ${uploadTask.lastSnapshot.error}");
    }
  }

  static bool _isJpg(File file) {
    var path = file.path.toLowerCase();
    return path.endsWith('.jpg') || path.endsWith('jpeg');
  }

  static String _convertToUploadStatusMessage(StorageUploadTask uploadTask) {
    if (uploadTask == null) {
      return '';
    }

    String result;
    if (uploadTask.isComplete) {
      if (uploadTask.isSuccessful) {
        result = 'Complete';
      } else if (uploadTask.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed';
      }
    } else if (uploadTask.isInProgress) {
      result = 'Uploading';
    } else if (uploadTask.isPaused) {
      result = 'Paused';
    }
    return result;
  }
}

class UploadStatus {
  final bool isInProgress;
  double percentageDone = 0;
  final String message;
  final String downloadUrl;
  final String errorMessage;

  UploadStatus(this.isInProgress, this.message, this.percentageDone,
      {this.downloadUrl, this.errorMessage});
}
