import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? onClear;
  const MySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      cursorColor: MyColors.black,
      enabled: true,
      obscureText: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: MyColors.white,
        hintText: 'Search cars by name or ID',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: MyColors.black,
            )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: MyColors.grey,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: MyColors.black.withOpacity(0.8),
        ),
        // suffixIcon: controller.text.isNotEmpty
        //     ? IconButton(
        //         color: MyColors.grey,
        //         icon: const Icon(Icons.clear),
        //         onPressed: onClear,
        //       )
        //     : null,
      ),
    );
  }
}
