import 'package:custom_map/model/county_continent_model/country_continent_model.dart';
import 'package:custom_map/model/model.dart';
import 'package:custom_map/provider/country_notifier.dart';
import 'package:custom_map/widget/country_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../model/county_continent_model/country_continent_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapZoomPanBehavior? zoomPanBehavior;

  final List<Map<String, dynamic>> newContinentList = countryContinentList;

  final List<Map<String, dynamic>> countryContinentMapList = [];

  late Map<String, List<CountryContinentModel>> groupedCountries;

  late MapTileLayerController _mapController;

  List<Model> dataList = [];

  @override
  void initState() {
    _initMapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _initMapController() {
    _mapController = MapTileLayerController();

    /// zoom controller
    zoomPanBehavior = MapZoomPanBehavior(enableDoubleTapZooming: false, enablePinching: true, maxZoomLevel: 10, minZoomLevel: 1);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    dataList = context.watch<CountryNotifier>().dataList;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: height / 4,
            child: Consumer<CountryNotifier>(
              builder: (BuildContext context, value, Widget? child) {
                return child!;
              },
              child: SfMaps(
                layers: <MapShapeLayer>[
                  MapShapeLayer(
                    ///main world json
                    source: MapShapeSource.asset(
                      'assets/map/world_map.json',
                      shapeDataField: 'name',
                      dataCount: dataList.length,
                      primaryValueMapper: (int index) {
                        return dataList[index].country ?? '';
                      },
                      shapeColorValueMapper: (int index) => dataList[index].color,
                    ),
                    showDataLabels: false,
                    color: Colors.grey,
                    strokeColor: dataList.length > 1 ? Colors.white : Colors.grey,
                    strokeWidth: dataList.length > 1 ? 0.5 : null,
                    zoomPanBehavior: zoomPanBehavior,
                    sublayers: [
                      ///usa json
                      MapShapeSublayer(
                        source: MapShapeSource.asset(
                          'assets/map/usa.json',
                          shapeDataField: 'name',
                          dataCount: dataList.length,
                          primaryValueMapper: (int index) {
                            return dataList[index].country ?? '';
                          },
                          shapeColorValueMapper: (int index) => dataList[index].color,
                        ),
                        color: Colors.grey,
                        strokeColor: dataList.length > 1 ? Colors.white : Colors.grey,
                        strokeWidth: dataList.length > 1 ? 0.5 : null,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                _showCountryContinent();
              },
              child: const Icon(Icons.add)),
          ElevatedButton(
            onPressed: () {
              ///reset controller
              zoomPanBehavior?.reset();
              setState(() {});
            },
            child: const Icon(
              Icons.restart_alt_rounded,
            ),
          ),
          ElevatedButton(
              onPressed: dataList.length <= 1
                  ? null
                  : () {
                      zoomPanBehavior?.reset();
                      dataList.clear();
                      context.read<CountryNotifier>().onTapCallBack(model: const Model(country: '', state: '', color: Colors.green));
                    },
              child: const Icon(Icons.clear)),
        ],
      ),
    );
  }

  Future<void> _showCountryContinent() async {
    Provider.of<CountryNotifier>(context, listen: false).getCountries();
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        clipBehavior: Clip.none,
        builder: (BuildContext context) {
          return const CountryListView();
        });
  }
}
