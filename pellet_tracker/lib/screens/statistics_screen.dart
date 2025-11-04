import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/statistics.dart';
import '../services/storage_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StorageService? _storageService;
  PelletStatistics? _statistics;
  List<PelletTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _storageService = await StorageService.init();
    _statistics = _storageService!.calculateStatistics();
    _transactions = _storageService!.loadTransactions();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStockOverview(),
                    const SizedBox(height: 24),
                    _buildConsumptionChart(),
                    const SizedBox(height: 24),
                    _buildMonthlyComparison(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStockOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vue d\'ensemble',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: _statistics?.currentStock ?? 1,
                      title: 'Stock\nrestant',
                      color: Colors.green,
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: _statistics?.totalConsommation ?? 1,
                      title: 'Consommé',
                      color: Colors.orange[700],
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  'Stock restant',
                  '${(_statistics?.currentStock ?? 0).toStringAsFixed(0)} kg',
                  Colors.green,
                ),
                _buildLegendItem(
                  'Consommé',
                  '${(_statistics?.totalConsommation ?? 0).toStringAsFixed(0)} kg',
                  Colors.orange[700]!,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${(_statistics?.usagePercentage ?? 0).toStringAsFixed(1)}% utilisé',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConsumptionChart() {
    if (_transactions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Grouper les consommations par mois
    final Map<String, double> monthlyConsumption = {};

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.consommation) {
        final monthKey = DateFormat('MM/yyyy').format(transaction.date);
        monthlyConsumption[monthKey] =
            (monthlyConsumption[monthKey] ?? 0) + transaction.quantity;
      }
    }

    if (monthlyConsumption.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedMonths = monthlyConsumption.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MM/yyyy').parse(a);
        final dateB = DateFormat('MM/yyyy').parse(b);
        return dateA.compareTo(dateB);
      });

    // Prendre les 6 derniers mois
    final recentMonths = sortedMonths.length > 6
        ? sortedMonths.sublist(sortedMonths.length - 6)
        : sortedMonths;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consommation mensuelle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (monthlyConsumption.values.reduce((a, b) => a > b ? a : b) * 1.2),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final monthKey = recentMonths[group.x.toInt()];
                        return BarTooltipItem(
                          '$monthKey\n${rod.toY.toStringAsFixed(0)} kg',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < recentMonths.length) {
                            final monthKey = recentMonths[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthKey,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    recentMonths.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: monthlyConsumption[recentMonths[index]] ?? 0,
                          color: Colors.orange[700],
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyComparison() {
    final currentMonth = _storageService?.getCurrentMonthTransactions() ?? [];

    double currentMonthConsumption = 0;
    double currentMonthAchats = 0;

    for (var transaction in currentMonth) {
      if (transaction.type == TransactionType.consommation) {
        currentMonthConsumption += transaction.quantity;
      } else {
        currentMonthAchats += transaction.quantity;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mois en cours (${DateFormat('MMMM yyyy', 'fr_FR').format(DateTime.now())})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildMonthStat(
                    'Achats',
                    currentMonthAchats,
                    Icons.add_shopping_cart,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMonthStat(
                    'Consommation',
                    currentMonthConsumption,
                    Icons.local_fire_department,
                    Colors.orange[700]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthStat(String label, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(0)} kg',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '≈ ${(value / 15).toStringAsFixed(1)} sacs',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
