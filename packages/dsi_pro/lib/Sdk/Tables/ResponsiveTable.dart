// ignore_for_file: camel_case_types, must_be_immutable, unused_local_variable, prefer_const_constructors, sized_box_for_whitespace, avoid_print, file_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';

import '../../dsi_pro.dart';

class DSI_RESPONSIVE_TABLE extends StatefulWidget {
  DSI_RESPONSIVE_TABLE({
    super.key,
    required this.data,
    required this.tableHeader,
    this.child,
    required this.callback,
    required this.fields,
    this.onTap,
    this.onDoubleTap,
    this.tableHeaderText,
    this.height,
    this.width,
    this.deleteFunction,
    this.editFunction,
    this.addButtonColor,
    this.addButtonText,
    this.addButtonTextColor,
    this.addFunction,
    this.isAddButton,
    this.isSerachBox,
    this.lang,
    this.topChild,
    this.bottomChild,
    this.isActionTab,
    this.isEditButton,
    this.isDeleteButton,
    this.defaultShow,
  });
  List<Map<String, dynamic>> data;
  List tableHeader;
  List fields;
  final bool? isActionTab;
  final bool? isSerachBox;
  final bool? isEditButton;
  final bool? isDeleteButton;
  final String? lang;
  final Widget? child;
  final Widget? topChild;
  final Widget? bottomChild;
  final Function callback;
  final Function? deleteFunction;
  final Function? editFunction;
  var onTap,
      onDoubleTap,
      height,
      width,
      tableHeaderText,
      isAddButton,
      addButtonText,
      addButtonColor,
      addButtonTextColor,
      addFunction,
      defaultShow;
  @override
  State<DSI_RESPONSIVE_TABLE> createState() => _DSI_RESPONSIVE_TABLEState();
}

class _DSI_RESPONSIVE_TABLEState extends State<DSI_RESPONSIVE_TABLE> {
  int dataLength = 1;

  List<String> extractHeaders(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return [];
    }

    // Extract keys from the first dictionary
    Map<String, dynamic> firstItem = data.first;
    List<String> headers = firstItem.keys.toList();

    return headers;
  }

  bool isFocused = false;
  List filteredData = [];
  void filterData(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredData = widget.data.where((row) {
          return widget.fields.any((field) {
            final fieldValue = row[field]?.toString().toLowerCase() ?? '';
            return fieldValue.contains(query.toLowerCase());
          });
        }).toList();
      } else {
        filteredData = widget.data;
      }
    });
  }

  int loadingLength = 10;
  List dataLengths = [
    {"length": "10"},
    {"length": "25"},
    {"length": "50"},
    {"length": "100"},
    {"length": "250"},
    {"length": "500"},
    {"length": "1000"},
  ];

  @override
  void initState() {
    filteredData = widget.data.cast<Map<String, dynamic>>();

    setState(() {
      // print("Setting Table Header Length");
      // print(widget.tableHeader.length);

      if (widget.tableHeader.length > 6) {
        dataLength = 7;
      } else {
        dataLength = widget.tableHeader.length;
      }
      loadingLength = widget.defaultShow ?? 10;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(DSI_RESPONSIVE_TABLE oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload the web view with the new URL if it has changed
    if (widget.data != oldWidget.data) {
      setState(() {
        filteredData = widget.data;
      });
    }
    print("Reload Requested");
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;

    List<String> headers = extractHeaders(widget.data);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H2(text: widget.tableHeaderText ?? ""),
              Row(
                children: [
                  widget.topChild ?? SizedBox(height: 0, width: 0),
                  if (widget.isAddButton ?? false)
                    DSI_ICON_BUTTON(
                      title: widget.addButtonText ?? "ADD NEW",
                      icon: Icons.add,
                      toolTip: widget.addButtonText ?? "ADD NEW",
                      onPressed: () {
                        if (widget.addFunction != null) {
                          widget.addFunction();
                        }
                      },
                      width: 120.0,
                      height: 52.0,
                    ),
                  if (widget.isSerachBox ?? false)
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DSI_TEXT_BOX_WITH_VALUE(
                        width: MediaQuery.of(context).size.width < 600
                            ? MediaQuery.of(context).size.width / 2
                            : 250.0,
                        onChanged: (v) {
                          filterData(v.toString());
                        },
                        initialValue: "",
                        label: "Search",
                        suffix: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      color: Colors.grey,
                      padding: EdgeInsets.all(10),
                      child: H4(text: "#"),
                    ),
                    for (var x = 0; x < dataLength; x++)
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 120,
                          maxWidth: 220,
                        ),
                        width: DSIheightWidth(
                            context,
                            widget.tableHeader.length > 5
                                ? 15
                                : 100 / widget.tableHeader.length - 8,
                            false),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          border: Border(
                            right: BorderSide(),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: H3(
                          text: widget.tableHeader[x].toString(),
                          fontSize: 14,
                        ),
                      ),
                    if (widget.isActionTab ?? false)
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 120,
                          maxWidth: 220,
                        ),
                        width: DSIheightWidth(
                            context,
                            widget.tableHeader.length > 5
                                ? 15
                                : 100 / widget.tableHeader.length - 8,
                            false),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          border: Border(
                            right: BorderSide(),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: H3(
                          text: "Actions",
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                if (widget.data.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 35),
                        H3(text: "No data found!"),
                      ],
                    ),
                  ),
                for (var y = 0; y < filteredData.length; y++)
                  if (y < loadingLength)
                    InkWell(
                      focusNode: FocusNode(canRequestFocus: true),
                      onFocusChange: (v) {
                        setState(() {
                          isFocused = v;
                        });
                      },
                      onTap: () {
                        widget.callback(y);
                        if (widget.onTap.toString() != "null" &&
                            widget.onTap != null) {
                          widget.onTap();
                        }
                      },
                      onDoubleTap: () {
                        widget.callback(y);
                        if (widget.onDoubleTap.toString() != "null" &&
                            widget.onDoubleTap != null) {
                          widget.onDoubleTap();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFocused
                              ? Color.fromARGB(255, 185, 185, 185)
                              : DSI_ACCENT_COLOR,
                          border: Border(
                            bottom: BorderSide(
                              color: const Color.fromARGB(255, 233, 233, 233),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.callback(y);
                                showFullInfo(context, y, headers);
                              },
                              child: Container(
                                width: 30,
                                child: H4(
                                  text: "${y + 1}.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            for (var x = 0; x < dataLength; x++)
                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 120,
                                  maxWidth: 220,
                                ),
                                width: DSIheightWidth(
                                    context,
                                    widget.tableHeader.length > 5
                                        ? 15
                                        : 100 / widget.tableHeader.length - 8,
                                    false),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(),
                                child: filteredData[y][widget.fields[x]]
                                            .toString()
                                            .startsWith("http") ||
                                        filteredData[y][widget.fields[x]]
                                            .toString()
                                            .startsWith("https")
                                    ? Container(
                                        height: 80.0,
                                        width: 80.0,
                                        child: Image.network(filteredData[y]
                                                [widget.fields[x]]
                                            .toString()),
                                      )
                                    : H3(
                                        text: filteredData[y][widget.fields[x]]
                                                    .toString() ==
                                                "null"
                                            ? " "
                                            : filteredData[y][widget.fields[x]]
                                                .toString(),
                                        fontSize: 13,
                                      ),
                              ),
                            if (widget.child != null &&
                                widget.child.toString() != "null" &&
                                widget.child.toString() != "" &&
                                widget.child != SizedBox() &&
                                widget.isActionTab == true)
                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 120,
                                  maxWidth: 220,
                                ),
                                width: DSIheightWidth(
                                    context,
                                    widget.tableHeader.length > 5
                                        ? 15
                                        : 100 / widget.tableHeader.length - 8,
                                    false),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    // color: DSI_ACCENT_COLOR,
                                    ),
                                child: Wrap(
                                  children: [
                                    DSI_ICON_BUTTON(
                                      title: "",
                                      toolTip: "View",
                                      icon: Icons.remove_red_eye,
                                      onPressed: () {
                                        widget.callback(y);
                                        showFullInfo(context, y, headers);
                                      },
                                      width: 50.0,
                                    ),
                                    DBR(),
                                    if (widget.isEditButton ?? false)
                                      DSI_ICON_BUTTON(
                                        title: "",
                                        toolTip: "Edit",
                                        icon: Icons.edit_document,
                                        onPressed: () {
                                          widget.callback(y);
                                          widget.editFunction!();
                                        },
                                        width: 50.0,
                                        buttonColor: Colors.amber,
                                      ),
                                    DBR(),
                                    if (widget.isDeleteButton ?? false)
                                      DSI_ICON_BUTTON(
                                        title: "",
                                        toolTip: "Delete",
                                        icon: Icons.delete,
                                        onPressed: () {
                                          widget.callback(y);

                                          DSIConfirmDialog(
                                            context,
                                            titleText:
                                                "Do you want to delete ${filteredData[y][widget.fields[0]]}?",
                                            onPressed: () {
                                              widget.editFunction!();
                                            },
                                            btnText: "Delete",
                                          );
                                        },
                                        width: 50.0,
                                        buttonColor: Colors.red,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                DBR(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: DSIheightWidth(context, 100, false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DSI_SELECT_BOX(
                            width: 90.0,
                            onChanged: (v) {
                              setState(() {
                                // if (filteredData.length >=
                                // int.parse(v.toString())) {
                                loadingLength = int.parse(v.toString());
                                // } else {
                                //   HelloDevsecit.showToast(
                                //     context,
                                //     "Not enough data",
                                //     time: 1,
                                //   );
                                // }
                              });
                            },
                            initialValue: loadingLength.toString(),
                            item: "length",
                            data: dataLengths,
                            suffix: Icon(Icons.arrow_drop_down),
                            label: "Show",
                          ),
                          // DSI_SELECT_BOX(
                          //   width: 90.0,
                          //   onChanged: (v) {
                          //     setState(() {
                          //       loadingLength = int.parse(v.toString());
                          //     });
                          //   },
                          //   initialValue: loadingLength.toString(),
                          //   item: "length",
                          //   data: dataLengths,
                          //   suffix: Icon(Icons.arrow_drop_down),
                          //   label: "Page",
                          // ),
                        ],
                      ),
                    ),
                    widget.bottomChild ?? SizedBox(height: 0, width: 0)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showFullInfo(context, int x, List headers) {
    double swidth = MediaQuery.of(context).size.width;

    print(headers.length.toString());
    showModalBottomSheet(
      // isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Container(
        height: 525,
        padding: swidth < 600 ? EdgeInsets.all(15) : EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              height: 430,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView(
                padding: EdgeInsets.all(18),
                children: [
                  H3(text: "Details view"),
                  Divider(),
                  for (var y = 0; y < widget.fields.length; y++)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: DSI_ACCENT_COLOR,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H3(
                            text: widget.tableHeader[y].toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          // H3(
                          //   text: filteredData[x][widget.fields[y]].toString(),
                          //   fontSize: 13,
                          // ),
                          filteredData[x][widget.fields[y]]
                                      .toString()
                                      .startsWith("http") ||
                                  filteredData[x][widget.fields[y]]
                                      .toString()
                                      .startsWith("https")
                              ? Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Image.network(filteredData[x]
                                          [widget.fields[y]]
                                      .toString()),
                                )
                              : H3(
                                  text: filteredData[x][widget.fields[y]]
                                              .toString() ==
                                          "null"
                                      ? " "
                                      : filteredData[x][widget.fields[y]]
                                          .toString(),
                                  fontSize: 13,
                                ),
                        ],
                      ),
                    ),
                  if (widget.isActionTab ?? false)
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        DBR(),
                        if (widget.isEditButton ?? false)
                          DSI_ICON_BUTTON(
                            title: "Edit",
                            toolTip: "Edit",
                            icon: Icons.edit_document,
                            onPressed: () {
                              widget.callback(x);
                              if (widget.editFunction != null) {
                                widget.editFunction!();
                              }
                            },
                            width: 250.0,
                            buttonColor: Colors.amber,
                          ),
                        DBR(),
                        if (widget.isDeleteButton ?? false)
                          DSI_ICON_BUTTON(
                            title: "Delete",
                            toolTip: "Delete",
                            icon: Icons.delete,
                            onPressed: () {
                              widget.callback(x);

                              DSIConfirmDialog(
                                context,
                                titleText:
                                    "Do you want to delete ${filteredData[x][widget.fields[0]]}?",
                                onPressed: () {
                                  if (widget.deleteFunction != null) {
                                    widget.deleteFunction!();
                                  }
                                },
                                btnText: "Delete",
                              );
                            },
                            width: 250.0,
                            buttonColor: Colors.red,
                          ),
                      ],
                    ),
                  widget.child!
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Cancel",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
