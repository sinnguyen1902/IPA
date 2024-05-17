import 'dart:convert';
import 'dart:io';
import 'package:appcheckin/notify.dart';
import 'package:flutter/material.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Checkin extends StatefulWidget {
  const Checkin({super.key});

  @override
  State<Checkin> createState() => _CheckinState();
}

class _CheckinState extends State<Checkin> {
  String _latitude = '';
  String _longitude = '';
  String _address = '';
  String nameCustomer = '';
  String phoneCustomer = '';

  bool _isSwitched = false;
  XFile? _image;
  Future<void> _captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _address =
          "${place.street}, ${place.subAdministrativeArea},${place.administrativeArea}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    String? userID = UserData.iEmpNo.toString();
    String? nName = UserData.nName.toString();
    String? nDept = UserData.nDept.toString();
    Future<void> checkinProcess() async {
      const String url =
          'http://115.75.88.138:8668/APP-CHECKIN/public/api/Checkin';
      try {
        String? noteDevice = getDevice.idDevice.toString();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['I_EMP_NO'] = userID;
        request.fields['KH_NAME'] = nameCustomer;
        request.fields['ADDRESS'] = _address;
        request.fields['ID_LONG'] = _longitude;
        request.fields['ID_LAT'] = _latitude;
        request.fields['NOTE'] = noteDevice;
        request.fields['PHONE_NUMBER'] = phoneCustomer;
        request.fields['N_DEPT'] = nDept;
        if (_image == null) {
          return showToast('Lỗi: Hãy chụp ảnh địa điểm!');
        }

        request.files
            .add(await http.MultipartFile.fromPath('IMG', _image!.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var data = jsonDecode(responseData);
          if (data.containsKey('False')) {
            String errorMessage = data['False'];
            showToast(errorMessage);
          } else {
            String errorMessage = data['True'];
            showToast(errorMessage);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        } else {
          showToast('Lỗi: ${response.reasonPhrase}');
        }
      } catch (e) {
        showToast('Lỗi: $e');
      }
    }

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('CHẤM CÔNG', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(5),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Nhân Viên :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(nName),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('ID :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(userID),
                                  ),
                                ),
                              ],
                            ),
                            if (nDept != 'NS')
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                      child: Text('Khách Hàng :'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      // padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              nameCustomer = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (nDept != 'NS')
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                      child: Text('SĐT:'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      // padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: TextField(
                                          onChanged: (value) => {
                                            setState(() {
                                              phoneCustomer = value;
                                            })
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                    child: Text('Địa Chỉ :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
                                      child: Text(_address),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                    child: Text('ID LONG :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
                                      child: Text(_longitude),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                    child: Text('ID LAT :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
                                      child: Text(_latitude),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                    child: Text('Hình Ảnh :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
                                      child: Column(
                                        children: <Widget>[
                                          if (_image != null)
                                            Image.file(
                                              File(_image!.path),
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          if (_image == null)
                                            Text(
                                              'Hãy chụp ảnh...',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                                    child: Text('Cập nhật vị trí :'),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    // padding: EdgeInsets.all(8.0),
                                    child: Switch(
                                      value: _isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSwitched = value;
                                        });
                                        if (value == true) {
                                          getLocation();
                                        }
                                      },
                                      activeTrackColor: Colors.red,
                                      activeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFFfef141),
                              backgroundColor:
                                  Colors.red, // Text Color (Foreground color)
                            ),
                            onPressed: _captureImage,
                            child: const Text('Chụp Ảnh'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFFfef141),
                              backgroundColor:
                                  Colors.red, // Text Color (Foreground color)
                            ),
                            onPressed: () {
                              checkinProcess();
                            },
                            child: const Text('Chấm Công'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
