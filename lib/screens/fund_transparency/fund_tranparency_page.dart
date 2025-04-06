import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mind_care/config/colors.dart';
import 'package:mind_care/models/cart_data_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FundTransparencyPage extends StatefulWidget {
  const FundTransparencyPage({super.key});

  @override
  State<FundTransparencyPage> createState() => _FundTransparencyPageState();
}

class _FundTransparencyPageState extends State<FundTransparencyPage> {
  int selectedMonthIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentMonth = transactions[selectedMonthIndex];
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/fund_image.png",
          height: 6.h,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Month selector
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedMonthIndex;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMonthIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff6885B8)
                                : const Color(0xffCFDAED),
                            borderRadius: BorderRadius.circular(20),
                            border: const Border(
                              left: BorderSide(
                                  color: AppColors.primary, width: 3),
                              top: BorderSide(
                                  color: AppColors.primary, width: 3),
                              right: BorderSide(
                                  color: AppColors.primary, width: 6),
                              bottom: BorderSide(
                                  color: AppColors.primary, width: 6),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('MMMM yyyy')
                                  .format(transactions[index].month),
                              style: GoogleFonts.kodchasan(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              //! Summary card
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: AppColors.primary),
                  color: const Color(0xffF5F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            context,
                            'Income',
                            currencyFormat.format(currentMonth.income),
                            Colors.green.shade700,
                          ),
                          _buildSummaryItem(
                            context,
                            'Expenses',
                            currencyFormat.format(currentMonth.expenses),
                            Colors.red.shade700,
                          ),
                          _buildSummaryItem(
                            context,
                            'Balance',
                            currencyFormat.format(
                              currentMonth.income - currentMonth.expenses,
                            ),
                            Colors.blue.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //! Recent transactions
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: AppColors.primary),
                  color: const Color(0xffF5F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Month Transactions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentMonth.recentTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              currentMonth.recentTransactions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(transaction.description),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(transaction.date),
                            ),
                            trailing: Text(
                              '${transaction.isIncome ? '+' : '-'} ${currencyFormat.format(transaction.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transaction.isIncome
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontSize: 15.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //! Income breakdown
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: AppColors.primary),
                  color: const Color(0xffF5F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income Sources',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: SfCircularChart(
                          legend: const Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource:
                                  _getChartData(currentMonth.categories),
                              xValueMapper: (ChartData data, _) =>
                                  data.category,
                              yValueMapper: (ChartData data, _) => data.value,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                // formatter: (data, point, series, pointIndex,
                                //     seriesIndex) {
                                //   return '${(point.y as num).toStringAsFixed(1)}%';
                                // },
                              ),
                              explode: true,
                              explodeIndex: 0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: currentMonth.categories.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key),
                                Text(
                                  currencyFormat.format(entry.value),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //! Income vs Expenses Trend
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: AppColors.primary),
                  color: const Color(0xffF5F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income vs Expenses Trend',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          legend: const Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries>[
                            ColumnSeries<MonthlyTransaction, String>(
                              name: 'Income',
                              dataSource: transactions.reversed.toList(),
                              xValueMapper: (MonthlyTransaction data, _) =>
                                  DateFormat('MMM').format(data.month),
                              yValueMapper: (MonthlyTransaction data, _) =>
                                  data.income,
                              color: Colors.green.shade400,
                            ),
                            ColumnSeries<MonthlyTransaction, String>(
                              name: 'Expenses',
                              dataSource: transactions.reversed.toList(),
                              xValueMapper: (MonthlyTransaction data, _) =>
                                  DateFormat('MMM').format(data.month),
                              yValueMapper: (MonthlyTransaction data, _) =>
                                  data.expenses,
                              color: Colors.red.shade400,
                            ),
                            LineSeries<MonthlyTransaction, String>(
                              name: 'Balance',
                              dataSource: transactions.reversed.toList(),
                              xValueMapper: (MonthlyTransaction data, _) =>
                                  DateFormat('MMM').format(data.month),
                              yValueMapper: (MonthlyTransaction data, _) =>
                                  data.income - data.expenses,
                              color: Colors.blue.shade700,
                              markerSettings:
                                  const MarkerSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //! Transparency statement
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: AppColors.primary),
                  color: const Color(0xffF5F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our Commitment to Transparency',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We believe in full financial transparency. All donations and expenses are tracked and '
                        'published monthly. Our books are audited annually by an independent accounting firm. '
                        'If you have any questions about our finances, please contact our treasurer at '
                        'mindcareaether@gmail.com',
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.kodchasan(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.kodchasan(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  List<ChartData> _getChartData(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, value) => sum + value);

    return data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return ChartData(entry.key, percentage);
    }).toList();
  }
}
