import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int totalPoints = 0;
  List<RewardItem> rewardHistory = [];

  void addRewardPoints(int points, String itemName) {
    setState(() {
      totalPoints += points;
      rewardHistory.insert(
        0,
        RewardItem(
          itemName: itemName,
          points: points,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildPointsCard(),
          Expanded(child: _buildRewardHistory()),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Total Points', style: TextStyle(fontSize: 16)),
            Text(
              '$totalPoints',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardHistory() {
    return rewardHistory.isEmpty
        ? const Center(child: Text('No rewards yet'))
        : ListView.builder(
            itemCount: rewardHistory.length,
            itemBuilder: (context, index) {
              final item = rewardHistory[index];
              return ListTile(
                title: Text(item.itemName),
                subtitle: Text(item.timestamp.toString()),
                trailing: Text('+${item.points}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              );
            },
          );
  }
}

class RewardItem {
  final String itemName;
  final int points;
  final DateTime timestamp;

  RewardItem({
    required this.itemName,
    required this.points,
    required this.timestamp,
  });
}
