import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/customer.dart';
import 'package:flutter/services.dart';

class AddCustomerScreen extends StatefulWidget  {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _balanceController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _saveCustomer() async {
    String name = _nameController.text;
    String dateOfBirth = _dateOfBirthController.text;
    double? balance = double.tryParse(_balanceController.text);

    if (name.isNotEmpty && dateOfBirth.isNotEmpty && balance != null) {
      Customer newCustomer = Customer(name: name, dateOfBirth: dateOfBirth, balance: balance);
      await database_helper.instance.addCustomer(newCustomer);
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new customer")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)"),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: _balanceController,
              decoration: InputDecoration(labelText: "Bakiye"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // 📌 Sayısal klavye açar
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 📌 Sayısal değerler için
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveCustomer, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
