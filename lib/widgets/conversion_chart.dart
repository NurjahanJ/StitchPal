import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class ConversionChart extends StatefulWidget {
  const ConversionChart({super.key});

  @override
  State<ConversionChart> createState() => _ConversionChartState();
}

class _ConversionChartState extends State<ConversionChart> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversion Charts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reference charts for hook sizes and yarn weights across different standards',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: StitchPalTheme.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        
        Container(
          decoration: BoxDecoration(
            color: StitchPalTheme.surfaceColor,
            border: Border(
              bottom: BorderSide(
                color: StitchPalTheme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: StitchPalTheme.primaryColor,
            unselectedLabelColor: StitchPalTheme.textColor.withOpacity(0.7),
            indicatorColor: StitchPalTheme.primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Hook Sizes'),
              Tab(text: 'Yarn Weights'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildHookSizesChart(),
              _buildYarnWeightsChart(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHookSizesChart() {
    final hookSizes = [
      {
        'us': 'B-1', 
        'metric': '2.25 mm', 
        'uk': '13'
      },
      {
        'us': 'C-2', 
        'metric': '2.75 mm', 
        'uk': '12'
      },
      {
        'us': 'D-3', 
        'metric': '3.25 mm', 
        'uk': '10'
      },
      {
        'us': 'E-4', 
        'metric': '3.5 mm', 
        'uk': '9'
      },
      {
        'us': 'F-5', 
        'metric': '3.75 mm', 
        'uk': '9'
      },
      {
        'us': 'G-6', 
        'metric': '4.0 mm', 
        'uk': '8'
      },
      {
        'us': 'H-8', 
        'metric': '5.0 mm', 
        'uk': '6'
      },
      {
        'us': 'I-9', 
        'metric': '5.5 mm', 
        'uk': '5'
      },
      {
        'us': 'J-10', 
        'metric': '6.0 mm', 
        'uk': '4'
      },
      {
        'us': 'K-10.5', 
        'metric': '6.5 mm', 
        'uk': '3'
      },
      {
        'us': 'L-11', 
        'metric': '8.0 mm', 
        'uk': '0'
      },
      {
        'us': 'M-13', 
        'metric': '9.0 mm', 
        'uk': '00'
      },
      {
        'us': 'N-15', 
        'metric': '10.0 mm', 
        'uk': '000'
      },
      {
        'us': 'P', 
        'metric': '11.5 mm', 
        'uk': '-'
      },
      {
        'us': 'Q', 
        'metric': '15.0 mm', 
        'uk': '-'
      },
    ];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Hook Size Conversion',
            content: 'This chart shows the conversion between US, metric, and UK hook sizes. Metric sizes (mm) are the most precise measurement.',
            icon: Icons.straighten,
          ),
          
          const SizedBox(height: 16),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: StitchPalTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildTableHeader(['US', 'Metric', 'UK']),
                ...hookSizes.map((size) => _buildTableRow([
                  size['us']!,
                  size['metric']!,
                  size['uk']!,
                ], hookSizes.indexOf(size) % 2 == 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildYarnWeightsChart() {
    final yarnWeights = [
      {
        'weight': '0 - Lace',
        'wpi': '30+',
        'us': 'Lace, Fingering',
        'uk': '1 ply',
        'au': '2 ply, 3 ply'
      },
      {
        'weight': '1 - Super Fine',
        'wpi': '27-32',
        'us': 'Sock, Fingering, Baby',
        'uk': '3 ply, 4 ply',
        'au': '4 ply, 5 ply'
      },
      {
        'weight': '2 - Fine',
        'wpi': '23-27',
        'us': 'Sport, Baby',
        'uk': '5 ply',
        'au': 'Sports, 5 ply'
      },
      {
        'weight': '3 - Light',
        'wpi': '16-20',
        'us': 'DK, Light Worsted',
        'uk': 'DK',
        'au': '8 ply'
      },
      {
        'weight': '4 - Medium',
        'wpi': '12-16',
        'us': 'Worsted, Aran',
        'uk': 'Aran',
        'au': '10 ply, Aran'
      },
      {
        'weight': '5 - Bulky',
        'wpi': '8-12',
        'us': 'Chunky, Craft, Rug',
        'uk': 'Chunky',
        'au': '12 ply, Bulky'
      },
      {
        'weight': '6 - Super Bulky',
        'wpi': '5-8',
        'us': 'Super Bulky, Roving',
        'uk': 'Super Chunky',
        'au': '14 ply+'
      },
      {
        'weight': '7 - Jumbo',
        'wpi': '<5',
        'us': 'Jumbo, Roving',
        'uk': 'Jumbo',
        'au': 'Jumbo'
      },
    ];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Yarn Weight Conversion',
            content: 'This chart shows yarn weight systems across different regions. WPI stands for "Wraps Per Inch" and is a standard measurement method.',
            icon: Icons.format_color_fill,
          ),
          
          const SizedBox(height: 16),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: StitchPalTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: StitchPalTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  StitchPalTheme.primaryColor.withOpacity(0.2),
                ),
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: StitchPalTheme.dividerColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                columns: const [
                  DataColumn(label: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('WPI', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('US Terms', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('UK Terms', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('AU/NZ Terms', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: yarnWeights.map((weight) => DataRow(
                  cells: [
                    DataCell(Text(weight['weight']!)),
                    DataCell(Text(weight['wpi']!)),
                    DataCell(Text(weight['us']!)),
                    DataCell(Text(weight['uk']!)),
                    DataCell(Text(weight['au']!)),
                  ],
                )).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildInfoCard(
            title: 'What is WPI?',
            content: 'WPI (Wraps Per Inch) is determined by wrapping yarn around a ruler for 1 inch without overlapping or leaving gaps, then counting the number of strands.',
            icon: Icons.help_outline,
            color: StitchPalTheme.accentColor.withOpacity(0.1),
            borderColor: StitchPalTheme.accentColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? color,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? StitchPalTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? StitchPalTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: StitchPalTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTableHeader(List<String> columns) {
    return Container(
      decoration: BoxDecoration(
        color: StitchPalTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: columns.map((column) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              column,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )).toList(),
      ),
    );
  }
  
  Widget _buildTableRow(List<String> values, bool isEvenRow, {bool isWide = false}) {
    return Container(
      color: isEvenRow 
          ? StitchPalTheme.surfaceColor 
          : StitchPalTheme.primaryColor.withOpacity(0.05),
      child: Row(
        children: values.map((value) => isWide 
          ? Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                value,
                style: TextStyle(
                  color: StitchPalTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  value,
                  style: TextStyle(
                    color: StitchPalTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ).toList(),
      ),
    );
  }
}
