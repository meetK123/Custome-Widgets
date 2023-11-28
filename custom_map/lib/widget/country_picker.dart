import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
///Not Used
class CountryPicker extends StatefulWidget {
  const CountryPicker({this.callBack, Key? key}) : super(key: key);
  final Function(String)? callBack;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final List<Map<String, String>> countryListMap = codes;

  late List<CountryCode> countryList;
  late List<CountryCode> filteredCountry;
  Comparator<CountryCode>? comparator;

 final ValueNotifier<List<int>> selectedItems = ValueNotifier([]);

  @override
  void initState() {
    _getCountryList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    countryList = countryList.map((element) => element.localize(context)).toList();
    filteredCountry = filteredCountry.map((element) => element.localize(context)).toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: _buildCountryList(),
    );
  }

  void _getCountryList() async {
    List<Map<String, String>> jsonList = countryListMap;
    countryList = jsonList.map((json) => CountryCode.fromJson(json)).toList();
    filteredCountry = jsonList.map((json) => CountryCode.fromJson(json)).toList();

    if (comparator != null) {
      countryList.sort(comparator);
      filteredCountry.sort(comparator);
    }
  }

  Widget _buildCountryList() {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextFormField(
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: 'Search Country',
              hintStyle: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onChanged: (String? value) {
              String s = value?.toUpperCase() ?? '';
              setState(() {
                filteredCountry = countryList
                    .where(
                      (e) => e.code!.contains(s) || e.dialCode!.contains(s) || e.name!.toUpperCase().contains(s),
                    )
                    .toList();
              });
            },
          ),
          filteredCountry.isEmpty
              ? _buildNotFoundView()
              : Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1,
                    child: ListView.separated(
                      shrinkWrap: true,
                      clipBehavior: Clip.hardEdge,
                      itemCount: filteredCountry.length,
                      itemBuilder: (context, index) {
                        var item = filteredCountry[index];

                        return _buildCountryItem(item, index);
                      },
                      separatorBuilder: (context, index) => const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCountryItem(CountryCode? countryItem, int index) {
    return ValueListenableBuilder(
      valueListenable: selectedItems,
      builder: (context, List<int> selectedValue, child) {
        return GestureDetector(
          onTap: () {
            _onTapSelectedCountry(countryItem, index);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                child: Image.asset(
                  countryItem!.flagUri!,
                  package: 'country_code_picker',
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Text(
                  countryItem.toCountryStringOnly(),
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              selectedItems.value.contains(index)
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotFoundView() {
    return const Expanded(
      child: Center(
        child: Text(
          'No Country Found',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _onTapSelectedCountry(CountryCode countryItem, int index) {
    if (selectedItems.value.contains(index)) {
      selectedItems.value.remove(index);
    } else {
      selectedItems.value.add(index);
    }
    if(widget.callBack != null)widget.callBack!(countryItem.name ?? '');
    selectedItems.notifyListeners();
  }
}
