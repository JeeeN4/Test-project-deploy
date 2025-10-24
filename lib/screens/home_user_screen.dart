import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:project_capstone_1/widgets/navbar_widget.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  // DUMMY DATA
  final double berat = 55; // kg
  final double tinggi = 160; // cm
  final int usia = 21; // tahun
  final String gender = "wanita";
  final String aktivitas = "sedang"; // sedentari, ringan, sedang, berat, sangat berat

  final double konsumsiGula = 36; // gram
  final double targetGula = 50; // gram

  final List<Map<String, dynamic>> foodLog = [
    {"nama": "2025-02-01", "kalori": 250, "image": "images/illustrations/nutrition-fact-dummy.png"},
    {"nama": "2025-12-17", "kalori": 150, "image": "images/illustrations/nutrition-fact-dummy.png"},
  ];

  final List<double> trenGulaMingguan = [40, 50, 55, 60, 45, 70, 65]; // dummy data (g)

  // Nutrisi harian (contoh: sudah dikonsumsi / target)
  final Map<String, Map<String, double>> nutrisi = {
    "Carbs": {"consumed": 150, "target": 250},
    "Protein": {"consumed": 60, "target": 80},
    "Natrium": {"consumed": 1200, "target": 2300},
    "Fat": {"consumed": 45, "target": 70},
    "Sugar": {"consumed": 36, "target": 50},
  };

  // ===================== PERHITUNGAN =====================
  double hitungBMR() {
    if (gender == "pria") {
      return (10 * berat) + (6.25 * tinggi) - (5 * usia) + 5;
    } else {
      return (10 * berat) + (6.25 * tinggi) - (5 * usia) - 161;
    }
  }

  double getActivityFactor(String aktivitas) {
    switch (aktivitas.toLowerCase()) {
      case "sedentari":
        return 1.2;
      case "ringan":
        return 1.375;
      case "sedang":
        return 1.55;
      case "berat":
        return 1.725;
      case "sangat berat":
        return 1.9;
      default:
        return 1.55;
    }
  }

  String getWeeklyTrendMessage(List<double> data, double target) {
    double avg = data.reduce((a, b) => a + b) / data.length;
    if (avg < target * 0.8) {
      return "Konsumsi gulamu masih di bawah target, tetap jaga asupan seimbang!";
    } else if (avg <= target) {
      return "Konsumsi gulamu sudah baik minggu ini, pertahankan ya!";
    } else {
      return "Konsumsi gulamu melebihi batas! Kurangi minuman dan camilan manis.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bmr = hitungBMR();
    final double tdee = bmr * getActivityFactor(aktivitas);
    final double persenGula = konsumsiGula / targetGula;
    final String pesanTren = getWeeklyTrendMessage(trenGulaMingguan, targetGula);

    return Scaffold(
      backgroundColor: const Color(0xFFFBE19D),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // ========== GULA HARI INI ==========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sisa gula hari ini",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0F1724)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${(targetGula - konsumsiGula).toStringAsFixed(1)} g",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text("Target ${targetGula.toStringAsFixed(0)} g"),
                          Text("Terkonsumsi ${konsumsiGula.toStringAsFixed(0)} g"),
                        ],
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 45,
                      lineWidth: 8,
                      percent: persenGula.clamp(0.0, 1.0),
                      progressColor: const Color(0xFF0F5BCA),
                      backgroundColor: Colors.grey.shade200,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("${(persenGula * 100).toStringAsFixed(0)}%"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========== NUTRITION TRACKING ==========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nutrition Tracking",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F1724)),
                    ),
                    const SizedBox(height: 12),
                    ...nutrisi.entries.map((entry) {
                      final label = entry.key;
                      final consumed = entry.value["consumed"]!;
                      final target = entry.value["target"]!;
                      final percent = (consumed / target).clamp(0.0, 1.0);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearPercentIndicator(
                                lineHeight: 8,
                                percent: percent,
                                progressColor: Colors.blueAccent,
                                backgroundColor: Colors.grey.shade200,
                                barRadius: const Radius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}"),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========== TREN GULA MINGGUAN ==========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tren Gula Mingguan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F1724)),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: BarChart(
                        BarChartData(
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: value == targetGula
                                  ? Colors.redAccent
                                  : Colors.grey.shade300,
                              strokeWidth:
                                  value == targetGula ? 2 : 0.5,
                              dashArray: value == targetGula ? [6, 6] : null,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  const days = [
                                    "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
                                  ];
                                  return Text(days[value.toInt() % 7]);
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          barGroups: List.generate(trenGulaMingguan.length, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: trenGulaMingguan[i],
                                  color: Colors.blueAccent,
                                  width: 14,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========== PESAN TREN ==========
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8D6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        pesanTren,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========== FOOD LOG ==========
              const Text(
                "Today's Food Log",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0F1724)),
              ),
              const SizedBox(height: 10),

              Column(
                children: foodLog.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item["image"],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["nama"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Kalori: ${item["kalori"]} kcal",
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
