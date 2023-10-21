import 'package:flutter/material.dart';

import 'search_filter_container_member_list_item_value.dart';

class SearchFilterNumberRangeListItemValue extends SearchFilterContainerMemberListItemValue {
  String range1Text;
  String range1InputText;
  String range1InputHintText;
  TextEditingController Function() onGetRange1TextEditingController;
  String range2Text;
  String range2InputText;
  String range2InputHintText;
  TextEditingController Function() onGetRange2TextEditingController;
  String name;

  SearchFilterNumberRangeListItemValue({
    required this.range1Text,
    required this.range1InputText,
    required this.range1InputHintText,
    required this.onGetRange1TextEditingController,
    required this.range2Text,
    required this.range2InputText,
    required this.range2InputHintText,
    required this.onGetRange2TextEditingController,
    required this.name
  });
}