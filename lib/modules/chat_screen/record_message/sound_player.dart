import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter/material.dart';
import 'package:talki/modules/chat_screen/record_message/sound_recorder.dart';


class SoundPlayer{
  FlutterSoundPlayer? _audioPlayer;
  bool get isPlaying => _audioPlayer!.isPlaying;
  Future init()async{
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
  }

  void dispose(){
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished)async{
    await _audioPlayer!.startPlayer(
        fromURI: pathToSavedAudio,
        whenFinished: whenFinished
    );
  }

  Future _stop()async{
    await _audioPlayer!.stopPlayer();
  }

  Future tooglePlaying({required VoidCallback whenFinished})async{
    if(_audioPlayer!.isStopped){
      await _play(whenFinished);
    }else{
      await _stop();
    }
  }
}