import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_first_app/model/response/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class TripPage extends StatefulWidget {
  final int idx; // รับค่า id ของ trip ที่เลือก
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<void> loadData;
  late TripIdxGetResponse tripIdxGetResponse;
  String url = '';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync(); // โหลดข้อมูล trip ตอนเริ่มหน้า
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดทริป"),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // โหลดเสร็จแล้ว แสดงข้อมูล
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  tripIdxGetResponse.coverimage,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tripIdxGetResponse.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(tripIdxGetResponse.detail),
                      const SizedBox(height: 16),
                      Text("ราคา: ${tripIdxGetResponse.price.toString()} บาท",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // ปุ่มจองเลย
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 30% ของหน้าจอ,
                    child: FilledButton(
                      onPressed: () {
                        // ตัวอย่าง: แสดง dialog ว่าจองแล้ว
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("การจองสำเร็จ"),
                            content: Text(
                                "คุณได้จองทริป ${tripIdxGetResponse.name} เรียบร้อยแล้ว!"),
                            actions: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("ปิด"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text("จองเลย!"),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

              ],
            ),
          );
        },
      ),
    );
  }

  // ดึงข้อมูล trip จาก API
  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
