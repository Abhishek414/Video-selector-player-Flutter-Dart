import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File _video;

  VideoPlayerController _videoPlayerController;


  // This funcion will helps you to pick a Video File
  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                if(_video != null)
                  _videoPlayerController.value.initialized
                      ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(_videoPlayerController),
                        Positioned(
                          bottom: 5,
                            child: FloatingActionButton(
                              onPressed: () {
                                // Wrap the play or pause in a call to `setState`. This ensures the
                                // correct icon is shown
                                setState(() {
                                  // If the video is playing, pause it.
                                  if (_videoPlayerController.value.isPlaying) {
                                    _videoPlayerController.pause();
                                  } else {
                                    // If the video is paused, play it.
                                    _videoPlayerController.play();
                                  }
                                });
                              },
                              // Display the correct icon depending on the state of the player.
                              child: Icon(
                                _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                            )
                        )
                      ],
                    )
                  )
                      : Container()
                else
                  Text("Click to select a video", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickVideo();
                  },
                  child: Text("Pick Video From Gallery"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}