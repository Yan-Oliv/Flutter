import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const FazendaApp());

class FazendaApp extends StatelessWidget {
  const FazendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int waterLevel = 75;
  int plantations = 4;
  int animals = 3;
  int animalHunger = 100;

  void performTask(String task) {
    setState(() {
      switch (task) {
        case 'Plantar':
          if (plantations < 5) {
            plantations++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plantando... 🌱'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Não foi possível plantar, limite alcançado... 🌾'),
                duration: Duration(seconds: 1),
              ),
            );
          }
          break;
        case 'Regar':
          if (plantations == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não há plantas a serem regadas... 🍂'),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (waterLevel < 100) {
            Random random = Random();
            int increase = random.nextInt(11);

            waterLevel += increase;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Regando... 💧'),
                duration: Duration(seconds: 1),
              ),
            );
            if (waterLevel > 100) {
              waterLevel = 100;
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Nível de água em 100%, não é mais possível regar, tente novamente mais tarde... ⏰'),
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }
          break;
        case 'Alimentar':
          if (animals == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não existem animais para alimentar. 🪹'),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (animalHunger > 0) {
            Random random = Random();
            int decrease = random.nextInt(11);

            animalHunger -= decrease;
            if (animalHunger < 0) {
              animalHunger = 0;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Alimentando os animais... 🍴'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Animais estão satisfeitos, alimente-os novamente mais tarde... 🥩'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          break;
        case 'Colher':
          if (plantations > 0) {
            plantations--;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Colhendo... 🚜 '),
                duration: Duration(seconds: 1),
              ),
            );
            if (plantations == 0) {
              waterLevel = 0;
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não existem mais itens a serem colhidos... 🍁 '),
                duration: Duration(seconds: 1),
              ),
            );
          }
          break;
        case 'Comprar Animal':
          if (animals < 5) {
            animals++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Comprando um novo animal... 🐮'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Limite de animais alcançado! 🐣'),
                duration: Duration(seconds: 1),
              ),
            );
          }
          break;
        case 'Vender Animal':
          if (animals > 0) {
            animals--;
            if (animals == 0) {
              animalHunger = 100;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vendendo um animal... 🐾'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não há animais para vender... 🐾'),
                duration: Duration(seconds: 1),
              ),
            );
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Fazenda Virtual 🧑‍🌾'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Geral',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Wrap para layout responsivo com cards
            Wrap(
              spacing: 16, // Espaço entre os cards
              runSpacing: 16, // Espaço entre as linhas
              children: [
                // Cada StatusCard terá um tamanho fixo e ficará alinhado
                StatusCard(
                  icon: Icons.water,
                  label: 'Água',
                  value: '$waterLevel%',
                ),
                StatusCard(
                  icon: Icons.grass,
                  label: 'Plantações',
                  value: '$plantations/5',
                ),
                StatusCard(
                  icon: Icons.pets,
                  label: 'Animais',
                  value: '$animals/5',
                ),
                StatusCard(
                  icon: Icons.restaurant,
                  label: 'Fome',
                  value: '$animalHunger%',
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Tarefas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Grid responsivo para as tarefas
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TaskButton(
                  icon: Icons.grass,
                  label: 'Plantar',
                  onTap: () => performTask('Plantar'),
                ),
                TaskButton(
                  icon: Icons.water_drop,
                  label: 'Regar',
                  onTap: () => performTask('Regar'),
                ),
                TaskButton(
                  icon: Icons.agriculture,
                  label: 'Colher',
                  onTap: () => performTask('Colher'),
                ),
                TaskButton(
                  icon: Icons.pets,
                  label: 'Alimentar',
                  onTap: () => performTask('Alimentar'),
                ),
                TaskButton(
                  icon: Icons.shopping_cart,
                  label: 'AgroPets',
                  onTap: () => performTask('Comprar Animal'),
                ),
                TaskButton(
                  icon: Icons.sell,
                  label: 'Vender Animais',
                  onTap: () => performTask('Vender Animal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatusCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 32, // Responsividade
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TaskButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
