import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

class AddSoilTestRequest extends StatefulWidget {
  const AddSoilTestRequest({super.key});

  @override
  State<AddSoilTestRequest> createState() => _AddSoilTestRequestState();
}

class _AddSoilTestRequestState extends State<AddSoilTestRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Soil Test Request"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DSI_CONFIG.appBorderRadius),
            ),
            child: Column(
              children: [
                DSI_CONTAINER(
                  height: 120.0,
                  margin: EdgeInsets.all(0.0),
                  width: DSIheightWidth(context, 100, false),
                  borderColor: Colors.green,
                  child: Center(
                    child: Text("No Photo Selected!"),
                  ),
                ),
                DBR(height: 20.0),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "22.00554,28.54540",
                  label: "GPS Cordinates *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "",
                  label: "Village *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "",
                  label: "Mandal *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "",
                  label: "Dist *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "",
                  label: "State *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                DSI_TEXT_BOX_WITH_VALUE(
                  onChanged: (v) {},
                  initialValue: "",
                  label: "Field Extant *",
                  width: DSIheightWidth(context, 100, false),
                ),
                DBR(),
                // DSI_TEXT_BOX_WITH_VALUE(
                //   onChanged: (v) {},
                //   initialValue: "",
                //   label: "Ruquested Data *",
                //   width: DSIheightWidth(context, 100, false),
                // ),
                // DBR(),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text("Requested Date *"),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("--/--/----"),
                  ),
                ),
                DBR(),
                // InputDecorator(
                //   child: Padding(
                //     padding: EdgeInsets.all(2.0),
                //     child: Text("--:--"),
                //   ),
                //   decoration: InputDecoration(
                //     label: Text("Select Inspection Time *"),
                //     border: OutlineInputBorder(
                //       borderRadius:
                //           BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                //     ),
                //   ),
                // ),
                // DBR(),
                DSI_PRIMARY_BUTTON(
                  title: "SUBMIT",
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
