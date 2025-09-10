import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/customer_idx_get_res.dart';

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomerIdxGetResponse customer;
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customer = customerIdxGetResponseFromJson(res.body);
    nameCtl.text = customer.fullname;
    phoneCtl.text = customer.phone;
    emailCtl.text = customer.email;
    imageCtl.text = customer.image;
  }

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var json = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };

    try {
      var res = await http.put(Uri.parse('$url/customers/${widget.idx}'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      var result = jsonDecode(res.body);
      log(result['message']);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ปิด')),
          ],
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกไม่สำเร็จ: $err'),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ปิด')),
          ],
        ),
      );
    }
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('ปิด'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: const Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (_) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ปิด')),
                          FilledButton(
                              onPressed: delete, child: const Text('ยืนยัน')),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(imageCtl.text, width: 150, errorBuilder:
                    (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 150);
                }),
                const SizedBox(height: 16),
                _buildField('ชื่อ-นามสกุล', nameCtl),
                _buildField('เบอร์โทรศัพท์', phoneCtl),
                _buildField('อีเมล', emailCtl),
                _buildField('URL รูปภาพ', imageCtl),
                const SizedBox(height: 20),
                FilledButton(onPressed: update, child: const Text('บันทึกข้อมูล'))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(controller: ctl),
        ],
      ),
    );
  }
}
