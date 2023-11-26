import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/BinProvider.dart';
import 'package:bottom/widgets/showGridView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// List<RemainderModel> deletedRM = [];
// List<DataModel> deletedDM = [];

class BinScreen extends ConsumerStatefulWidget {
  BinScreen({super.key});

  @override
  ConsumerState<BinScreen> createState() => _BinScreenState();
}

class _BinScreenState extends ConsumerState<BinScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deletedRM = ref.watch(BinRemainderProvider);
    final deletedDM = ref.watch(BinNoteProvider);
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            height: 35,
            width: 220,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,

              // give the indicator a decoration (color and border radius)
              splashBorderRadius: BorderRadius.circular(15),

              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      // Color.fromRGBO(192, 72, 72, 1),
                      // Color.fromRGBO(75, 18, 72, 1),
                      // Color.fromRGBO(0, 0, 0, 1),
                      // Color.fromRGBO(146, 60, 181, 1),
                      Colors.black,
                      Colors.black
                    ]),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Notes',
                ),
                Tab(
                  text: 'Remainders',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: TabBarView(
                physics: BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  Tab(
                      child: showGridView(
                    isItUsedInBin: true,
                    Notes: deletedDM,
                    isRemainder: false,
                  )),
                  Tab(
                      child: showGridView(
                    isItUsedInBin: true,
                    Notes: deletedRM,
                    isRemainder: true,
                  )),
                ]),
          )
        ],
      ),
      // child: showGridView(isRemainder: isRemainder, Notes: Notes),
    );
  }
}
