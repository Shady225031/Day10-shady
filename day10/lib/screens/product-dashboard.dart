import 'package:day10/web_services/firebase_service.dart';
import 'package:flutter/material.dart';

class ProductDashboard extends StatefulWidget {
  const ProductDashboard({super.key});

  @override
  State<ProductDashboard> createState() => _ProductDashboardState();
}

class _ProductDashboardState extends State<ProductDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Map<String, dynamic> products = {};
  bool _isEditing = false;
  String? _editedProductId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductsData();
    });
  }

  void _saveData() async {
    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();

    if (name.isEmpty || priceText.isEmpty) return;

    try {
      final price = double.parse(priceText);
      var newProduct = {'name': name, 'price': price};

      if (_isEditing && _editedProductId != null) {
        await _firebaseService.editProduct(_editedProductId!, newProduct);
        setState(() {
          _isEditing = false;
          _editedProductId = null;
        });
      } else {
        await _firebaseService.addProduct(newProduct);
      }

      _nameController.clear();
      _priceController.clear();
      getProductsData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid price format"), backgroundColor: Colors.red),
      );
    }
  }

  void getProductsData() async {
    var response = await _firebaseService.getProducts();
    debugPrint("Products fetched: $response"); // طباعة لتتبع البيانات

    setState(() {
      products = response ?? {}; // التأكد من أن المنتجات لا تكون null
    });
  }

  void deleteProduct(String id) async {
    await _firebaseService.deleteProductData(id);
    getProductsData();
  }

  void _editProduct(String prodId, Map<String, dynamic> productData) {
    setState(() {
      _isEditing = true;
      _editedProductId = prodId;
      _nameController.text = productData['name'];
      _priceController.text = productData['price'].toString();
    });
  }

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_isEditing ? "Edit Product" : "Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _priceController.clear();
                setState(() {
                  _isEditing = false;
                  _editedProductId = null;
                });
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(_isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Product Dashboard'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: products.isEmpty
            ? Center(child: Text("No products added yet!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final productId = products.keys.elementAt(index);
                  final productData = products[productId];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(Icons.shopping_cart, color: Colors.teal),
                      ),
                      title: Text(
                        productData['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Price: 💲${productData['price']}',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editProduct(productId, productData),
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => deleteProduct(productId),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _showProductDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
