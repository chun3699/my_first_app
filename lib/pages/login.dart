// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';

import 'package:my_first_app/pages/RegisterPage.dart';
import 'package:my_first_app/pages/ShowTripPage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String text = 'This is my text';
  int numC = 0;
  String phoneNo = '';
  String password = '';

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      log('URL loaded: $url');
    });
  }
 
//   @override
// void initState() {
//   super.initState();
//   Configuration.getConfig().then((config) {
//     setState(() {
//       url = config['apiEndpoint'] ?? '';
//       print('✅ URL loaded: $url');
//     });
//   }).catchError((error) {
//     print('❌ Failed to load config: $error');
//   });
// }

  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ปรับขนาดเมื่อคีย์บอร์ดขึ้น
      appBar: AppBar(title: const Text('Login Page')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        // child: Container(
        // color: Colors.amber,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมายเลขโทรศัพท์',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    TextField(
                      controller: phoneNoCtl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          10,
                        ), // จำกัดให้กรอกได้แค่ 10 ตัวอักษร
                      ],
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => phoneNo = value,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รหัสผ่าน',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    TextField(
                      controller: passwordCtl,
                      obscureText: true, // ✅ ใส่บรรทัดนี้เพื่อแสดงเป็นจุด
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => password = value,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: register,
                      child: const Text('ลงทะเบียนใหม่'),
                    ),
                    FilledButton(
                      onPressed: () {
                        login(phoneNo, password);
                      },
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),
              ),

              // Text(text, style: TextStyle(fontSize: 20)),
            ],
          ),
        ),

        // ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registerpage()),
    );
  }

  void login(String phone, String password) {
    // var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    http
        .post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Showtrippage(cid: customerLoginPostResponse.customer.idx,)),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
