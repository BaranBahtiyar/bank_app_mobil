import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/customer.dart';
import 'add_customer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Customer> _customerList = [];

  void _showDeleteConfirmationDialog(BuildContext context, int customerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deletion Confirmation"),
          content: Text("Do you want to delete this customer?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteCustomer(customerId);
                Navigator.of(context).pop();
              },
              child: Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final data = await database_helper.instance.getCustomers();
    setState(() {
      _customerList = data;
    });
  }

  Future<void> _deleteCustomer(int id) async {
    await database_helper.instance.deleteCustomer(id);
    _loadCustomers();
  }

  void _showOptionsDialog(BuildContext context, Customer customer) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text("Uptade"),
              onTap: () {
                Navigator.pop(context);
                _showUpdateDialog(context, customer);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete"),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(context, customer.id!);
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, Customer customer) {
    TextEditingController nameController = TextEditingController(text: customer.name);
    TextEditingController dobController = TextEditingController(text: customer.dateOfBirth);
    TextEditingController balanceController = TextEditingController(text: customer.balance.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Uptade Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "İsim")),
              TextField(controller: dobController, decoration: InputDecoration(labelText: "Doğum Tarihi")),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(labelText: "Balance"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text;
                String dob = dobController.text;
                double? balance = double.tryParse(balanceController.text);

                if (name.isNotEmpty && dob.isNotEmpty && balance != null) {
                  Customer updatedCustomer = Customer(
                    id: customer.id,
                    name: name,
                    dateOfBirth: dob,
                    balance: balance,
                  );

                  await database_helper.instance.updateCustomer(updatedCustomer);
                  _loadCustomers();
                  Navigator.pop(context);
                }
              },
              child: Text("Uptade", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer List")),
      body: _customerList.isEmpty
          ? Center(child: Text("No Customer Records"))
          : ListView.builder(
        itemCount: _customerList.length,
        itemBuilder: (context, index) {
          final customer = _customerList[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text("Date of Birth: ${customer.dateOfBirth} - Balance: \$${customer.balance}"),
            onLongPress: () {
              _showOptionsDialog(context, customer);
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCustomerScreen()),
          );
          if (result == true) {
            _loadCustomers();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
