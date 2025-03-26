import 'package:flutter/material.dart';
import 'package:mind_care/config/colors.dart';
import 'package:mind_care/widgets/pie_chart.dart';

class MiningDashboard extends StatelessWidget {
  const MiningDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Mining Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //! Current Hash Rate Card
            _buildHashRateCard(context),

            const SizedBox(height: 16),

            Text(
              'Average Hour Hash Rate',
              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: 8),

            // Average Hour Hash Rate Rows
            _buildAverageHashRateRow(),

            const SizedBox(height: 16),

            // Last Hash Submitted and Current Payout Row
            _buildLastHashAndPayoutRow(context),

            const Spacer(),

            //! Miner Hashrate Graph Title
            Text(
              'Miner Hashrate Graph',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const PieChart(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHashRateCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(width: 4, color: AppColors.primary),
      ),
      color: AppColors.moodYellow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '800 H/s',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Current Hash Rate',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageHashRateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeHashRateCard('1hr', '0.00', AppColors.cardLavender),
        _buildTimeHashRateCard('6hr', '2.00', AppColors.cardRed),
        _buildTimeHashRateCard('24hr', '6.00', AppColors.cardLavender),
      ],
    );
  }

  Widget _buildTimeHashRateCard(String time, String hashRate, Color cardColor) {
    return Expanded(
      child: Card(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(width: 4, color: AppColors.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Icon(Icons.access_time, color: Colors.black54),
              const SizedBox(height: 8),
              Text(
                time,
                style: const TextStyle(color: Colors.black87),
              ),
              Text(
                '$hashRate H/s',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastHashAndPayoutRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(width: 4, color: AppColors.primary),
            ),
            color: AppColors.cardBlue,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Total Hashes\nSubmitted',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '960000',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(width: 4, color: AppColors.primary),
            ),
            color: Colors.green[100],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Current Payout\nEstimate',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '0.0000 XMR',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
