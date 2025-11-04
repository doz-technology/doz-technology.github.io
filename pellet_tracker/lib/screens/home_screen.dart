import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/statistics.dart';
import '../services/storage_service.dart';
import 'add_stock_screen.dart';
import 'add_consumption_screen.dart';
import 'history_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StorageService? _storageService;
  PelletStatistics? _statistics;
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
    setState(() => _isLoading = false);
  }

  Future<void> _navigateAndRefresh(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pellet Tracker'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _navigateAndRefresh(const HistoryScreen()),
            tooltip: 'Historique',
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () => _navigateAndRefresh(const StatisticsScreen()),
            tooltip: 'Statistiques',
          ),
        ],
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
                    _buildStockCard(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildStatisticsCards(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStockCard() {
    final stock = _statistics?.currentStock ?? 0;
    final stockInBags = _statistics?.stockInBags ?? 0;
    final daysRemaining = _statistics?.daysRemaining ?? 0;

    MaterialColor stockColor = Colors.green;
    IconData stockIcon = Icons.check_circle;
    String stockStatus = 'Bon niveau';

    if (_statistics?.isCritical ?? false) {
      stockColor = Colors.red;
      stockIcon = Icons.error;
      stockStatus = 'Stock critique !';
    } else if (_statistics?.isLow ?? false) {
      stockColor = Colors.orange;
      stockIcon = Icons.warning;
      stockStatus = 'Stock bas';
    }

    return Card(
      elevation: 4,
      color: stockColor[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(stockIcon, size: 48, color: stockColor),
            const SizedBox(height: 12),
            Text(
              stockStatus,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: stockColor[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${stock.toStringAsFixed(0)} kg',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '≈ ${stockInBags.toStringAsFixed(1)} sacs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: stockColor[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 20, color: stockColor[700]),
                  const SizedBox(width: 8),
                  Text(
                    daysRemaining > 365
                        ? 'Plus d\'un an restant'
                        : '$daysRemaining jours restants',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: stockColor[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateAndRefresh(const AddStockScreen()),
            icon: const Icon(Icons.add_circle),
            label: const Text('Ajouter\ndu stock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateAndRefresh(const AddConsumptionScreen()),
            icon: const Icon(Icons.remove_circle),
            label: const Text('Enregistrer\nconsommation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Consommation moyenne',
                '${(_statistics?.averageDaily ?? 0).toStringAsFixed(1)} kg/jour',
                Icons.trending_down,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Consommation hebdo',
                '${(_statistics?.averageWeekly ?? 0).toStringAsFixed(1)} kg',
                Icons.date_range,
                Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total acheté',
                '${(_statistics?.totalAchats ?? 0).toStringAsFixed(0)} kg',
                Icons.shopping_cart,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total consommé',
                '${(_statistics?.totalConsommation ?? 0).toStringAsFixed(0)} kg',
                Icons.local_fire_department,
                Colors.red,
              ),
            ),
          ],
        ),
        if (_statistics?.totalSpent != null) ...[
          const SizedBox(height: 12),
          _buildStatCard(
            'Dépenses totales',
            '${NumberFormat.currency(symbol: '€', decimalDigits: 2).format(_statistics!.totalSpent)}',
            Icons.euro,
            Colors.teal,
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
