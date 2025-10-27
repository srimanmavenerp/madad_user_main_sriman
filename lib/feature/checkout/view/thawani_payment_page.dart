import 'package:flutter/material.dart';
import 'package:thawani_payment/models/products.dart';
import 'package:thawani_payment/pay.dart';
import 'package:thawani_payment/viewmodel/thawani_customerdelete.dart';
import 'package:uuid/uuid.dart';


class Thawani_Payment_Page extends StatefulWidget {
  const Thawani_Payment_Page({super.key});

  @override
  State<Thawani_Payment_Page> createState() => _Thawani_Payment_PageState();
}

class _Thawani_Payment_PageState extends State<Thawani_Payment_Page> {
  final _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController(text: "Sample Item");
  final TextEditingController _productQuantityController = TextEditingController(text: "1");
  final TextEditingController _productUnitAmountController = TextEditingController(text: "1000");

  // final Uuid _uuid = const Uuid();

  // void _startPayment() {
  //   if (_formKey.currentState!.validate()) {
  //     final orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";
  //     final customerId = _uuid.v4();
  //
  //     final productName = _productNameController.text.trim();
  //     final productQuantity = int.tryParse(_productQuantityController.text.trim()) ?? 1;
  //     final productUnitAmount = int.tryParse(_productUnitAmountController.text.trim()) ?? 1000;
  //     final customerName = _customerNameController.text.trim();
  //     final customerEmail = _customerEmailController.text.trim();
  //
  //     Thawani.pay(
  //       context,
  //       testMode: false, // Live mode
  //
  //       //  Replace these with your actual LIVE keys from Thawani dashboard
  //       api: 'E2JMVr1VhnGCblcbRlVVCm9vNSyAWW', // Secret Key (keep safe!)
  //       pKey: '2E0VZEnCu4Mrc45uPHGbC75d9xJAHk', // Public Key
  //
  //       //  Don't pass hardcoded customer ID in live mode
  //       clintID: '', //or omit to auto-create
  //
  //       metadata: {
  //         "order_id": orderId,
  //         "customer_id": customerId,
  //         "customer_name": customerName,
  //         "customer_email": customerEmail,
  //       },
  //
  //       products: [
  //         Product(
  //           name: productName,
  //           quantity: productQuantity,
  //           unitAmount: productUnitAmount,
  //         ),
  //       ],
  //
  //       saveCard: true,
  //
  //       onError: (e) => print(' Error: $e'),
  //       onCreate: (v) => print(' Session Created: ${v.data}'),
  //       onCancelled: (v) => print(' Payment Cancelled: $v'),
  //       onPaid: (v) => print('Payment Success: $v'),
  //
  //       savedCards: (cards) => print(' Saved cards: ${cards.length}'),
  //       getSavedCustomer: (id) => print(' Saved customer ID: $id'),
  //
  //       onCreateCustomer: (data) {
  //         print(' New customer created: $data');
  //         // Optional: Save the customer ID locally for reuse
  //       },
  //     );
  //   }
  // }


  void _startPayment() async {
    if (_formKey.currentState!.validate()) {
      //  Clear old saved customer
      await ThawaniCustomer.delete();

      final orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";
      final productName = _productNameController.text.trim();
      final productQuantity = int.tryParse(_productQuantityController.text.trim()) ?? 1;
      final productUnitAmount = int.tryParse(_productUnitAmountController.text.trim()) ?? 1000;
      final customerName = _customerNameController.text.trim();
      final customerEmail = _customerEmailController.text.trim();

      //// Generate a valid
      final String clientCustomerId = _uuid.v4();

      Thawani.pay(
        context,
        api: 'E2JMVr1VhnGCblcbRlVVCm9vNSyAWW',
        pKey: '2E0VZEnCu4Mrc45uPHGbC75d9xJAHk',
        clintID: clientCustomerId,

        metadata: {
          "order_id": orderId,
          "customer_name": customerName,
          "customer_email": customerEmail,
        },

        products: [
          Product(
            name: productName,
            quantity: productQuantity,
            unitAmount: productUnitAmount,
          ),
        ],

        saveCard: true,

        onError: (e) => print('Error: $e'),
        onCreate: (v) => print('Session Created: ${v.data}'),
        onCancelled: (v) => print(' Payment Cancelled: $v'),
        onPaid: (v) => print(' Payment Success: $v'),
        onCreateCustomer: (data) {
          print(' New customer created: $data');
        },
      );
    }
  }


  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _productNameController.dispose();
    _productQuantityController.dispose();
    _productUnitAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thawani Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: "Customer Name"),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Please enter customer name"
                    : null,
              ),
              TextFormField(
                controller: _customerEmailController,
                decoration: const InputDecoration(labelText: "Customer Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter customer email";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Please enter product name"
                    : null,
              ),
              TextFormField(
                controller: _productQuantityController,
                decoration: const InputDecoration(labelText: "Product Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1) {
                    return "Quantity must be at least 1";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productUnitAmountController,
                decoration: const InputDecoration(
                    labelText: "Product Unit Amount (e.g. 1000 = 10.00)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1) {
                    return "Amount must be positive";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _startPayment,
                child: const Text("Pay Using Thawani"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}