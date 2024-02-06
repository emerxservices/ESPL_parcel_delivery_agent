import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/services.dart';

import '../utilities/constants.dart';

class CountryPicker extends StatelessWidget {
  CountryPicker(
      {required this.onCountryCodeChange,
      this.isShowDownIcon,
      this.arrowDownIconColor,
      this.initialSelection});
  final Function onCountryCodeChange;
  bool? isShowDownIcon;
  Color? arrowDownIconColor;
  String? initialSelection;

  @override
  Widget build(BuildContext context) {
    return CountryListPick(
      appBar: AppBar(
        backgroundColor: orange,
        title: Text('Select country'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: orange,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      // To disable option set to false

      theme: CountryTheme(
        alphabetSelectedTextColor: Colors.white,
        alphabetTextColor: Colors.black,
        labelColor: Colors.black,
        searchText: '',
        isShowFlag: true,
        isShowTitle: false,
        isShowCode: false,
        isDownIcon: isShowDownIcon != null ? isShowDownIcon : false,
        showEnglishName: true,
        // dropIconColor: arrowDownIconColor,
      ),

      // Set default value
      // initialSelection: initialSelection != "" ? initialSelection : '+1',
      // or
      initialSelection: initialSelection ?? 'US',
      onChanged: (code) {
        onCountryCodeChange(code?.dialCode);
        // print(code?.name);
        // print(code?.code);
        // print(code?.dialCode);
        // print(code?.flagUri);
      },

      useUiOverlay: true,
      // Whether the country list should be wrapped in a SafeArea
      useSafeArea: false,
    );
  }
}
