import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSavedAudio = 'audio_example.aac';
class SoundRecorder{
  FlutterSoundRecorder? audioRecorder;
  bool _isRecorderInitalized = false;
  var audiourl;

  bool get isRecording => audioRecorder!.isRecording;

  Future init()async{
    audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted ){
      throw RecordingPermissionException('Microphone Permission not granted');
    }
    await audioRecorder!.openAudioSession();
    _isRecorderInitalized = true;

  }

  void dispose(){
    _isRecorderInitalized = true;
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
    _isRecorderInitalized = false;
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? urlFile;
  Future _record()async{
    if(!_isRecorderInitalized) return;
    await audioRecorder!.startRecorder(toFile: pathToSavedAudio);
  }

  Future _stop()async{
    if(!_isRecorderInitalized) return;
    await audioRecorder!.stopRecorder();
    print('Audio Recorder ::: $audioRecorder');
    await getAudioUrl();
  }

  Future getAudioUrl()async{
    audiourl = await audioRecorder!.getRecordURL(path: 'Audio');
    await audioRecorder!.getRecordURL(path: 'Audio');
    print('Audio Url ::::$audiourl');
    return audiourl;
  }

  Future toogleRecording()async{
    if(audioRecorder!.isStopped){
      await _record();
    }else{
      await _stop();
    }
  }
}
