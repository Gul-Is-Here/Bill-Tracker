import 'package:bill_tracker_app/app/controllers/bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final BillController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();

  DateTime? _dueDate;
  final List<String> categories = [
    'Rent',
    'Utilities',
    'Subscription',
    'Insurance',
    'Loan',
    'Other'
  ];
  final List<String> frequencies = ['Monthly', 'Weekly', 'Yearly'];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _categoryController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Bill', style: Get.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveBill,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildNameField(),
              const SizedBox(height: 16),
              _buildAmountField(),
              const SizedBox(height: 16),
              _buildDueDateField(),
              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildFrequencyField(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Bill Name',
        prefixIcon: const Icon(Icons.receipt),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a bill name';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixIcon: const Icon(Icons.attach_money),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildDueDateField() {
    return TextFormField(
      controller: _dueDateController,
      decoration: InputDecoration(
        labelText: 'Due Date',
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        if (selectedDate != null) {
          setState(() {
            _dueDate = selectedDate;
            _dueDateController.text =
                DateFormat('MMM dd, yyyy').format(selectedDate);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a due date';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      controller: _categoryController,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () {
        Get.bottomSheet(
          Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () {
                    _categoryController.text = categories[index];
                    Get.back();
                  },
                );
              },
            ),
          ),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildFrequencyField() {
    return TextFormField(
      controller: _frequencyController,
      decoration: InputDecoration(
        labelText: 'Frequency',
        prefixIcon: const Icon(Icons.repeat),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () {
        Get.bottomSheet(
          Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: frequencies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(frequencies[index]),
                  onTap: () {
                    _frequencyController.text = frequencies[index];
                    Get.back();
                  },
                );
              },
            ),
          ),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a frequency';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _saveBill,
        child: Text(
          'Save Bill',
          style: Get.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveBill() async {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      try {
        await controller.addBill(
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          dueDate: _dueDate!,
          frequency: _frequencyController.text,
          category: _categoryController.text,
        );
        Get.back();
        Get.snackbar(
          'Success',
          'Bill added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to add bill: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}