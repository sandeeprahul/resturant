import 'dart:convert';

import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/AlertUtils.dart';
import 'package:restaurant/camera_page.dart';
import 'package:restaurant/employee_model.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/main.dart';

import 'constants.dart';





class PinPasswordPage extends StatefulWidget {
final  List<CameraDescription> cameras;
  const PinPasswordPage(this.cameras, {super.key});

  @override
  _PinPasswordPageState createState() => _PinPasswordPageState();
}

class _PinPasswordPageState extends State<PinPasswordPage> {
  String enteredNumber = '';

  void _onNumberPressed(String number) {

    if(enteredNumber.length==4){
      loginUser(enteredNumber);
    }else {
      setState(() {
        enteredNumber += number;
      });
    }
  }

  void _clearNumber() {
    setState(() {
      enteredNumber = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Login'),
      ),
      body:loading?const Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Please wait'),
          ),
          SizedBox(height: 8,),
          CircularProgressIndicator(),
        ],
      ): Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              enteredNumber==""?  "Enter Pin ":enteredNumber,

              style: const TextStyle(fontSize: 28,),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton('1', _onNumberPressed),
                NumberButton('2', _onNumberPressed),
                NumberButton('3', _onNumberPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton('4', _onNumberPressed),
                NumberButton('5', _onNumberPressed),
                NumberButton('6', _onNumberPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton('7', _onNumberPressed),
                NumberButton('8', _onNumberPressed),
                NumberButton('9', _onNumberPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.backspace,size: 34,),
                  onPressed: _clearNumber,
                ),
                SizedBox(width: 75,),
                NumberButton('0', _onNumberPressed),
                SizedBox(width: 75,),

                IconButton(
                  icon: const Icon(Icons.check_circle,color: Colors.green,size: 34,),
                  onPressed: (){
                    if(enteredNumber.length==4){
                      loginUser(enteredNumber);
                    }
                    else{
                      AlertUtils.showAlert(context, 'Alert', 'Incorrect PIN');

                    }
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }



 String  responseMessage = "";
  bool loading = false;
  // import 'package:http/http.dart' as http;

  Future<Employee?> loginUser(String value) async {
    try {
      setState(() {
        loading = true;
      });

      var url = Uri.parse("${Constants.apiHttpsUrl}/employee/$value");
      // var url =
 
      // var response = await http.get(url);
      var response = await http.get(
        url,

      );
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        print("success response = "+response.toString());

        Map<String, dynamic> data = json.decode(response.body);
        Employee employee = Employee.fromJson(data);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraScreen(widget.cameras, employee)),
        );

        return employee;
      } else {
        setState(() {
          loading = false;
          enteredNumber = "";
          responseMessage = 'Error: ${response.statusCode}';
        });

        AlertUtils.showAlert(context, 'Alert', 'Error: Incorrect PIN');

        return null;
      }
    } on http.ClientException catch (e) {
      print("Error: $e");
      AlertUtils.showAlert(context, 'Alert', 'Error: $e');

      setState(() {
        loading = false;
        enteredNumber = "";
        responseMessage = 'Error: $e';
      });
      return null;
    } catch (e) {
      print("Error: $e");
      // AlertUtils.showAlert(context, 'Alert', 'Error: $e');
      AlertUtils.showAlert(context, 'Alert', 'Error: Incorrect PIN');

      setState(() {
        loading = false;
        enteredNumber = "";
        responseMessage = 'Error: $e';
      });
      return null;
    }
  }
  // String responseMessage = '';

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(Constants.apiHttpsUrl));

      if (response.statusCode == 200) {
        print("fetchData->$response");
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
        print("fetchData->Error: ${response.statusCode}");

      }
    } on http.ClientException catch (e) {
      print("fetchData-> Error: $e");

      // Handle internet connectivity issues
      setState(() {
        responseMessage = 'Error: $e';
      });
    } catch (e) {
      print("fetchData-> Error: $e");

      setState(() {
        responseMessage = 'Error: $e';
      });
    }
  }


}

class NumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;

  NumberButton(this.number, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          // Set height and width using fixed dimensions or SizedBox
          minimumSize: MaterialStateProperty.all<Size>(
            Size(150, 100), // Replace with desired height and width
          ),
          // Other button style properties can be added here as needed
          // For example: backgroundColor, padding, textStyle, etc.
        ),
        onPressed: () => onPressed(number),
        child: Text(number,style: const TextStyle(fontSize: 18),),
      ),
    );
  }
}
