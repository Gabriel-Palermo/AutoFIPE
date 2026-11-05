import 'package:flutter/material.dart';

import '../models/vehicle_model.dart';
import '../models/vehicle_year.dart';
import '../services/fipe_service.dart';
import '../widgets/loading_widget.dart';

class HistoryPage extends StatefulWidget {
  final VehicleModel model;
  final VehicleYear year;

  const HistoryPage({super.key, required this.model, required this.year});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FipeService service = FipeService();
  late Future<Map<String, dynamic>> history;

  @override
  void initState() {
    super.initState();

    history = service.getHistory(widget.model.fipeCode, widget.year.yearId);
  }

  String formatPrice(int price) {
    return 'R\$ ${price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de preços')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: history,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar histórico:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data!;
          final historyList = data['history'] as List;

          if (historyList.isEmpty) {
            return const Center(child: Text('Nenhum histórico encontrado.'));
          }

          final currentPrice = historyList.first['price'] as int;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF123B68), Color(0xFF101D32)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF24578A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VALOR MAIS RECENTE',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatPrice(currentPrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${data['brand']} ${data['model']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ano ${data['model_year']} • ${data['fuel']}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'EVOLUÇÃO MENSAL',
                        style: TextStyle(
                          color: Color(0xFF00D4FF),
                          fontSize: 12,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${historyList.length} registros',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    final price = item['price'] as int;
                    final isLatest = index == 0;

                    return Card(
                      color: const Color(0xFF121C2D),
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isLatest
                              ? const Color(0xFF168BFF)
                              : const Color(0xFF26364D),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.show_chart,
                            color: isLatest
                                ? const Color(0xFF00D4FF)
                                : Colors.white54,
                          ),
                        ),
                        title: Text(
                          item['month'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: isLatest
                            ? const Text(
                                'Referência mais recente',
                                style: TextStyle(
                                  color: Color(0xFF00D4FF),
                                  fontSize: 11,
                                ),
                              )
                            : null,
                        trailing: Text(
                          formatPrice(price),
                          style: TextStyle(
                            color: isLatest
                                ? const Color(0xFF00D4FF)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
