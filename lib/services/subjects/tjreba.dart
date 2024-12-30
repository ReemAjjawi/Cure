import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class tjreba extends StatefulWidget {
  const tjreba({super.key});

  @override
  State<tjreba> createState() => _tjrebaState();
}

class _tjrebaState extends State<tjreba> {
  Duration duration = Duration.zero;

  Duration position = Duration.zero;
  AudioPlayer player = AudioPlayer();

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }


  @override
  void initState() {
    super.initState(); // Don't forget to call super.initState()
    _setAudioSource(); // Call the method to set audio source

    player.positionStream.listen((p) {
      setState(() => position = p);
    });

    player.durationStream.listen((d) {
      setState(() => duration = d ?? Duration.zero); // Handle null duration
    });

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          position = Duration.zero;
        });
        player.pause();
        player.seek(position);
      }
    });
  }

  Future<void> _setAudioSource() async {
    try {
      await player.setUrl(
          "http://199.192.19.220:8000/api/v1/lectures/audio-lectures/download/1");

      player.positionStream.listen((p) {
        setState(() => position = p);
      });

      player.durationStream.listen((d) {
        setState(() => duration = d ?? Duration.zero); // Handle null duration
      });
    } catch (e) {
      // Handle error
      print("Error setting audio source: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("kjhgfdfghj"),
            Text(formatDuration(position)),
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: handleSeek),
            Text(formatDuration(duration)),
            IconButton(
                onPressed: handlePlayPause,
                icon: Icon(player.playing ? Icons.pause : Icons.play_arrow))
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
