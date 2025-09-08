import 'package:app_demo/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _dailyController = TextEditingController();
  final TextEditingController _smallController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  double _dailyExpense = 0.0;
  double _smallExpense = 0.0;
  double _income = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    double daily = await LocalStorageService.getTransaction(
        widget.username, 'dailyExpense');
    double small = await LocalStorageService.getTransaction(
        widget.username, 'smallExpense');
    double income =
        await LocalStorageService.getTransaction(widget.username, 'income');

    setState(() {
      _dailyExpense = daily;
      _smallExpense = small;
      _income = income;
    });
  }

  Future<void> _updateTransaction(
      {required String key, required double value}) async {
    await LocalStorageService.saveTransaction(widget.username, key, value);
    _loadData();
  }

  void _addDailyExpense() {
    double value = double.tryParse(_dailyController.text) ?? 0.0;
    _dailyExpense += value;
    _updateTransaction(key: 'dailyExpense', value: _dailyExpense);
    _dailyController.clear();
  }

  void _addSmallExpense() {
    double value = double.tryParse(_smallController.text) ?? 0.0;
    _smallExpense += value;
    _updateTransaction(key: 'smallExpense', value: _smallExpense);
    _smallController.clear();
  }

  void _addIncome() {
    double value = double.tryParse(_incomeController.text) ?? 0.0;
    _income += value;
    _updateTransaction(key: 'income', value: _income);
    _incomeController.clear();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard - ${widget.username}"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ingresos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _incomeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Agregar ingreso",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _addIncome, child: const Text("Agregar")),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Gastos Diarios",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dailyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Agregar gasto diario",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _addDailyExpense, child: const Text("Agregar")),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Gastos Hormiga",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _smallController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Agregar gasto hormiga",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _addSmallExpense, child: const Text("Agregar")),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Resumen Financiero",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Ingresos: \$${_income.toStringAsFixed(2)}"),
                    Text(
                        "Gastos diarios: \$${_dailyExpense.toStringAsFixed(2)}"),
                    Text(
                        "Gastos hormiga: \$${_smallExpense.toStringAsFixed(2)}"),
                    Text(
                        "Balance: \$${(_income - _dailyExpense - _smallExpense).toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Gráfica de Gastos e Ingresos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (_income > (_dailyExpense + _smallExpense)
                          ? _income
                          : (_dailyExpense + _smallExpense)) +
                      50,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Ingresos');
                            case 1:
                              return const Text('Gastos diarios');
                            case 2:
                              return const Text('Gastos hormiga');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: _income, color: Colors.green)
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: _dailyExpense, color: Colors.red)
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                            toY: _smallExpense, color: Colors.orange)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
