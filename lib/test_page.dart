// ignore_for_file: unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final speedNotifier = ValueNotifier<double>(10);
  final key = GlobalKey<KdGaugeViewState>();
  final key2 = GlobalKey<KdGaugeViewState>();
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  bool _isServerSelectionInProgress = false;
  String _testType = "0";

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  double _anlikVeri = 0;
  double _yuzde = 0; // Başlangıçta anlık veriyi 0 olarak ayarlayın
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Opacity(
                  opacity: _testType == "0" ? 0 : 1,
                  child: Text(
                    _testType,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Container(
                      width: 370,
                      height: 370,
                      padding: const EdgeInsets.all(10),
                      child: ValueListenableBuilder<double>(
                          valueListenable: speedNotifier,
                          builder: (context, value, child) {
                            return KdGaugeView(
                              gaugeWidth: 1,
                              key: key2,
                              minSpeed: 0,
                              maxSpeed: 100,
                              speed: 0,
                              animate: true,
                              divisionCircleColors: Colors.transparent,
                              subDivisionCircleColors: Colors.transparent,
                              activeGaugeColor: Colors.orange,
                              inactiveGaugeColor: Colors.orange,
                              duration: const Duration(seconds: 6),
                              speedTextStyle: const TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                              unitOfMeasurementTextStyle: const TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              minMaxTextStyle: const TextStyle(
                                  fontSize: 20, color: Colors.transparent),
                              fractionDigits: 1,
                            );
                          }),
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    padding: const EdgeInsets.all(10),
                    child: ValueListenableBuilder<double>(
                        valueListenable: speedNotifier,
                        builder: (context, value, child) {
                          return KdGaugeView(
                              key: key,
                              minSpeed: 0,
                              maxSpeed: 100,
                              speed: 0,
                              animate: true,
                              divisionCircleColors: Colors.red,
                              subDivisionCircleColors: Colors.red,
                              activeGaugeColor: Colors.red,
                              inactiveGaugeColor: Colors.white,
                              duration: const Duration(seconds: 6),
                              speedTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                              unitOfMeasurementTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              minMaxTextStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              fractionDigits: 1,
                              unitOfMeasurement: _unitText);
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _isServerSelectionInProgress
                      ? 'Selecting Server...'
                      : 'IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  // ignore: unnecessary_null_comparison
                  _downloadRate != 0
                      ? "Download Speed: ${_downloadRate.toStringAsFixed(2)}"
                      : "Download Speed: --",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  // ignore: unnecessary_null_comparison
                  _uploadRate != 0
                      ? "Upload Speed: ${_uploadRate.toStringAsFixed(2)}"
                      : "Upload Speed: --",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (!_testInProgress) ...{
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: const Text(
                    'Start Testing',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    reset();
                    await internetSpeedTest.startTesting(onStarted: () {
                      setState(() => _testInProgress = true);
                    }, onCompleted: (TestResult download, TestResult upload) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                      }
                      setState(() {
                        _downloadRate = download.transferRate;
                        _unitText =
                            download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadProgress = '100';
                        _downloadCompletionTime = download.durationInMillis;
                      });
                      setState(() {
                        _uploadRate = upload.transferRate;
                        _unitText =
                            upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadProgress = '100';
                        _uploadCompletionTime = upload.durationInMillis;
                        _testInProgress = false;
                        _testType = "Test Finished";
                      });
                    }, onProgress: (double percent, TestResult data) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate $data.transferRate, the percent $percent');
                      }
                      setState(() {
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        if (data.type == TestType.download) {
                          _testType = "Download Testing";
                          _downloadRate = data.transferRate;
                          _downloadProgress = percent.toStringAsFixed(2);

                          ///ben yazdım
                          _anlikVeri = _downloadRate;
                          key.currentState!.updateSpeed(_anlikVeri);
                          _yuzde = double.parse(_downloadProgress);
                          key2.currentState!.updateSpeed(_yuzde);
                        } else {
                          _uploadRate = data.transferRate;
                          _uploadProgress = percent.toStringAsFixed(2);
                          _yuzde = double.parse(_uploadProgress);
                          key2.currentState!.updateSpeed(_yuzde);

                          ///ben yazdım
                          _anlikVeri = _uploadRate;
                          key.currentState!.updateSpeed(_anlikVeri);
                          _testType = "Upload Testing";
                        }
                      });
                    }, onError: (String errorMessage, String speedTestError) {
                      if (kDebugMode) {
                        print(
                            'the errorMessage $errorMessage, the speedTestError $speedTestError');
                      }
                      alertDialog(errorMessage);
                      reset();
                    }, onDefaultServerSelectionInProgress: () {
                      setState(() {
                        _isServerSelectionInProgress = true;
                      });
                    }, onDefaultServerSelectionDone: (Client? client) {
                      setState(() {
                        _isServerSelectionInProgress = false;
                        _ip = client?.ip;
                        _asn = client?.asn;
                        _isp = client?.isp;
                      });
                    }, onDownloadComplete: (TestResult data) {
                      setState(() {
                        _downloadRate = data.transferRate;
                        //_testType = "Upload";
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadCompletionTime = data.durationInMillis;
                      });
                    }, onUploadComplete: (TestResult data) {
                      setState(() {
                        _testType = "Test Finished";
                        _uploadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadCompletionTime = data.durationInMillis;
                        _anlikVeri = 0;
                        key.currentState!.updateSpeed(_anlikVeri);
                        _yuzde = 0;
                        key2.currentState!.updateSpeed(_yuzde);
                      });
                    }, onCancel: () {
                      reset();
                    });
                  },
                )
              } else ...{
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: () => internetSpeedTest.cancelTest(),
                  icon: const Icon(Icons.cancel_rounded, color: Colors.white),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              },
              SizedBox(
                height: MediaQuery.of(context).size.height > 655
                    ? MediaQuery.of(context).size.height - 655
                    : 20,
              ),
              const Text(
                "© 2024 fivehub.com",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      {
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _downloadProgress = '0';
        _uploadProgress = '0';
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;
        _isServerSelectionInProgress = false;
        _testType = "0";

        _ip = null;
        _asn = null;
        _isp = null;

        _unitText = 'Mbps';

        _anlikVeri = 0;
        _yuzde = 0;
        key.currentState!.updateSpeed(_anlikVeri);

        key2.currentState!.updateSpeed(_yuzde);
      }
    });
  }

  alertDialog(String icerik) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "An Error Occurred",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  icerik,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text(
                  "Okey",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
