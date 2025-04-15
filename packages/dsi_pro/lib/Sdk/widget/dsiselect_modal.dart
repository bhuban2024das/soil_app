import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

class DSI_SELECT_BOX_WIDGET_NOT_FOR_USE extends StatefulWidget {
  DSI_SELECT_BOX_WIDGET_NOT_FOR_USE(
      {super.key,
      this.label,
      this.border,
      this.borderradius,
      this.prefix,
      this.suffix,
      this.height,
      this.width,
      this.textAlign,
      this.textAlignVertical,
      this.isNumber,
      this.isPassword,
      required this.onChanged,
      required this.initialValue,
      this.decoration,
      this.textColor,
      this.maxLength,
      this.isReadonly,
      required this.item,
      required this.data,
      this.subtitle});
  Function onChanged;
  final String item;
  final List data;
  var label,
      border,
      borderradius,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      initialValue,
      decoration,
      textColor,
      maxLength,
      isReadonly,
      subtitle;

  @override
  State<DSI_SELECT_BOX_WIDGET_NOT_FOR_USE> createState() =>
      _DSI_SELECT_BOX_WIDGET_NOT_FOR_USEState();
}

class _DSI_SELECT_BOX_WIDGET_NOT_FOR_USEState
    extends State<DSI_SELECT_BOX_WIDGET_NOT_FOR_USE> {
  List filteredData = [];
  void filterData(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredData = widget.data.where((user) {
          return user[widget.item].toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        filteredData = widget.data;
      }
    });
  }

  @override
  void initState() {
    filteredData = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.data.length > 10)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: DSI_TEXT_BOX_WITH_VALUE(
                  width: DSIheightWidth(context, 100, false),
                  onChanged: (v) {
                    filterData(v.toString());
                  },
                  initialValue: "",
                  label: "Search",
                  suffix: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        for (var x = 0; x < filteredData.length; x++)
          ListTile(
            title: Text(filteredData[x][widget.item].toString()),
            subtitle: widget.subtitle.toString() != "null"
                ? Text(filteredData[x][widget.subtitle].toString())
                : null,
            leading: const Icon(Icons.circle_outlined),
            onTap: () {
              widget.onChanged(filteredData[x][widget.item]);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}

class DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USE extends StatefulWidget {
  DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USE(
      {super.key,
      this.label,
      this.border,
      this.borderradius,
      this.prefix,
      this.suffix,
      this.height,
      this.width,
      this.textAlign,
      this.textAlignVertical,
      this.isNumber,
      this.isPassword,
      required this.onChanged,
      required this.initialValue,
      required this.onUpdated,
      this.decoration,
      this.textColor,
      this.maxLength,
      this.isReadonly,
      required this.item,
      required this.data,
      this.subtitle,
      required this.prefilled});
  Function onChanged, onUpdated;
  final String item;
  final List data, prefilled;
  var label,
      border,
      borderradius,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      initialValue,
      decoration,
      textColor,
      maxLength,
      isReadonly,
      subtitle;

  @override
  State<DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USE> createState() =>
      _DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USEState();
}

class _DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USEState
    extends State<DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USE> {
  List filteredData = [];
  void filterData(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredData = widget.data.where((user) {
          return user[widget.item].toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        filteredData = widget.data;
      }
    });
  }

  @override
  void initState() {
    filteredData = widget.data;
    selectedItems = widget.prefilled;
    super.initState();
  }

  late List<dynamic> selectedItems; // List to hold selected items

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.data.length > 10)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: DSI_TEXT_BOX_WITH_VALUE(
                  width: DSIheightWidth(context, 100, false),
                  onChanged: (v) {
                    filterData(v.toString());
                  },
                  initialValue: "",
                  label: "Search",
                  suffix: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        for (var x = 0; x < filteredData.length; x++)
          ListTile(
            title: Text(filteredData[x][widget.item].toString()),
            subtitle: widget.subtitle.toString() != "null"
                ? Text(filteredData[x][widget.subtitle].toString())
                : null,
            leading: Icon(
              selectedItems.contains(filteredData[x][widget.item])
                  ? Icons.check_box // If selected, show checkbox
                  : Icons
                      .check_box_outline_blank, // If not selected, show empty checkbox
            ),
            onTap: () {
              setState(() {
                if (selectedItems.contains(filteredData[x][widget.item])) {
                  selectedItems.remove(filteredData[x][widget.item]);
                } else {
                  selectedItems.add(filteredData[x][widget.item]);
                }
              });
              widget.onUpdated(selectedItems);
              widget.onChanged(selectedItems); // Return the selected list
            },
          ),
      ],
    );
  }
}
