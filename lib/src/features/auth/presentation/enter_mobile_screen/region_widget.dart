import 'package:flutter/material.dart';
import 'package:quiz_u/src/constants/regions.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_mobile_screen/region_picker.dart';

class RegionWidget extends StatefulWidget {
  const RegionWidget({
    Key? key,
    required this.initialRegion,
    this.onChange,
  }) : super(key: key);

  final Region initialRegion;
  final Function(Region)? onChange;

  @override
  State<RegionWidget> createState() => _RegionWidgetState();
}

class _RegionWidgetState extends State<RegionWidget> {
  late Region selectedRegion;

  Future<void> selectRegion() async {
    // show Region Picker as bottom sheet
    final userSelectedRegion = await showModalBottomSheet<Region>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) {
        return SafeArea(child: RegionPicker(regions: regions));
      },
    );

    if (userSelectedRegion != null) {
      setState(() => selectedRegion = userSelectedRegion);
      if (widget.onChange != null) {
        widget.onChange!(selectedRegion);
      }
    }
  }

  @override
  void initState() {
    // By default, set the selected region to Saudi Arabia
    selectedRegion = widget.initialRegion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectRegion,
      child: Row(
        children: [
          Text(
            selectedRegion.flag,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
