import 'package:flutter/material.dart';

void main() {
  runApp(TestRequest());
}

class TestRequest extends StatelessWidget {
  const TestRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateSoilTestRequest(),
    );
  }
}

class CreateSoilTestRequest extends StatefulWidget {
  const CreateSoilTestRequest({super.key});

  @override
  _CreateSoilTestRequestState createState() => _CreateSoilTestRequestState();
}

class _CreateSoilTestRequestState extends State<CreateSoilTestRequest> {
  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _farmLocationController = TextEditingController();
  String? _selectedSoilTestOption;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isEditing = true;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitRequest() {
    if (_farmerNameController.text.isNotEmpty &&
        _mobileNumberController.text.isNotEmpty &&
        _farmLocationController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soil test request submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Soil Test Request',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 22, 96, 22),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _farmerNameController,
                decoration: InputDecoration(
                  labelText: 'Farmer Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                ),
                enabled: _isEditing,
              ),
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                ),
                enabled: _isEditing,
              ),
              TextField(
                controller: _farmLocationController,
                decoration: InputDecoration(
                  labelText: 'Farm Location',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                ),
                enabled: _isEditing,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select options for Soil Test (Optional)',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                ),
                value: _selectedSoilTestOption,
                items: ['Soil Test 1', 'Soil Test 2', 'Soil Test 3']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                onChanged: _isEditing
                    ? (value) {
                        setState(() {
                          _selectedSoilTestOption = value;
                        });
                      }
                    : null,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : '${_selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                      decoration: InputDecoration(
                        labelText: 'Selected Date',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                      ),
                      readOnly: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isEditing ? () => _selectDate(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 79, 6),
                    ),
                    child: Text('Pick Date',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                        text: _selectedTime == null
                            ? ''
                            : _selectedTime!.format(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Selected Time',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 45, 79, 6)),
                      ),
                      readOnly: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isEditing ? () => _selectTime(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 79, 6),
                    ),
                    child: Text('Pick Time',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _toggleEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 79, 6),
                    ),
                    child: Text(_isEditing ? 'Save' : 'Edit',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 79, 6),
                    ),
                    child: Text('Submit Request',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
