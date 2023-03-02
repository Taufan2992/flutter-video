import 'package:flutter/material.dart';

class PreJoinPage extends StatelessWidget {
  const PreJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 100),
                          child: Image(
                              image:
                                  AssetImage('../../assets/images/logo.png'))),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 60,
                              child: Container(
                                color: Colors.lightBlue[400],
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Column(
                                children: [
                                  Image.asset(
                                    '../../assets/images/prejoin.png',
                                    width: 250,
                                    height: 250,
                                  ),
                                  Padding(padding: EdgeInsets.only()),
                                  Text(
                                      'Anda yakin untuk memulai \nvideo call survey?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 20)),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xffF1F5F9),
                                                padding: EdgeInsets.only(
                                                    top: 20, bottom: 20)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Batal',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff4F81FF),
                                              padding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Mulai Sekarang',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ),
                                      Padding(padding: EdgeInsets.all(20)),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ]))));
  }
}
