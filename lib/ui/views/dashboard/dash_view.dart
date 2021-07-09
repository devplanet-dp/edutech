import 'package:collection/collection.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/app_title_widget.dart';
import 'package:edutech/ui/widgets/tile_widget.dart';
import 'package:edutech/utils/app_utils.dart';
import 'package:edutech/viewmodel/dashboard/dash_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';

class DashView extends StatelessWidget {
  const DashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: AppTitleWidget(
            isDark: model.isDark(),
            isLarge: true,
          ),
          actions: [
            IconButton(
                onPressed: () => model.signOut(),
                icon: Icon(LineIcons.alternateSignOut))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceMedium,
              Text(
                'Dashboard',
                style: kHeading3Style.copyWith(fontWeight: FontWeight.bold),
              ),
              verticalSpaceMedium,
              _StatRow(model: model),
              verticalSpaceMedium,
              Padding(
                padding: fieldPadding,
                child: TileWidget(
                    header: _buildSalesmenCount(model),
                    subHeader: 'Explore Salesmen',
                    icon: Icons.supervised_user_circle,
                    primaryColor: kcPrimaryColor,
                    onTap: () => model.navigateToSalesmenView(),
                    isDark: model.isDark()),
              ),
              verticalSpaceMedium,
              Padding(
                padding: fieldPadding,
                child: _GraphView(
                  saleStream: model.streamAppSales(limit: 10),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => DashViewModel(),
    );
  }

  Widget _buildSalesmenCount(DashViewModel model) =>
      StreamBuilder<List<UserModel>>(
          stream: model.streamAllUsers(),
          builder: (_, snapshot) => Text(
                '${snapshot.data?.length ?? 0}',
                style: kHeading1Style.copyWith(
                    color: kAltWhite, fontWeight: FontWeight.bold),
              ));
}

class _StatRow extends StatelessWidget {
  final DashViewModel model;

  const _StatRow({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: fieldPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRevenueStat(false),
              VerticalDivider(),
              _buildRevenueStat(true),
              VerticalDivider(),
              _buildSalesman(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueStat(bool isPending) => StreamBuilder(
      stream: model.streamAppSales(),
      builder: (_, snapshot) {
        List<Sale> s = snapshot.data ?? [];

        double earnedRevenue = s.fold(0, (sum, item) => sum + item.amountPaid);
        double totalCourseFee = s.fold(0, (sum, item) => sum + item.courseFee);
        return _buildStatItem(
            isPending ? 'Pending revenue' : 'Total revenue',
            formatCurrency.format(
                isPending ? (totalCourseFee - earnedRevenue) : earnedRevenue),
            !snapshot.hasData);
      });

  Widget _buildSalesman() => StreamBuilder(
      stream: model.streamAllUsers(),
      builder: (_, snapshot) {
        List<UserModel> s = snapshot.data ?? [];
        return _buildStatItem(
            'Total salesmen', '${s.length}', !snapshot.hasData);
      });

  Widget _buildStatItem(String title, String value, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                value,
                maxLines: 1,
                style: kHeading3Style.copyWith(
                    color: kcPrimaryColor, fontWeight: FontWeight.bold),
              ),
        verticalSpaceSmall,
        Text(
          title,
          style: kCaptionStyle,
        )
      ],
    );
  }
}

class _GraphView extends StatefulWidget {
  final Stream<List<Sale>> saleStream;

  const _GraphView({Key key, @required this.saleStream}) : super(key: key);

  @override
  __GraphViewState createState() => __GraphViewState();
}

class __GraphViewState extends State<_GraphView> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: kBorderMedium,
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceMedium,
                Text(
                  'Daily Sales',
                  style: kBodyStyle.copyWith(color: kAltWhite),
                  textAlign: TextAlign.center,
                ),
                verticalSpaceMedium,
                Expanded(
                  child: Padding(
                    padding: fieldPaddingAll,
                    child: _buildChart(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.refresh,
            //     color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       isShowingMainData = !isShowingMainData;
            //     });
            //   },
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return StreamBuilder<List<Sale>>(
        stream: widget.saleStream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Sale> s = snapshot.data ?? [];
          return LineChart(
            salesData(s),
            swapAnimationDuration: const Duration(milliseconds: 250),
          );
        });
  }

  LineChartData salesData(List<Sale> sales) {
    var saleMap = List.generate(sales.length, (index) => sales[index].toMap());
    var groupedSales = groupBy(saleMap, (sale) => sale['order_date']);
    var month;
    List<FlSpot> spots = [];

    groupedSales.forEach((key, value) {
      List<Sale> s = value.map((e) => Sale.fromJson(e)).toList();
      double earnedRevenue = s.fold(0, (sum, item) => sum + item.amountPaid);

      double x = double.parse((key.toString().split('/')[2]));
      month = key.toString().split('/')[1];
      print(month);
      spots.add(FlSpot(x, earnedRevenue));
    });
    //sort values
    spots.sort((a, b) => a.x.compareTo(b.x));

    var max = spots.reduce((curr, next) => curr.y > next.y ? curr : next);
    var min = spots.reduce((curr, next) => curr.y < next.y ? curr : next);

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 8,
          rotateAngle: -60,
          getTextStyles: (value) => const TextStyle(
            color: kAltWhite,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            return '$month/${value.toInt()}';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: max.y / 3,
          getTextStyles: (value) => const TextStyle(
            color: kAltWhite,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          rotateAngle: -60,
          getTitles: (value) {

            return '${formatCurrency.format(value)}';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      lineBarsData: linesSalesData(spots),
    );
  }

  List<LineChartBarData> linesSalesData(List<FlSpot> spots) {
    final lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
      ),
    );
    return [lineChartBarData1];
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}
