import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class AddConsumptionScreen extends StatefulWidget {
  const AddConsumptionScreen({super.key});

  @override
  State<AddConsumptionScreen> createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _numberOfBags = 1; // Nombre de sacs consommés
  bool _isSaving = false;
  double _currentStock = 0; // Stock actuel en kg
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _loadCurrentStock();
  }

  Future<void> _loadCurrentStock() async {
    _storageService = await StorageService.init();
    final stock = _storageService!.calculateCurrentStock();
    setState(() {
      _currentStock = stock;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _incrementBags() {
    setState(() {
      _numberOfBags++;
    });
  }

  void _decrementBags() {
    if (_numberOfBags > 1) {
      setState(() {
        _numberOfBags--;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    final quantityInKg = _numberOfBags * 15.0;

    // Vérifier si le stock est suffisant
    if (quantityInKg > _currentStock) {
      if (mounted) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Stock insuffisant'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vous essayez de consommer $_numberOfBags sac${_numberOfBags > 1 ? 's' : ''} (${quantityInKg.toStringAsFixed(0)} kg)',
                ),
                const SizedBox(height: 8),
                Text(
                  'Stock disponible : ${_currentStock.toStringAsFixed(0)} kg (≈ ${(_currentStock / 15).toStringAsFixed(1)} sacs)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Voulez-vous quand même enregistrer cette consommation ?',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
                child: const Text('Continuer'),
              ),
            ],
          ),
        );

        if (confirm != true) return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final transaction = PelletTransaction(
        type: TransactionType.consommation,
        quantity: quantityInKg,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      final storage = _storageService ?? await StorageService.init();
      await storage.addTransaction(transaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Consommation enregistrée : $_numberOfBags sac${_numberOfBags > 1 ? 's' : ''} (${quantityInKg.toStringAsFixed(0)} kg)',
            ),
            backgroundColor: Colors.orange[700],
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer consommation'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 32,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Consommation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: _decrementBags,
                          icon: const Icon(Icons.remove),
                          iconSize: 32,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            foregroundColor: Colors.orange[900],
                            minimumSize: const Size(60, 60),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.orange[300]!,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$_numberOfBags',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                              Text(
                                'sac${_numberOfBags > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_numberOfBags * 15} kg',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton.filled(
                          onPressed: _incrementBags,
                          icon: const Icon(Icons.add),
                          iconSize: 32,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(60, 60),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Utilisez + ou - pour ajuster',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_numberOfBags * 15 > _currentStock)
                            ? Colors.red[50]
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (_numberOfBags * 15 > _currentStock)
                              ? Colors.red[300]!
                              : Colors.blue[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (_numberOfBags * 15 > _currentStock)
                                ? Icons.warning_amber
                                : Icons.inventory_2,
                            size: 20,
                            color: (_numberOfBags * 15 > _currentStock)
                                ? Colors.red[700]
                                : Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Stock disponible : ${_currentStock.toStringAsFixed(0)} kg',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: (_numberOfBags * 15 > _currentStock)
                                  ? Colors.red[700]
                                  : Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date de consommation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDate),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _selectDate,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note (optionnelle)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                        helperText: 'Ex: Période, météo, etc.',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveTransaction,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
