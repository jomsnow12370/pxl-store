import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(useMaterial3: true);
    final pixelPrimary = const Color(0xFF111111);
    final pixelAccent = const Color(0xFFF9D74B); // punchy yellow
    final pixelSurface = const Color(0xFFF2F2F2);
    final pixelShadow = const Color(0xFF000000);

    return MaterialApp(
      title: 'MRHY PXL Store',
      theme: base.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: pixelAccent,
          primary: pixelPrimary,
          secondary: pixelAccent,
          surface: pixelSurface,
          background: pixelSurface,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.pressStart2pTextTheme(base.textTheme).apply(
          bodyColor: pixelPrimary,
          displayColor: pixelPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: pixelAccent,
          foregroundColor: pixelPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: pixelPrimary,
          ),
        ),
        scaffoldBackgroundColor: pixelSurface,
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(width: 3, color: Colors.black),
          ),
          shadowColor: pixelShadow,
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: pixelAccent,
            foregroundColor: pixelPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(width: 3, color: Colors.black),
            ),
            textStyle: GoogleFonts.pressStart2p(fontSize: 12),
            shadowColor: pixelShadow,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: pixelPrimary,
            side: const BorderSide(width: 3, color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            textStyle: GoogleFonts.pressStart2p(fontSize: 12),
            shadowColor: pixelShadow,
          ),
        ),
        iconTheme: IconThemeData(color: pixelPrimary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(width: 3, color: pixelAccent),
          ),
          hintStyle: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black54),
          labelStyle: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black87),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Container(
                    height: 340,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_esports,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
            Text(
                              'SIGN IN',
                              style: GoogleFonts.pressStart2p(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'USERNAME',
                            hintText: 'player_one',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            hintText: '●●●●●●●●',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            final user = _usernameController.text.trim();
                            final pass = _passwordController.text;
                            if (user.isEmpty || pass.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('ENTER USERNAME AND PASSWORD')),
                              );
                              return;
                            }
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('LOGIN'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0; // 0: Home, 1: Inventory, 2: POS, 3: Sales, 4: Expenses

  // Mock data for dashboard
  final double _todaySales = 1250.00;
  final double _todayExpenses = 420.00;

  final List<Map<String, dynamic>> _categoryBreakdown = const [
    {'name': 'Tops', 'percent': 45, 'color': Color(0xFFF9D74B)},
    {'name': 'Bottoms', 'percent': 35, 'color': Color(0xFF8CC0FF)},
    {'name': 'Accessories', 'percent': 20, 'color': Color(0xFF7AE582)},
  ];

  final List<Map<String, dynamic>> _topProducts = const [
    {'name': 'Graphic Tee', 'units': 18},
    {'name': 'Denim Jeans', 'units': 12},
    {'name': 'Hoodie', 'units': 9},
  ];

  final List<Map<String, dynamic>> _outOfStock = const [
    {'name': 'Black Cap', 'sku': 'ACC-BC-001'},
    {'name': 'White Socks', 'sku': 'ACC-WS-002'},
  ];

  final List<Map<String, dynamic>> _products = const [
    {
      'name': 'Graphic Tee',
      'price': 25.00,
      'cost': 9.50,
      'thumb': null,
      'variants': [
        {'size': 'S', 'color': 'Black', 'stock': 8},
        {'size': 'M', 'color': 'Black', 'stock': 4},
        {'size': 'L', 'color': 'Black', 'stock': 0},
      ],
    },
    {
      'name': 'Denim Jeans',
      'price': 48.00,
      'cost': 20.00,
      'thumb': null,
      'variants': [
        {'size': '30', 'color': 'Blue', 'stock': 3},
        {'size': '32', 'color': 'Blue', 'stock': 6},
      ],
    },
    {
      'name': 'Classic Hoodie',
      'price': 38.00,
      'cost': 15.00,
      'thumb': null,
      'variants': [
        {'size': 'M', 'color': 'Gray', 'stock': 2},
        {'size': 'L', 'color': 'Gray', 'stock': 1},
      ],
    },
  ];

  void _onTap(int i) {
    setState(() => _index = i);
    if (i != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnim, child: child),
                );
              },
              child: _buildTabBody(_index),
            ),
          ),
        ),
      ),
      floatingActionButton: _index == 2
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Sale — Coming soon')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('NEW SALE'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black87,
        currentIndex: _index,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'POS'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sales'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Expenses'),
        ],
      ),
    );
  }

  Widget _buildTabBody(int index) {
    switch (index) {
      case 0:
        return const _ComingSoon(key: ValueKey('home'), label: 'HOME');
      case 1:
        return _InventoryScreen(key: const ValueKey('inventory-screen'));
      case 2:
        return const _ComingSoon(key: ValueKey('pos'), label: 'POINT OF SALE');
      case 3:
        return const _ComingSoon(key: ValueKey('sales'), label: 'SALES');
      case 4:
        return const _ComingSoon(key: ValueKey('expenses'), label: 'EXPENSES');
      default:
        return const SizedBox.shrink();
    }
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black),
        ),
        Card(
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title — Coming soon')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(width: 3, color: Colors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.black, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.pressStart2p(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    subtitle,
                    style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String label;
  const _ComingSoon({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.black),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'COMING SOON',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: GoogleFonts.pressStart2p(fontSize: 12),
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                right: 0,
                bottom: 0,
                child: Container(color: Colors.black),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _KpiTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 3, color: Colors.black),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.pressStart2p(fontSize: 10)),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.pressStart2p(fontSize: 14)),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  const _BadgeTile({required this.color, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 3, color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 18),
              const SizedBox(width: 8),
              Text(title.toUpperCase(), style: GoogleFonts.pressStart2p(fontSize: 10)),
            ],
          ),
          Text(subtitle, style: GoogleFonts.pressStart2p(fontSize: 10)),
        ],
      ),
    );
  }
}

enum _RowTone { normal, warning }

class _ListRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final _RowTone tone;

  const _ListRow({required this.title, this.subtitle, this.trailing, this.tone = _RowTone.normal});

  @override
  Widget build(BuildContext context) {
    final Color border = Colors.black;
    final Color bg = tone == _RowTone.warning ? const Color(0xFFFFE1E1) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(width: 3, color: border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.pressStart2p(fontSize: 10)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87)),
                ],
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing!, style: GoogleFonts.pressStart2p(fontSize: 10)),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final String name;
  final double price;
  final double cost;
  final List<Map<String, dynamic>> variants;

  const _ProductTile({required this.name, required this.price, required this.cost, required this.variants});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 8,
          left: 8,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    border: Border.all(width: 3, color: Colors.black),
                  ),
                  child: const Icon(Icons.image, size: 20, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.pressStart2p(fontSize: 11)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: variants.map((v) {
                          final String size = v['size'].toString();
                          final String color = v['color'].toString();
                          final int stock = v['stock'] as int;
                          final Color chipBg = stock == 0 ? const Color(0xFFFFE1E1) : Colors.white;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: chipBg,
                              border: Border.all(width: 3, color: Colors.black),
                            ),
                            child: Text(
                              '$size / $color • $stock',
                              style: GoogleFonts.pressStart2p(fontSize: 9),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_currency(price), style: GoogleFonts.pressStart2p(fontSize: 11)),
                    const SizedBox(height: 4),
                    Text('Cost ${_currency(cost)}', style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _currency(double v) => ' 24' + v.toStringAsFixed(2);

class _InventoryScreen extends StatefulWidget {
  const _InventoryScreen({super.key});

  @override
  State<_InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<_InventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<_ProductListState> _productListKey = GlobalKey<_ProductListState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Refresh product list when switching to View Products tab
      if (_tabController.index == 0 && _productListKey.currentState != null) {
        _productListKey.currentState!._loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.pressStart2p(fontSize: 12),
          tabs: const [
            Tab(text: 'VIEW PRODUCTS'),
            Tab(text: 'ADD PRODUCT'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ProductList(
                key: _productListKey,
              ),
              _InventoryForm(
                key: const ValueKey('inventory-form'),
                onProductSaved: () {
                  // Switch to View Products tab and refresh after saving
                  _tabController.animateTo(0);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _productListKey.currentState?._loadProducts();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductList extends StatefulWidget {
  const _ProductList({super.key});

  @override
  State<_ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<_ProductList> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Expose method to parent
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await ApiService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ERROR',
              style: GoogleFonts.pressStart2p(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('RETRY'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NO PRODUCTS YET',
              style: GoogleFonts.pressStart2p(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Add your first product to get started',
              style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.black87),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = _products[index];
          final variations = (product['variations'] as List?) ?? [];
          return _ProductCard(
            product: product,
            variations: variations,
            onUpdated: _loadProducts,
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final List<dynamic> variations;
  final VoidCallback onUpdated;

  const _ProductCard({
    required this.product,
    required this.variations,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? 'Unknown';
    final cost = (product['cost'] as num?)?.toDouble() ?? 0.0;
    final price = (product['price'] as num?)?.toDouble();

    return Stack(
      children: [
        Positioned(
          top: 8,
          left: 8,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    border: Border.all(width: 3, color: Colors.black),
                  ),
                  child: product['photo_url'] != null
                      ? Image.network(
                          product['photo_url'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20, color: Colors.black54),
                        )
                      : const Icon(Icons.image, size: 20, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.pressStart2p(fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      if (variations.isEmpty)
                        Text(
                          'No variations',
                          style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black54),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: variations.map<Widget>((v) {
                            final color = v['color']?.toString() ?? '';
                            final size = v['size']?.toString() ?? '';
                            final qty = (v['quantity'] as num?)?.toInt() ?? 0;
                            final chipBg = qty == 0 ? const Color(0xFFFFE1E1) : Colors.white;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: chipBg,
                                border: Border.all(width: 3, color: Colors.black),
                              ),
                              child: Text(
                                '$size / $color • $qty',
                                style: GoogleFonts.pressStart2p(fontSize: 9),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (price != null)
                      Text(
                        _currency(price),
                        style: GoogleFonts.pressStart2p(fontSize: 11),
                      )
                    else
                      Text(
                        'No price',
                        style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black54),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Cost ${_currency(cost)}',
                      style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InventoryForm extends StatefulWidget {
  final VoidCallback? onProductSaved;

  const _InventoryForm({super.key, this.onProductSaved});

  @override
  State<_InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<_InventoryForm> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _costCtrl = TextEditingController();
  final List<_VariationRowData> _variations = [_VariationRowData()];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _costCtrl.dispose();
    for (final v in _variations) {
      v.dispose();
    }
    super.dispose();
  }

  void _addRow() => setState(() => _variations.add(_VariationRowData()));

  void _removeRow(int index) {
    if (_variations.length == 1) return;
    final removed = _variations.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;

    final name = _nameCtrl.text.trim();
    final cost = double.tryParse(_costCtrl.text.trim());
    if (name.isEmpty || cost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ENTER NAME AND COST')),
      );
      return;
    }

    final List<Map<String, dynamic>> variations = [];
    for (final v in _variations) {
      final color = v.colorCtrl.text.trim();
      final size = v.sizeCtrl.text.trim();
      final qty = int.tryParse(v.qtyCtrl.text.trim());
      if (color.isEmpty || size.isEmpty || qty == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FILL ALL VARIATION FIELDS')),
        );
        return;
      }
      variations.add({'color': color, 'size': size, 'quantity': qty});
    }

    setState(() => _isSaving = true);

    try {
      final response = await ApiService.createProduct(
        name: name,
        cost: cost,
        variations: variations,
      );

      // Clear form on success
      _nameCtrl.clear();
      _costCtrl.clear();
      while (_variations.length > 1) {
        _variations.removeLast().dispose();
      }
      _variations[0].colorCtrl.clear();
      _variations[0].sizeCtrl.clear();
      _variations[0].qtyCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PRODUCT SAVED SUCCESSFULLY!')),
        );
        // Notify parent to refresh product list and switch tabs
        widget.onProductSaved?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERROR: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'PRODUCT PHOTO',
            child: Row(
              children: [
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    border: Border.all(width: 3, color: Colors.black),
                  ),
                  child: const Icon(Icons.image, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Photo — UI only for now')),
                    );
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('ADD PHOTO'),
                ),
              ],
            ),
          ),
          _Section(
            title: 'DETAILS',
            child: Column(
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'PRODUCT NAME', hintText: 'Graphic Tee'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _costCtrl,
                  decoration: const InputDecoration(labelText: 'PRODUCT COST', hintText: 'e.g. 10.00', prefixText: '\u000024 '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          _Section(
            title: 'VARIATIONS (COLOR / SIZE / QTY)',
            child: Column(
              children: [
                for (int i = 0; i < _variations.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _variations[i].colorCtrl,
                            decoration: const InputDecoration(labelText: 'COLOR'),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _variations[i].sizeCtrl,
                            decoration: const InputDecoration(labelText: 'SIZE'),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _variations[i].qtyCtrl,
                            decoration: const InputDecoration(labelText: 'QTY'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _removeRow(i),
                          icon: const Icon(Icons.remove_circle_outline),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _addRow,
                    icon: const Icon(Icons.add),
                    label: const Text('ADD VARIATION'),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'SAVING...' : 'SAVE PRODUCT'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _nameCtrl.clear();
                  _costCtrl.clear();
                  for (final v in _variations) {
                    v.colorCtrl.clear();
                    v.sizeCtrl.clear();
                    v.qtyCtrl.clear();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cleared')),
                  );
                },
                icon: const Icon(Icons.clear),
                label: const Text('CLEAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VariationRowData {
  final TextEditingController colorCtrl = TextEditingController();
  final TextEditingController sizeCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();

  void dispose() {
    colorCtrl.dispose();
    sizeCtrl.dispose();
    qtyCtrl.dispose();
  }
}
