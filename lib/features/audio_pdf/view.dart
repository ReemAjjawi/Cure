import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/resources/managers/colors_manager.dart';
import '../../core/helper/indicator.dart';
import '../../main.dart';
import '../subjects/presentation/view.dart';
import 'presentation/lecture_information/presenation/bloc/lecture_info_bloc.dart';
import 'presentation/lecture_information/presenation/bloc/lecture_info_event.dart';
import 'presentation/lecture_information/presenation/bloc/lecture_info_state.dart';
import 'presentation/pdf/presentation/bloc/pdf_bloc.dart';
import 'presentation/pdf/presentation/bloc/pdf_event.dart';
import 'presentation/pdf/presentation/bloc/pdf_state.dart';

class PdfAudioPage extends StatefulWidget {
  PdfAudioPage(
      {super.key,
      required this.lectureName,
      required this.subjectName,
      required this.index});
  int index;
  String lectureName;
  String subjectName;
  @override
  State<PdfAudioPage> createState() => _PdfAudioPageState();
}

class _PdfAudioPageState extends State<PdfAudioPage> {
  String lectureNameHack = '';
  ValueNotifier<Duration> positionNotifier = ValueNotifier(Duration.zero);
  ValueNotifier<Duration> durationNotifier = ValueNotifier(Duration.zero);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isDownloaded = ValueNotifier(false);
  ValueNotifier<double> progress = ValueNotifier(0.0);
  ValueNotifier<double> currentSpeedNotifier = ValueNotifier<double>(1.0);
  ValueNotifier<bool> lectureOnlyAudioWithoutPdf = ValueNotifier(true);
 final CancelToken _cancelToken = CancelToken();
  late final ValueNotifier<bool> _isPlayingNotifier;
  int? audioSize = 0;
  int? id = 0;
  late AudioPlayer player;

  Future<void> playTrack(String trackPath) async {
    try {
      await player.setFilePath(trackPath);
      await player.play();
      if (mounted) {
        positionNotifier.value =
            Duration.zero; // Reset position for the new track
      }
    } catch (e) {
      print("Error playing track: $e");
    }
  }

  @override
  void initState() {
    super.initState();

// Example usage
    lectureNameHack = transliterateToEnglish(widget.lectureName);
    print(widget.lectureName); // Converts the Arabic text into English letters

    player = AudioPlayer(); // Initialize the audio player

    // Listen to position updates
    player.positionStream.listen((p) {
      if (mounted) {
        positionNotifier.value = p;
      }
    });

    _isPlayingNotifier = ValueNotifier<bool>(player.playing);
    player.playingStream.listen((isPlaying) {
      _isPlayingNotifier.value = isPlaying;
    });

    // Listen to duration updates
    player.durationStream.listen((d) {
      if (mounted) {
        durationNotifier.value = d ?? Duration.zero;
      } // Handle null duration
    });

    // Listen to player state updates
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          positionNotifier.value = Duration.zero;
        }
        player.pause();
        _isPlayingNotifier.value = false;
        player.seek(positionNotifier.value); // Seek back to start when finished
      }
    });

    _checkFile();
  }

  void handleSkipPrevious() async {
    if (player.duration != null) {
      try {
        await player.seek(Duration.zero);
        if (!player.playing) {
          _isPlayingNotifier.value = true;
          await player.play();
        }
      } catch (e) {
        print("Error in handleSkipPrevious: $e");
      }
    } else {
      print("Cannot skip: Duration is null.");
    }
  }

  void handleSkipNext() async {
    if (player.duration != null) {
      try {
        final lastSecond = player.duration! - const Duration(seconds: 1);
        await player.seek(lastSecond);
        if (!player.playing) {
          _isPlayingNotifier.value = true;
          await player.play();
        }
      } catch (e) {
        print("Error in handleSkipNext: $e");
      }
    } else {
      print("Cannot skip: Duration is null.");
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  // Change playback speed
  void changeSpeed(double speed) {
    currentSpeedNotifier.value = speed;

    player.setSpeed(speed);
  }

  // Check if the audio file is available on the device
  Future<void> _checkFile() async {
    final available = await isAudioFileAvailable("$lectureNameHack.mp3");
    if (mounted) {
      isDownloaded.value = available;
    }
  }

  Future<void> downloadAudio() async {
    //  double progress = 0.0;
    if (mounted) {
      isLoading.value = true;
      progress.value = 0.0;
    }
    try {
      final url =
          "https://cure-app.webmyidea.com/api/v1/lectures/audio-lectures/download/$id";
      print(url);
      print("id");
      print(id);

      await _downloadAudioFile(url, "$lectureNameHack.mp3");
      // if (mounted) {
      //   isLoading.value = false;
      //   isDownloaded.value = true;
      // }
    } catch (e) {
      if (mounted) {
        isLoading.value = true;
        progress.value = 0.0;
      }
      print("Download failed: $e");
    }
  }

  // Check if the audio file exists on the device
  Future<bool> isAudioFileAvailable(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    return File(filePath).exists();
  }

  Future<void> playAudio() async {
    try {
      print("object");
      print("---------------------------------------");
      if (player.playing) {
        // If already playing, pause the playback
        _isPlayingNotifier.value = false;
        await player.pause();
      } else {
        if (player.currentIndex != null && player.position > Duration.zero) {
          // If a track is loaded and playback was paused, resume from the current position
          _isPlayingNotifier.value = true;

          await player.play();
        } else {
          // If no track is loaded, load and play the file from the beginning
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$lectureNameHack.mp3';

          final file = File(filePath);
          if (!await file.exists()) {
            print("Audio file does not exist at path: $filePath");
            return;
          }

          await player.setFilePath(filePath);
          _isPlayingNotifier.value = true;

          await player.play();
        }
      }
    } catch (e) {
      print("Error in playAudio: $e");
    }
  }

  Future<File> _downloadAudioFile(String url, String fileName) async {
    int receivedBytes = 0;
    int? totalBytes = 0;

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 60), // Connection timeout
      receiveTimeout: const Duration(minutes: 30), // Receiving timeout
    );
    Dio dio = Dio(options);

    var box = Hive.box('projectBox');
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    // Return the file if it already exists
    if (await file.exists()) return file;

    try {
      await dio.download(
        url,
        filePath,
        options: Options(
          headers: {"Authorization": "Bearer ${box.get('token')}"},
        ),
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          receivedBytes = received;
          totalBytes = audioSize;

          print("=================total===========");
          print(totalBytes);
          print("=================rec===========");
          print(receivedBytes);

          if (totalBytes != -1) {
            progress.value = (receivedBytes / totalBytes!) * 100;

            if (receivedBytes == totalBytes) {
              isLoading.value = false;
              isDownloaded.value = true;
              progress.value = 100;
            }
          }
        },
      );

      // Check if the file download is complete
      if (receivedBytes != totalBytes) {
        // Delete the incomplete file
        if (await file.exists()) {
          await file.delete();
          print("Incomplete file deleted");
        }
        throw Exception("File download incomplete. File deleted.");
      }
    } catch (e) {
      // Handle download errors
      print("Error downloading audio: $e");

      if (await file.exists()) {
        await file.delete(); // Ensure incomplete file is deleted
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("فشل تنزيل الملف الصوتي"),
      ));
      Navigator.pop(context);
    }

    return file;
  }
  @override
  void dispose() {
    player.dispose();
    positionNotifier.dispose();
    durationNotifier.dispose();
    isLoading.dispose();
    isDownloaded.dispose();
    lectureOnlyAudioWithoutPdf.dispose();
    progress.dispose();
    currentSpeedNotifier.dispose();
     _cancelToken.cancel("Download cancelled due to page exit.");
    _isPlayingNotifier.dispose();
    // Dispose of the player when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LectureInformationBloc()
            ..add(GetInfoLecture(lectureId: widget.index)),

          //   BlocProvider(create: (context) => AudioBloc()..add(GetAudio())),
        ),
        BlocProvider(
          create: (context) => PdfBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          body:
              BlocConsumer<LectureInformationBloc, GetInformationLectureState>(
            listener: (context, state) {
              if (state is SuccessGet) {
                if (state.xx.pdfLectureId == null &&
                    state.xx.pdfLectureDownloadLink == null &&
                    state.xx.audioLectureDownloadLink == null &&
                    state.xx.audioLectureId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("لا يوجد تسجيل صوتي لهذه المحاضرة بعد")));
                  Navigator.pop(context);
                }

                setState(() {
                  audioSize = state.xx.audioFileSize;

                  id = state.xx.audioLectureId;
                });
                print("hiiiii");
                if (state.xx.pdfLectureId != null) {
                  context
                      .read<PdfBloc>()
                      .add(GetPdf(index: state.xx.pdfLectureId));

                  lectureOnlyAudioWithoutPdf.value = false;
                } else {
                  lectureOnlyAudioWithoutPdf.value = true;
                }
              } else if (state is FailureGet) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 5),
                ));
              }
            },
            builder: (context, state) {
              if (state is SuccessGet && id != 0) {
                return SafeArea(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: lectureOnlyAudioWithoutPdf,
                        builder: (context, isAudioOnly, child) {
                          return isAudioOnly == false
                              ? BlocConsumer<PdfBloc, PdfState>(
                                  listener: (context, state) {
                                    if (state is FailurePdfState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(state.message),
                                        duration: const Duration(seconds: 5),
                                      ));
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is showpdf) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 20),
                                                  child: Text(
                                                    widget.subjectName,
                                                    style: TextStyle(
                                                        color: ColorsManager
                                                            .loginColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: screenHeight / 1.85,
                                                child: Center(
                                                  child: PDFView(
                                                    filePath: state.pfile.path,
                                                    //  filePath: (state).pdf[0].fileUrl,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                //    height: screenHeight / 5,
                                                decoration: BoxDecoration(
                                                    color: ColorsManager
                                                        .secondaryColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SingleChildScrollView(
                                                            child: Text(
                                                              // overflow:
                                                              //     TextOverflow.ellipsis,
                                                              // maxLines: 1,
                                                              widget
                                                                  .lectureName,
                                                              style: TextStyle(
                                                                color: const Color(
                                                                    0xFF844134),
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          ValueListenableBuilder<
                                                              double>(
                                                            valueListenable:
                                                                currentSpeedNotifier,
                                                            builder: (context,
                                                                currentSpeed,
                                                                _) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  if (currentSpeed ==
                                                                      1.0) {
                                                                    changeSpeed(
                                                                        1.5);
                                                                  } else if (currentSpeed ==
                                                                      1.5) {
                                                                    changeSpeed(
                                                                        2.0);
                                                                  } else {
                                                                    changeSpeed(
                                                                        1.0);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 60,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: const Color(
                                                                          0xFF844134),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      '$currentSpeed',
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      ValueListenableBuilder<
                                                          Duration>(
                                                        valueListenable:
                                                            durationNotifier,
                                                        builder: (context,
                                                            durationValue,
                                                            child) {
                                                          return ValueListenableBuilder<
                                                              Duration>(
                                                            valueListenable:
                                                                positionNotifier,
                                                            builder: (context,
                                                                positionValue,
                                                                child) {
                                                              return Column(
                                                                children: [
                                                                  // Slider
                                                                  Slider(
                                                                    min: 0,
                                                                    max: durationValue
                                                                        .inSeconds
                                                                        .toDouble(),
                                                                    value: positionValue
                                                                        .inSeconds
                                                                        .toDouble()
                                                                        .clamp(
                                                                            0,
                                                                            durationValue.inSeconds.toDouble()),
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    onChanged:
                                                                        (value) {
                                                                      handleSeek(
                                                                          value); // Calls the handleSeek method
                                                                    },
                                                                  ),

                                                                  // Position and Duration Row
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        formatDuration(
                                                                            positionValue),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xFF844134),
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        formatDuration(
                                                                            durationValue),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xFF844134),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              print(
                                                                  "Skip Previous Button Pressed");
                                                              handleSkipPrevious();
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .skip_previous,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),

// Play/Pause or Download Button
                                                          ValueListenableBuilder<
                                                              bool>(
                                                            valueListenable:
                                                                isDownloaded,
                                                            builder: (context,
                                                                isDownloadedValue,
                                                                child) {
                                                              return IconButton(
                                                                onPressed: isDownloadedValue
                                                                    ? playAudio
                                                                    : downloadAudio,
                                                                icon:
                                                                    isDownloadedValue
                                                                        ? ValueListenableBuilder<
                                                                            bool>(
                                                                            valueListenable:
                                                                                _isPlayingNotifier, // Adjust to use a ValueNotifier for `player.playing`
                                                                            builder: (context,
                                                                                isPlaying,
                                                                                child) {
                                                                              return Icon(
                                                                                isPlaying ? Icons.pause : Icons.play_circle,
                                                                                size: 55,
                                                                                color: Colors.white,
                                                                              );
                                                                            },
                                                                          )
                                                                        : ValueListenableBuilder<
                                                                            bool>(
                                                                            valueListenable:
                                                                                isLoading,
                                                                            builder: (context,
                                                                                isLoadingValue,
                                                                                child) {
                                                                              return isLoadingValue
                                                                                  ? ValueListenableBuilder<double>(
                                                                                      valueListenable: progress,
                                                                                      builder: (context, progressValue, child) {
                                                                                        return Row(
                                                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            CircularProgressIndicator(
                                                                                              backgroundColor: ColorsManager.loginColor,
                                                                                              color: ColorsManager.loginColor,
                                                                                              value: progressValue,
                                                                                              strokeWidth: 6.0,
                                                                                            ),
                                                                                            const SizedBox(height: 7),
                                                                                            Text(
                                                                                              '${progressValue.toStringAsFixed(1)}%',
                                                                                              style: const TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Color(0xFF844134),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : const Icon(
                                                                                      Icons.download,
                                                                                      size: 55,
                                                                                      color: Colors.white,
                                                                                    );
                                                                            },
                                                                          ),
                                                              );
                                                            },
                                                          ),

                                                          IconButton(
                                                            onPressed: () =>
                                                                handleSkipNext(),
                                                            icon: const Icon(
                                                              Icons.skip_next,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (state is FailurePdfState) {
                                      return const Text("");
                                    } else {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(child: Indicator()),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 20),
                                          child: Text(
                                            widget.subjectName,
                                            style: TextStyle(
                                                color: ColorsManager.loginColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.09,
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(colors: [
                                              const Color(0xff73737399),
                                              const Color(0xFFD9D9D9)
                                                  .withOpacity(0.6)
                                            ])),
                                        height: screenHeight / 3.5,
                                        child: Container(
                                          height: screenHeight * 0.2,
                                          width: screenWidth * 0.8,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/sound.png")),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.09,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: screenHeight / 3,
                                        decoration: BoxDecoration(
                                          color: ColorsManager.secondaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SingleChildScrollView(
                                                    child: Text(
                                                      // overflow:
                                                      //     TextOverflow.ellipsis,
                                                      // maxLines: 1,
                                                      widget.lectureName,
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFF844134),
                                                        fontSize:
                                                            screenWidth * 0.03,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  ValueListenableBuilder<
                                                      double>(
                                                    valueListenable:
                                                        currentSpeedNotifier,
                                                    builder: (context,
                                                        currentSpeed, _) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (currentSpeed ==
                                                              1.0) {
                                                            changeSpeed(1.5);
                                                          } else if (currentSpeed ==
                                                              1.5) {
                                                            changeSpeed(2.0);
                                                          } else {
                                                            changeSpeed(1.0);
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: const Color(
                                                                  0xFF844134),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '$currentSpeed',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              ValueListenableBuilder<Duration>(
                                                valueListenable:
                                                    durationNotifier,
                                                builder: (context,
                                                    durationValue, child) {
                                                  return ValueListenableBuilder<
                                                      Duration>(
                                                    valueListenable:
                                                        positionNotifier,
                                                    builder: (context,
                                                        positionValue, child) {
                                                      return Column(
                                                        children: [
                                                          // Slider
                                                          Slider(
                                                            min: 0,
                                                            max: durationValue
                                                                .inSeconds
                                                                .toDouble(),
                                                            value: positionValue
                                                                .inSeconds
                                                                .toDouble()
                                                                .clamp(
                                                                    0,
                                                                    durationValue
                                                                        .inSeconds
                                                                        .toDouble()),
                                                            activeColor:
                                                                Colors.white,
                                                            onChanged: (value) {
                                                              handleSeek(
                                                                  value); // Calls the handleSeek method
                                                            },
                                                          ),

                                                          // Position and Duration Row
                                                          Row(
                                                            children: [
                                                              Text(
                                                                formatDuration(
                                                                    positionValue),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFF844134),
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                formatDuration(
                                                                    durationValue),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFF844134),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                              // Slider(
                                              //   min: 0,
                                              //   activeColor: Colors.white,
                                              //   max: durationNotifier.value.inSeconds.toDouble(),
                                              //   value: positionNotifier.value.inSeconds.toDouble(),
                                              //   onChanged: (value) {
                                              //     handleSeek(
                                              //         value); // Calls the handleSeek method
                                              //   },
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       formatDuration(positionNotifier.value),
                                              //       style: const TextStyle(
                                              //         color: Color(0xFF844134),
                                              //       ),
                                              //     ),
                                              //     const Spacer(),
                                              //     Text(
                                              //       formatDuration(durationNotifier.value),
                                              //       style: const TextStyle(
                                              //         color: Color(0xFF844134),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      print(
                                                          "Skip Previous Button Pressed");
                                                      handleSkipPrevious();
                                                    },
                                                    icon: const Icon(
                                                      Icons.skip_previous,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  ),

// Play/Pause or Download Button
                                                  ValueListenableBuilder<bool>(
                                                    valueListenable:
                                                        isDownloaded,
                                                    builder: (context,
                                                        isDownloadedValue,
                                                        child) {
                                                      return IconButton(
                                                        onPressed:
                                                            isDownloadedValue
                                                                ? playAudio
                                                                : downloadAudio,
                                                        icon: isDownloadedValue
                                                            ? ValueListenableBuilder<
                                                                bool>(
                                                                valueListenable:
                                                                    _isPlayingNotifier, // Adjust to use a ValueNotifier for `player.playing`
                                                                builder: (context,
                                                                    isPlaying,
                                                                    child) {
                                                                  return Icon(
                                                                    isPlaying
                                                                        ? Icons
                                                                            .pause
                                                                        : Icons
                                                                            .play_circle,
                                                                    size: 55,
                                                                    color: Colors
                                                                        .white,
                                                                  );
                                                                },
                                                              )
                                                            : ValueListenableBuilder<
                                                                bool>(
                                                                valueListenable:
                                                                    isLoading,
                                                                builder: (context,
                                                                    isLoadingValue,
                                                                    child) {
                                                                  return isLoadingValue
                                                                      ? ValueListenableBuilder<
                                                                          double>(
                                                                          valueListenable:
                                                                              progress,
                                                                          builder: (context,
                                                                              progressValue,
                                                                              child) {
                                                                            return Column(
                                                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                CircularProgressIndicator(
                                                                                  backgroundColor: ColorsManager.loginColor,
                                                                                  color: ColorsManager.loginColor,
                                                                                  value: progressValue,
                                                                                  strokeWidth: 6.0,
                                                                                ),
                                                                                const SizedBox(height: 7),
                                                                                Text(
                                                                                  '${progressValue.toStringAsFixed(1)}%',
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Color(0xFF844134),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .download,
                                                                          size:
                                                                              55,
                                                                          color:
                                                                              Colors.white,
                                                                        );
                                                                },
                                                              ),
                                                      );
                                                    },
                                                  ),

                                                  IconButton(
                                                    onPressed: () =>
                                                        handleSkipNext(),
                                                    icon: const Icon(
                                                      Icons.skip_next,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        }));
              } else if (state is FailureGet) {
                return const Text("");
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Indicator()),
                    ],
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }

  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String transliterateToEnglish(String arabicText) {
    // Regular expression to match Arabic characters
    final arabicPattern = RegExp(r'[\u0600-\u06FF]');
    bool wordIsArabic = arabicPattern.hasMatch(arabicText);
    if (wordIsArabic == true) {
      final arabicToLatin = {
        'إ': 'a',
        'أ': 'a',
        'ا': 'a',
        'ب': 'b',
        'ت': 't',
        'ث': 'th',
        'ج': 'j',
        'ح': 'h',
        'خ': 'kh',
        'د': 'd',
        'ذ': 'dh',
        'ر': 'r',
        'ز': 'z',
        'س': 's',
        'ش': 'sh',
        'ص': 's',
        'ض': 'd',
        'ط': 't',
        'ظ': 'z',
        'ع': 'aa',
        'غ': 'gh',
        'ف': 'f',
        'ق': 'q',
        'ك': 'k',
        'ل': 'l',
        'م': 'm',
        'ن': 'n',
        'ه': 'h',
        'ة': 'h',
        'و': 'w',
        'ي': 'y',
        'ى': 'y'
      };

      String result = '';
      for (int i = 0; i < arabicText.length; i++) {
        String char = arabicText[i];
        result += arabicToLatin[char] ?? char;
      }
      return result;
    }
    return arabicText;
  }
}
