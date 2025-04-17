import 'package:flutter/material.dart';
import '../../constants.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  
  const SearchBox({super.key, required this.onChanged});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kHighLightColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        ),
      ),
    );
  }
}
