import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'tirp.dart';

class Showtrippage extends StatefulWidget {
  final int cid; // 👈 เพิ่มตัวแปรรับค่าผ้ใช้
  const Showtrippage({super.key, required this.cid});


  @override
  State<Showtrippage> createState() => _ShowtrippageState();
}

class _ShowtrippageState extends State<Showtrippage> {
  String url = '';

  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> tripGetShow = [];

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // Configuration.getConfig().then((config) {
    //   url = config['apiEndpoint'];
    //   getTrips();
    // });
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('รายการทริป'),
  automaticallyImplyLeading: false,
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(idx: widget.cid),
            ),
          );
        } else if (value == 'logout') {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('ข้อมูลส่วนตัว'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('ออกจากระบบ'),
        ),
      ],
    ),
  ],
),
      body:
          //load data from API
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                //waiting
                return Center(child: CircularProgressIndicator());
              }
              //done
              return Column(
                children: [
                  // ✅ ปุ่มแนวนอน (ล็อกอยู่บนสุด)
                  Container(
                    color: Colors.white, // ใส่พื้นหลังให้ชัดเจน
                    padding: const EdgeInsets.all(10.0),

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: getTrips,
                            child: const Text('ทั้งหมด'),
                          ),

                          SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              List<TripGetResponse> asiaTrips = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'เอเชีย') {
                                  asiaTrips.add(trip);
                                }
                              }
                              setState(() {
                                tripGetShow = asiaTrips;
                              });
                            },
                            child: const Text('เอเชีย'),
                          ),

                          SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              List<TripGetResponse> euroTrips = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'ยุโรป') {
                                  euroTrips.add(trip);
                                }
                              }
                              setState(() {
                                tripGetShow = euroTrips;
                              });
                            },
                            child: const Text('ยุโรป'),
                          ),

                          SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              List<TripGetResponse> arsianTrips = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone ==
                                    'เอเชียตะวันออกเฉียงใต้') {
                                  arsianTrips.add(trip);
                                }
                              }
                              setState(() {
                                tripGetShow = arsianTrips;
                              });
                            },
                            child: const Text('อาเซียน'),
                          ),

                          SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              List<TripGetResponse> thaiTrips = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'ประเทศไทย') {
                                  thaiTrips.add(trip);
                                }
                              }
                              setState(() {
                                tripGetShow = thaiTrips;
                              });
                            },
                            child: const Text('ประเทศไทย'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ เนื้อหาที่เลื่อนแนวตั้ง
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: tripGetShow.map((e) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(
                              12.0,
                            ), // 👈 เหมือน padding ด้านนอก
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 233, 254),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.country),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          e.coverimage,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.4,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return SizedBox(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.4,
                                                  height: 100,
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                                );
                                              },
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          // ✅ ป้องกันเนื้อหาด้านขวาล้นจอ
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('ประเทศ ${e.country}'),
                                              Text(
                                                'ระยะเวลา ${e.duration} วัน',
                                              ),
                                              Text('ราคา ${e.price} บาท'),
                                              SizedBox(height: 8),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TripPage(
                                                            idx: e.idx,
                                                          ), // ส่ง idx ไป
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'รายละเอียดเพิ่มเติม',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        // children: [
                        //   // รายละเอียดต่าง ๆ
                        //   Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Container(
                        //       padding: const EdgeInsets.all(10.0),
                        //       decoration: BoxDecoration(
                        //         color: Color(0xFFF9CEF6),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text('กรุงเทพ'),
                        //           SizedBox(height: 8),
                        //           Row(
                        //             children: [
                        //               Image.asset(
                        //                 'assets/images/pepe1.jpg',
                        //                 width: MediaQuery.of(context).size.width * 0.4,
                        //                 height: 100,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //               SizedBox(width: 8),
                        //               Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('ประเทศไทย'),
                        //                   Text('ระยะเวลา 10 วัน'),
                        //                   Text('ราคา 999 บาท'),
                        //                   SizedBox(height: 8),
                        //                   FilledButton(
                        //                     onPressed: () {},
                        //                     child: const Text('รายละเอียดเพิ่มเติม'),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    tripGetResponses = tripGetResponseFromJson(res.body);
    // setState(() {
    //   tripGetResponses = tripGetResponseFromJson(res.body);
    // });
    log(tripGetResponses.length.toString());
    setState(() {
      tripGetShow = tripGetResponses;
    });
  }
}
