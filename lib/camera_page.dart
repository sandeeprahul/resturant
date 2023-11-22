import 'dart:convert';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/AlertUtils.dart';
import 'package:restaurant/employee_model.dart';
import 'package:restaurant/pin_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Employee employee;

  const CameraScreen(this.cameras, this. employee);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
    // checkType();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  final List<String> _tabTitles = ["Start", "Break", "Finish"];
  final int _counter = 0;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16
                ),
                  color: Colors.white,

                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                              width:MediaQuery.of(context).size.width,child: CameraPreview(_controller)),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 18),
                                  child: Image.asset('assets/logosaniel.jpeg',height: 86,width: 86,),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 80,left: 16,right: 16), // Add margins here
                        decoration:  BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),            child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          _tabTitles.length,
                              (index) => GestureDetector(
                            onTap: () async {

                              //start
                              if(widget.employee.type=="0"){
                                setState(() {
                                  _currentIndex = index;
                                });
                                // _takePictureAndSendData(index,"1");

                                checkTypeAndSendData(index,1);//start
                              }
                              //break
                              else if(widget.employee.type=="1"){
                                setState(() {
                                  _currentIndex = index;
                                });
                                if(index==2){
                                  checkTypeAndSendData(index,4);//break
                                }
                                else if(index==1){
                                  checkTypeAndSendData(index,2); //finish

                                }
                              }
                              else if(widget.employee.type=="2"){
                                setState(() {
                                  _currentIndex = index;
                                });
                                checkTypeAndSendData(index,3);//start
                              }else if(widget.employee.type=="4"){

                              }else{

                              }

                            },
                            child:AnimatedContainer(

                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _currentIndex == index ? Colors.white : Colors.transparent,
                              ),
                              child: Text(
                                _tabTitles[index],
                                style: TextStyle(
                                  color: _currentIndex == index ? Colors.blue : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
     /* floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            await _controller.takePicture();
          } catch (e) {
            print(e);
          }
        },
      ),*/
    );
  }

  String responseMessage = '';

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("https://employees.esolutionz.in/api"));

      if (response.statusCode == 200) {
        // Successful response
        Map<String, dynamic> data = json.decode(response.body);
        // Accessing the 'settings' key from the response
        Map<String, dynamic> settings = data['settings'];
        String title = settings['title'];
        setState(() {
          responseMessage = 'Title: $title\nStatus Code: ${response.statusCode}';
        });
      } else {
        // Handle other status codes (e.g., 400)
        setState(() {
          responseMessage = 'Error: ${response.statusCode}';
        });
      }
    } on http.ClientException catch (e) {
      // Handle internet connectivity issues
      setState(() {
        responseMessage = 'Error: $e';
      });
    } catch (e) {
      setState(() {
        responseMessage = 'Error: $e';
      });
    }
  }

  Future<void> _takePictureAndSendData(int index,int typee) async {
    try {
      await _initializeControllerFuture;
      final XFile pictureFile = await _controller.takePicture();

      // type
      await sendData(index,pictureFile,typee);

   /*   if(_tabTitles[index]=="Start"){
        setState(() {
          type = 1;
        });
      }else if(_tabTitles[index]=="Break"){
        await sendData(index,pictureFile,2);
        setState(() {
          type = 2;
        });
      }
      else if(_tabTitles[index]=="Finish"){
        await sendData(index,pictureFile,4);
        setState(() {
          type = 3;
        });
      }*/
      // else if(type==3 && _tabTitles[index]=="Start"){
      //   await sendData(index,pictureFile,3);
      //   setState(() {
      //     type = 0;
      //   });
      // }
      // Now, you can send the file to the API

    } catch (e) {
      print(e);
    }
  }



  Future<void> sendData(int index, XFile pictureFile, int type) async {
    try {


      DateTime now = DateTime.now();
      // Replace this URL with your API endpoint
      const String apiUrl = "https://employees.esolutionz.in/api/submit";

      // You might need to adjust the headers based on your API requirements
      final Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
      };

      // Create a `http.MultipartRequest`
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add your parameters to the request
      request.fields['emp_id'] = widget.employee.id; // replace with your parameters
      request.fields['emp_pin'] = widget.employee.empPin; // replace with your parameters
      // request.fields['type'] = "3"; // replace with your parameters
      request.fields['type'] = "$type"; // replace with your parameters
      request.fields['time'] = "$now"; // replace with your parameters

      // Read the bytes of the image file
      List<int> pictureBytes = await pictureFile.readAsBytes();

      // Add the picture bytes to the request
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          pictureBytes,
          filename: 'image.jpg', // adjust the filename based on your needs
          contentType: MediaType('image', 'jpg'), // adjust the content type based on your needs
        ),
      );

      print("Request prams ->${request.fields}");
      print("Request prams ->${request.files}");
      print("Request prams ->${request.toString()}");
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print("File sent successfully");
        print("${response.toString()}");
        print("${response}");
        // AlertUtils.showAlert(context, 'Alert', 'Submit success');
     /*   Get.defaultDialog(
          title: 'Alert!',
          middleText: 'Success',
        );*/
        // Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PinPasswordPage(widget.cameras)),
        );
        // Handle the response if needed
      } else {
      /*  Get.defaultDialog(
          title: 'Alert',
          middleText: 'Error sending file. Status Code: ${response.statusCode}',
        );*/
        print("Error sending file. Status Code: ${response.statusCode}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PinPasswordPage(widget.cameras)),
        );
        // Handle the error response if needed
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Alert',
        middleText:  'Error sending file: $e',
      );
      print("Error sending file: $e");
      // Handle other errors if needed
    }
  }



  Future<void> checkTypeAndSendData(int index,int type) async {

    _takePictureAndSendData(index,type);
  }


}
