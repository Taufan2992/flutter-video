import 'package:flutter/material.dart';
import 'prejoin-page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

final String baseUrl = "http://localhost:5000";
final storage = FlutterSecureStorage();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adira',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<MyHomePage> {
  String? _token;
  // const _LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
      //   title: Image(image: AssetImage('../../assets/images/logo.png')) ,
      // ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image(
                        image: AssetImage('../../assets/images/logo.png')),
                  )),
              Row(
                children: [
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Text("Selamat Datang",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w600)),
                        SizedBox(height: 11),
                        Text("Masukkan Password dan NIK untuk Login"),
                        SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("NIK"),
                            SizedBox(height: 11),
                            Container(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(height: 11),
                            Text("Password"),
                            SizedBox(height: 11),
                            Container(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.visibility_off)),
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const PreJoinPage()),
                                  // );
                                  joinRoom();
                                },
                                child: Text("LOGIN",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFFD213)),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const PreJoinPage()),
                                  // );

                                  connectToRoom();
                                },
                                child: Text("LOGIN",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFFD213)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                  Flexible(
                      child: Container(
                    width: double.infinity,
                    // height: 100,
                    height: MediaQuery.of(context).size.height * 0.63,
                    padding: EdgeInsets.only(left: 10),
                    color: Color.fromARGB(255, 232, 232, 229),
                    child: Image(
                        image: AssetImage('../../assets/images/home.png')),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> joinRoom() async {
    try {
      final response =
          await http.post(Uri.parse('http://localhost:5000/join-room'));

      if (response.statusCode == 200) {
        print(response.body);

        // Parsing JSON dari response.body
        final parsedJson = jsonDecode(response.body);

        // Mendapatkan nilai token dari objek JSON
        final token = parsedJson['token'];
        setState(() {
          _token = token;
        });
        // print(_token);

        // Simpan token ke dalam local storage
        await storage.write(key: 'token', value: token);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Request failed with error: $e.');
    }
  }

  late Room _room;
  final Completer<Room> _completer = Completer<Room>();

  void _onConnected(Room room) {
    print('Connected to ${room.name}');
    _completer.complete(_room);
  }

// void _onConnectFailure(RoomConnectFailureEvent event) {
//   print('Failed to connect to room ${event.room.name} with exception: ${event.exception}');
//   _completer.completeError(event.exception);
// }

  Future<Room> connectToRoom() async {
// Retrieve the camera source of your choosing
    var cameraSources = await CameraSource.getSources();
    var cameraCapturer = CameraCapturer(
      cameraSources.firstWhere((source) => source.isFrontFacing),
    );
// Create a video track.
    // var localVideoTrack = LocalVideoTrack(true, cameraCapturer);

    final accessToken = _token.toString();
    debugPrint('camera: ' + cameraCapturer.toString());
    debugPrint('token: ' + accessToken.toString());

    var connectOptions = ConnectOptions(
      accessToken,
      roomName:
          "roomName", // Optional name for the room                      // Optional region.
      preferredAudioCodecs: [
        OpusCodec()
      ], // Optional list of preferred AudioCodecs
      preferredVideoCodecs: [
        H264Codec()
      ], // Optional list of preferred VideoCodecs.
      // audioTracks: [LocalAudioTrack(true)], // Optional list of audio tracks.
      // dataTracks: [
      //   LocalDataTrack(
      //     DataTrackOptions(
      //       ordered: ordered,                      // Optional, Ordered transmission of messages. Default is `true`.
      //       maxPacketLifeTime: maxPacketLifeTime,  // Optional, Maximum retransmit time in milliseconds. Default is [DataTrackOptions.defaultMaxPacketLifeTime]
      //       maxRetransmits: maxRetransmits,        // Optional, Maximum number of retransmitted messages. Default is [DataTrackOptions.defaultMaxRetransmits]
      //       name: name                             // Optional
      //     ),                                // Optional
      //   ),
      // ],                                    // Optional list of data tracks
      videoTracks: [
        LocalVideoTrack(true, cameraCapturer)
      ], // Optional list of video tracks.
    );

    _room = await TwilioProgrammableVideo.connect(connectOptions);
    print(_room);
    _room.onConnected.listen(_onConnected);
    // var widget = localVideoTrack.widget();

    // _room.onConnectFailure.listen(_onConnectFailure);

    return _completer.future;
  }
}

// class PreJoinPage extends StatelessWidget {
//   const PreJoinPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                           margin: EdgeInsets.only(bottom: 100),
//                           child: Image(
//                               image:
//                                   AssetImage('../../assets/images/logo.png'))),
//                     ]))));
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Demo Text", style: TextStyle(fontSize: 40)),
//         ),
//         body: const Center(
//           child: Text("Hello World",
//               style: TextStyle(
//                   fontSize: 40,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.deepPurple,
//                   backgroundColor: Colors.greenAccent,
//                   fontStyle: FontStyle.italic,
//                   letterSpacing: 5,
//                   wordSpacing: 5,
//                   height: 5)),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
