import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_states.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(InitialChatState());
  static ChatCubit get(context) => BlocProvider.of(context);

  File? file;
  var imagePicker = ImagePicker();
  String? url ;
  uploadImage() async {
    emit(UploadImageLoading());
    try {
      print('alaaaaaaaaaaa');
      XFile? imgPicked = await imagePicker.pickImage(source: ImageSource.gallery);
      var nameImage = basename(imgPicked!.path);
      if (imgPicked != null) {
        file = File(imgPicked.path);
        var random = Random().nextInt(10000);
        nameImage = '$random$nameImage';
        var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
        print(file);
        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();
        print('Url Image : $url');
      }
      emit(UploadImageSuccess());
    }catch(e){
      if (kDebugMode) {print('error is $e');}
      emit(UploadImageError());
    }
  }

  File? cameraFile;
  var cameraPicker = ImagePicker();
  late String? urlCamera;
  uploadImageCamera() async {
    emit(UploadCameraImageLoading());
    try{
      XFile? imgPicked = await cameraPicker.pickImage(source: ImageSource.camera);
      var nameImage = basename(imgPicked!.path);
      if (imgPicked != null) {
        cameraFile = File(imgPicked.path);
        var random = Random().nextInt(10000);
        nameImage = '$random$nameImage';
        var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
        print(cameraFile);
        await refStorage.putFile(cameraFile!);
        urlCamera = await refStorage.getDownloadURL();
      }
      emit(UploadCameraImageSuccess());
    } catch(error){
      emit(UploadCameraImageError());
    }
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? urlFile;
  Future pickFile()async{
    emit(UploadFileLoading());
    try{
      final result = await FilePicker.platform.pickFiles();
      pickedFile = result?.files.first;
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
      uploadTask = ref.putFile(file);
      final snapShot = await uploadTask!.whenComplete(() {});
      urlFile = await snapShot.ref.getDownloadURL();
      print('Download Link : $urlFile');
      emit(UploadFileSuccess());
    }catch(error){
      emit(UploadFileError());
    }
  }

  List <Contact> contacts = [];
  bool isLoading = true;
  dynamic phoneNumber;

  void getContactPermission() async {
    emit(PermissionLoading());
    if (await Permission.contacts.isGranted) {
      await fetchContacts();
      emit(PermissionSuccess());
    } else {
      await Permission.contacts.request();
      emit(PermissionError());
    }
  }

  Future fetchContacts() async {
    emit(GetContactsLoading());
    await ContactsService.getContacts().then((value){
      contacts = value;
      emit(GetContactsSuccess());
    }).catchError((error){
      emit(GetContactsError());
    });
    return contacts;
  }
}




