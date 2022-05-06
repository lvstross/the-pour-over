import 'dart:core';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'rounded_button.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  Duration? _duration = const Duration();
  Duration? _position = const Duration();
  String _currentUrl = '';
  bool _isPlayer = false;
  ProcessingState _processingState = ProcessingState.idle;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Future<void> initPlayer() async {
    // Init audio Player
    audioPlayer = AudioPlayer();
    await setNewUrl();

    // Init stream listeners for playback states
    audioPlayer.durationStream.listen((Duration? state) {
      setState(() {
        _duration = state;
      });
    });

    audioPlayer.positionStream.listen((Duration? state) {
      setState(() {
        _position = state;
      });
    });

    audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        _isPlayer = state.playing;
        _processingState = state.processingState;
      });
    });
  }

  Future<void> setNewUrl() async {
    if (widget.url != _currentUrl) {
      setState(() {
        _currentUrl = widget.url;
      });
      await audioPlayer.setUrl(widget.url);
    }
  }

  void play() async {
    await setNewUrl();
    await audioPlayer.play();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    setState(() {
      _position = newDuration;
    });
    audioPlayer.seek(newDuration);
  }

  Widget spinner() {
    return const SizedBox(
      width: 80,
      height: 80,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: [Colors.grey],
        strokeWidth: 1,
      ),
    );
  }

  Widget playButton() {
    switch (_processingState) {
      case ProcessingState.idle:
        return spinner();
      case ProcessingState.buffering:
        return spinner();
      default:
        return RoundedButton(
          onPress: play,
          size: 80,
          child: const Icon(Icons.play_arrow, size: 40),
        );
    }
  }

  Widget playerButton() {
    return _isPlayer
        ? RoundedButton(
            onPress: pause,
            size: 50,
            child: const Icon(Icons.pause, size: 30),
          )
        : playButton();
  }

  Widget timeDurationString(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Text(
        '${_position.toString().substring(2, 7)} / ${_duration.toString().substring(2, 7)}',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget slideControls() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Slider(
          value: _position!.inSeconds.toDouble(),
          min: 0.0,
          max: _duration!.inSeconds.toDouble(),
          onChanged: (double value) {
            seekToSecond(value.toInt());
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        playerButton(),
        slideControls(),
        timeDurationString(context),
      ],
    );
  }
}
