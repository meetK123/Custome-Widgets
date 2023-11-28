import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_map/model/county_continent_model/country_continent_model.dart';
import 'package:custom_map/model/model.dart';
import 'package:custom_map/provider/country_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CountryListView extends StatefulWidget {
  const CountryListView({super.key});



  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  @override
  void initState() {
    super.initState();
    // _getCountryList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryNotifier>(
      builder: (context, CountryNotifier countryNotifier, child) => Container(
        height: 500,
        decoration: const BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: countryNotifier.groupedCountries.length,
          itemBuilder: (context, index) {
            String continent = countryNotifier.groupedCountries.keys.elementAt(index);
            List<CountryContinentModel> countries = countryNotifier.groupedCountries.values.elementAt(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Continent: $continent',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    CountryContinentModel country = countries[index];
                    Model modelItem = Model(
                      country: country.name,
                      color: Colors.green,
                    );

                    return GestureDetector(
                      onTap: () {
                        try {
                          context.read<CountryNotifier>().onTapCallBack(model: modelItem);
                        } on Exception catch (e, st) {
                          debugPrint('ERROR$e');
                          debugPrint('Stack Trace$st');
                        }
                      },
                      child: buildItem(country, modelItem),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildItem(CountryContinentModel country, Model modelItem) {
    final dataList = context.watch<CountryNotifier>().dataList;
    final tempList = dataList.where((element) => element.country == modelItem.country).toList();

    final isContain = tempList.isNotEmpty ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          country.flag4x3!.isEmpty
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CachedNetworkImage(imageUrl: country.url ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTULSPiQKGEcCtCxrkr4t9Ub8U-Jwzv3kXu2RMOzQoihg&s"))
              : SvgPicture.asset(
                  'assets/flags/4x3/${country.flag4x3}',
                  width: 15,
                  height: 15,
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${country.name} ',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          isContain
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
