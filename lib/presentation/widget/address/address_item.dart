import 'package:flutter/material.dart';

import '../../../domain/entity/address/address.dart';
import '../../../misc/constant.dart';

typedef OnSelectAddress = void Function(Address);

abstract class AddressItem extends StatelessWidget {
  @protected
  double? get itemWidth;

  final Address address;
  final OnSelectAddress? onSelectAddress;

  const AddressItem({
    super.key,
    required this.address,
    this.onSelectAddress
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        color: address.isPrimary == 0 ? Colors.transparent : Constant.colorLightOrange,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: address.isPrimary == 0 ? Colors.grey : Constant.colorMain,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onSelectAddress != null ? () => onSelectAddress!(address) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(address.addressUser.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(address.phoneNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(address.address),
              ],
            )
          ),
        ),
      ),
    );
  }
}