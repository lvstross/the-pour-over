import 'dart:core';
import 'rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    Key? key,
    required this.url,
    required this.onClose,
  }) : super(key: key);

  final String url;
  final VoidCallback onClose;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 275),
    vsync: this,
  )..forward();

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 1.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  Duration? _duration = const Duration();
  Duration? _position = const Duration();
  String _currentUrl = '';
  bool _isPlaying = false;
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
    _controller.dispose();
  }

  void cycleNextAudio() async {
    if (_isPlaying) {
      await audioPlayer.stop();
    }
    setState(() {
      _duration = const Duration();
      _position = const Duration();
      _isPlaying = false;
    });
    play();
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
      if (_processingState == ProcessingState.completed) {
        seekToSecond(0);
        pause();
      }
      setState(() {
        _position = state;
      });
    });

    audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        _isPlaying = state.playing;
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
    setState(() {
      _isPlaying = true;
    });
  }

  void pause() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
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
      width: 50,
      height: 50,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: [Colors.grey],
        strokeWidth: 1,
      ),
    );
  }

  Widget playButton(BuildContext context) {
    switch (_processingState) {
      case ProcessingState.idle:
        return spinner();
      case ProcessingState.buffering:
        return spinner();
      default:
        return RoundedButton(
          onPress: play,
          size: 50,
          child: Icon(
            Icons.play_arrow,
            size: 30,
            color: Theme.of(context).colorScheme.background,
          ),
        );
    }
  }

  Widget pauseButton(BuildContext context) {
    switch (_processingState) {
      case ProcessingState.idle:
        return spinner();
      case ProcessingState.buffering:
        return spinner();
      default:
        return RoundedButton(
          onPress: pause,
          size: 50,
          child: Icon(
            Icons.pause,
            size: 30,
            color: Theme.of(context).colorScheme.background,
          ),
        );
    }
  }

  Widget playerButton(BuildContext context) {
    return _isPlaying ? pauseButton(context) : playButton(context);
  }

  Widget timeDurationString(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        '${_position.toString().substring(2, 7)} / ${_duration.toString().substring(2, 7)}',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget slideControls() {
    return SizedBox(
      width: 175,
      child: Slider(
        value: _position!.inSeconds.toDouble(),
        min: 0.0,
        max: _duration!.inSeconds.toDouble(),
        onChanged: (double value) {
          seekToSecond(value.toInt());
        },
        onChangeStart: (_) {
          pause();
        },
        onChangeEnd: (_) {
          play();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url != _currentUrl) {
      cycleNextAudio();
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              playerButton(context),
              slideControls(),
              timeDurationString(context),
              RoundedButton(
                  onPress: () => widget.onClose(),
                  size: 30,
                  child: Icon(
                    Icons.close,
                    size: 15,
                    color: Theme.of(context).colorScheme.background,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
