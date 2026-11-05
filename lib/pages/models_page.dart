import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../models/vehicle_model.dart';
import '../services/fipe_service.dart';
import '../widgets/loading_widget.dart';
import 'years_page.dart';

class ModelsPage extends StatefulWidget {
  final Brand brand;

  const ModelsPage({super.key, required this.brand});

  @override
  State<ModelsPage> createState() => _ModelsPageState();
}

class _ModelsPageState extends State<ModelsPage> {
  final FipeService service = FipeService();
  late Future<List<VehicleModel>> models;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    models = service.getModels(widget.brand.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.brand.brand)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar modelo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() => searchText = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => searchText = value.trim());
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: Text(
              'MODELOS DISPONÍVEIS',
              style: TextStyle(
                color: Color(0xFF00D4FF),
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<VehicleModel>>(
              future: models,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar modelos:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final modelsList = snapshot.data ?? [];
                final filteredModels = modelsList.where((model) {
                  return model.model.toLowerCase().contains(
                    searchText.toLowerCase(),
                  );
                }).toList();

                if (filteredModels.isEmpty) {
                  return const Center(child: Text('Nenhum modelo encontrado.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: filteredModels.length,
                  itemBuilder: (context, index) {
                    final model = filteredModels[index];

                    return Card(
                      color: const Color(0xFF121C2D),
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFF26364D)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_car_filled,
                            color: Color(0xFF00D4FF),
                          ),
                        ),
                        title: Text(
                          model.model,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Anos: ${model.years}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF00D4FF),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YearsPage(model: model),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
