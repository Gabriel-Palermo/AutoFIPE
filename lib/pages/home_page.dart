import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../services/fipe_service.dart';
import '../widgets/loading_widget.dart';
import 'models_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FipeService service = FipeService();
  late Future<List<Brand>> brands;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    brands = service.getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.speed, color: Color(0xFF00D4FF), size: 27),
            const SizedBox(width: 9),
            const Text('AUTO', style: TextStyle(fontWeight: FontWeight.w900)),
            Text(
              'FIPE',
              style: TextStyle(
                color: Colors.lightBlueAccent.shade100,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF123B68), Color(0xFF101D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF24578A)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.directions_car_filled,
                  color: Color(0xFF00D4FF),
                  size: 34,
                ),
                SizedBox(height: 14),
                Text(
                  'Encontre seu veículo',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Consulte marcas, modelos e valores da Tabela FIPE.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar marca...',
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
            padding: EdgeInsets.fromLTRB(18, 22, 18, 12),
            child: Text(
              'MARCAS DISPONÍVEIS',
              style: TextStyle(
                color: Color(0xFF00D4FF),
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Brand>>(
              future: brands,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Não foi possível carregar as marcas.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final brandsList = snapshot.data ?? [];
                final filteredBrands = brandsList.where((brand) {
                  return brand.brand.toLowerCase().contains(
                    searchText.toLowerCase(),
                  );
                }).toList();

                if (filteredBrands.isEmpty) {
                  return const Center(child: Text('Nenhuma marca encontrada.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: filteredBrands.length,
                  itemBuilder: (context, index) {
                    final brand = filteredBrands[index];

                    return Card(
                      color: const Color(0xFF121C2D),
                      margin: const EdgeInsets.only(bottom: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: const BorderSide(color: Color(0xFF26364D)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385A),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            color: Color(0xFF00D4FF),
                          ),
                        ),
                        title: Text(
                          brand.brand,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                              builder: (_) => ModelsPage(brand: brand),
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
