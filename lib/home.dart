import 'package:flutter/material.dart';
import 'package:fluttertask/productjson.dart';
import 'apisservise.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "Welcome to Products Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.thumbnail != null
                    ? Image.network(product.thumbnail!)
                    : Container(),
                title: Text(product.title ?? 'No title'),
                subtitle: Text(
                  'Brand: ${product.brand ?? 'Unknown'}\nPrice: \$${product.price ?? '0.00'}',
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/Details',
                    arguments: product.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
