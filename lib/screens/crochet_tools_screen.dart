import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/stitch_counter.dart';
import 'package:stitchpal/widgets/gauge_calculator.dart';
import 'package:stitchpal/widgets/conversion_chart.dart';
import 'package:stitchpal/widgets/crochet_timer.dart';


class CrochetToolsScreen extends StatefulWidget {
  const CrochetToolsScreen({super.key});

  @override
  State<CrochetToolsScreen> createState() => _CrochetToolsScreenState();
}

class _CrochetToolsScreenState extends State<CrochetToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = ['Stitch Counter', 'Gauge Calculator', 'Conversion Charts', 'Timer'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Crochet Tools'),
        backgroundColor: StitchPalTheme.surfaceColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: StitchPalTheme.primaryColor,
          unselectedLabelColor: StitchPalTheme.textColor.withOpacity(0.6),
          indicatorColor: StitchPalTheme.primaryColor,
          indicatorWeight: 3,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Stitch Counter Tool
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: const StitchCounter(),
              ),
            ),
            
            // Gauge Calculator Tool
            const SingleChildScrollView(child: GaugeCalculator()),
            
            // Conversion Chart Tool
            const ConversionChart(),
            
            // Timer Tool
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: const CrochetTimer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
