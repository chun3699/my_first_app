import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/registerRequest.dart';
import 'package:my_first_app/pages/login.dart';
import 'package:http/http.dart' as http;

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  String phoneNo = '';
  TextEditingController nameCtl = TextEditingController();
  TextEditingController eamilCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController passwordSSCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body:
          // FilledButton(onPressed: back, child: const Text('FilledButton')),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            // child: Container(
            // color: Colors.amber,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อ-นามสกุล',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        TextField(
                          controller: nameCtl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
                          'อีเมล์',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        TextField(
                          controller: eamilCtl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
                          'ยืนยันรหัสผ่าน',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        TextField(
                          controller: passwordSSCtl,
                          obscureText: true, // ✅ ใส่บรรทัดนี้เพื่อแสดงเป็นจุด
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FilledButton(
                      onPressed: register,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          200,
                          50,
                        ), // กำหนดความกว้าง 200 และความสูง 50
                      ),
                      child: const Text('สมัครสมาชิก'),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Colors.black, // เปลี่ยนสีตัวอักษรเป็นสีดำ
                          ),
                          child: const Text('หากมีบัญชีอยู่แล้ว?'),
                        ),
                        TextButton(
                          onPressed: login,
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ),
          ),
    );
  }

  void login() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void register() {
  String password = passwordCtl.text.trim();
  String confirmPassword = passwordSSCtl.text.trim();

  if (password != confirmPassword) {
    // แสดง Alert หรือ Snackbar แจ้งผู้ใช้
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('รหัสผ่านไม่ตรงกัน'),
        backgroundColor: Colors.red,
      ),
    );
    return; // หยุดไม่ให้ไปต่อ
  }

  // ถ้ารหัสผ่านตรงกัน → ดำเนินการสมัครสมาชิก
  RegisterRequest req = RegisterRequest(
    fullname: nameCtl.text,
    phone: phoneNoCtl.text,
    email: eamilCtl.text,
    password: password,
    image: "", 
  );

  http
      .post(
        Uri.parse("$url/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerRequestToJson(req),
      )
      .then((value) {
        log(value.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

        // TODO: ไปหน้าอื่น หรือแจ้งเตือนสำเร็จ
      })
      .catchError((error) {
        log('Error $error');
      });
  }

  void back() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
