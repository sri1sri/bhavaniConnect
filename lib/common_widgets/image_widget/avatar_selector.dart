import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/helpers.dart';
import 'package:bhavaniconnect/common_widgets/image_widget/image_uploader.dart';
import 'package:bhavaniconnect/common_widgets/image_widget/radial-progress-painter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarSelector extends StatefulWidget {
  final String userId;
  final bool isEditable;
  AvatarSelector(this.userId, this.isEditable);

  @override
  State createState() => new AvatarSelectorState(userId);
}

class AvatarSelectorState extends State<AvatarSelector>
    with TickerProviderStateMixin {
  final String userId;
  bool hasData = false;
  bool hasError = false;
  Object error;
  String avatarUrl;
  UploadStatus uploadStatus;

  AvatarSelectorState(this.userId);

  Animation<double> animation;
  AnimationController animationController;
  AnimationState state = AnimationState.show;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });

    Firestore.instance
        .collection('userData')
        .document(userId)
        .get()
        .then((doc) {
      if (!mounted) return;
      setState(() {
        avatarUrl = doc.data['avatar'];
        hasData = true;
      });
    }).catchError((err) {
      setState(() {
        hasError = true;
        error = err;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Align(
                    child: GestureDetector(
                        onTap: () {
                          if (state == AnimationState.show &&
                              widget.isEditable) {
                            animationController.forward();
                            state = AnimationState.hide;
                          } else if (state == AnimationState.hide &&
                              widget.isEditable) {
                            animationController.reverse();
                            state = AnimationState.show;
                          } else {
                            if (widget.isEditable) {
                              animationController.forward();
                              state = AnimationState.hide;
                            }
                          }
                        },
                        child: _buildAvatarCircle()),
                    alignment: Alignment.topCenter),
                Align(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(animation.value),
                      child: Opacity(
                          opacity: animation.value,
                          child: _buildUploadButton(
                              ImageSource.gallery, Icons.photo)),
                    ),
                    alignment: Alignment.bottomLeft),
                Align(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(animation.value),
                      child: Opacity(
                          opacity: animation.value,
                          child: _buildUploadButton(
                              ImageSource.camera, Icons.photo_camera)),
                    ),
                    alignment: Alignment.bottomRight),
              ],
            ),
            width: 110.0,
            height: 110.0,
            padding: EdgeInsets.only(right: 10.0),
          ),
          _buildStatusMessage(),
        ],
      ),
    );
  }

  Widget _buildStatusMessage() {
    if (hasError) {
      return RedError(error);
    }

    var inProgress = uploadStatus != null && uploadStatus.isInProgress;
    return Visibility(
        visible: inProgress, child: Text(uploadStatus?.message ?? ""));
  }

  Widget _buildUploadButton(ImageSource source, IconData icon) {
    return InkWell(
      onTap: () {
        _updateAvatar(source);
      },
      child: Opacity(
        opacity: 0.8,
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCircle() {
    var isCompelete =
        uploadStatus == null || uploadStatus.isInProgress == false;
    if (isCompelete) {
      ImageProvider provider;
      if (hasData) {
        provider = HasValue.hasValue(avatarUrl)
            ? CachedNetworkImageProvider(avatarUrl)
            : AssetImage('images/generic_user.png');
      } else {
        // when waiting for profile data to download, show nothing
        provider = AssetImage('images/transparent.png');
      }

      return Stack(
        children: <Widget>[
          Container(
              child: ClipOval(
                child: FadeInImage(
                  image: provider,
                  placeholder: AssetImage(
                    'images/transparent.png',
                  ),
                ),
              ),
              padding: const EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              )),
          hasData && !HasValue.hasValue(avatarUrl)
              ? Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'Add Photo',
                    style: descriptionStyle,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(5.0),
      child: CustomPaint(
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("images/profile-uploading.png"),
        ),
        foregroundPainter: RadialProgressPainter(
            lineColor: Colors.white,
            completeColor: Colors.blueAccent,
            completePercent: uploadStatus.percentageDone,
            width: 5.0),
      ),
    );
  }

  _updateAvatar(ImageSource source) async {
    var selected = await ImagePicker.pickImage(source: source);
    if (selected == null) {
      // user cancelled
      return;
    }

    var cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        cropStyle: CropStyle.circle);

    if (cropped == null) {
      // user cancelled
      return;
    }

    var storageReference =
        FirebaseStorage.instance.ref().child('avatars').child(userId);
    var saveUrl = (url) async {
      Firestore.instance.collection('userData').document(userId).updateData({
        'avatar': url,
      });
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("avatar", url);
    };

    ImageUploader.processAvatarUpload(cropped, storageReference, saveUrl)
        .forEach((status) {
      setState(() {
        uploadStatus = status;
        if (!status.isInProgress && status.downloadUrl != null) {
          avatarUrl = status.downloadUrl;
        }
      });
    });
  }
}

enum AnimationState {
  show,
  hide,
}
