import 'package:flutter/material.dart';

import '../models/vehicle_model.dart';
import '../models/vehicle_year.dart';
import '../services/fipe_service.dart';
import '../widgets/loading_widget.dart';
import 'history_page.dart';

class YearsPage extends StatefulWidget {
  final VehicleModel model;

  const YearsPage({super.key, required this.model});

  @override
  State<YearsPage> createState() => _YearsPageState();
}

class _YearsPageState extends State<YearsPage> {
  final FipeService service = FipeService();
  late Future<Map<String, dynamic>> years;

  @override
  void initState() {
    super.initState();
    years = service.getYears(widget.model.fipeCode);
  }

  String formatPrice(int price) {
    return 'R\$ ${price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta FIPE')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: years,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar preços:\n${snapshot.error}'),
            );
          }

          final data = snapshot.data!;
          final yearList = (data['years'] as List)
              .map((item) => VehicleYear.fromJson(item))
              .toList();

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
                    const Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          color: Color(0xFF00D4FF),
                          size: 19,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'CONSULTA TABELA FIPE',
                          style: TextStyle(
                            color: Color(0xFF00D4FF),
                            fontSize: 11,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      data['brand'] ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      data['model'] ?? widget.model.model,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Referência: ${data['reference']}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 4, 18, 14),
                child: Text(
                  'ANO E VALOR DO VEÍCULO',
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 12,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: yearList.length,
                  itemBuilder: (context, index) {
                    final year = yearList[index];

                    return Card(
                      color: const Color(0xFF121C2D),
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFF26364D)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF00D4FF),
                          ),
                        ),
                        title: Text(
                          'Ano ${year.modelYear}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          year.fuel,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatPrice(year.price),
                              style: const TextStyle(
                                color: Color(0xFF00D4FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Ver histórico',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HistoryPage(model: widget.model, year: year),
                            ),
                          );
                        },
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
