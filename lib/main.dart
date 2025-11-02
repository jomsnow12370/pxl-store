import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await ApiService.isLoggedIn();
    if (isLoggedIn && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiService.login(username, password);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'MRHY PXL STORE',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'INVENTORY MANAGEMENT',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'USERNAME',
                            hintText: 'Enter your username',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _login(),
                        ),
                        if (_errorMessage != null) ...{
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        },
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('SIGN IN'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final profile = await ApiService.getProfile();
      if (mounted) {
        setState(() {
          _userName = profile['username'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: ${e.toString()}')),
        );
        _logout();
      }
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _index == 1 ? 'INVENTORY' : 'DASHBOARD',
          style: GoogleFonts.pressStart2p(fontSize: 14),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_outlined),
            label: 'POS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Expenses',
          ),
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
  List<dynamic> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'all'; // all, in_stock, low_stock, out_of_stock

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        _filterProducts();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredProducts = _products.where((product) {
        final name = (product['name'] as String? ?? '').toLowerCase();
        final matchesSearch = name.contains(query);
        
        if (!matchesSearch) return false;
        
        // Calculate total stock for status filter
        final variations = (product['variations'] as List?) ?? [];
        int totalStock = 0;
        for (var v in variations) {
          totalStock += (v['quantity'] as num?)?.toInt() ?? 0;
        }
        
        // Apply status filter
        switch (_filterStatus) {
          case 'out_of_stock':
            return totalStock == 0;
          case 'low_stock':
            return totalStock > 0 && totalStock <= 5;
          case 'in_stock':
            return totalStock > 5;
          default:
            return true;
        }
      }).toList();
    });
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All (${_products.length})',
                      isSelected: _filterStatus == 'all',
                      onTap: () {
                        setState(() => _filterStatus = 'all');
                        _filterProducts();
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'In Stock',
                      isSelected: _filterStatus == 'in_stock',
                      onTap: () {
                        setState(() => _filterStatus = 'in_stock');
                        _filterProducts();
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Low Stock',
                      isSelected: _filterStatus == 'low_stock',
                      color: const Color(0xFFFF9800),
                      onTap: () {
                        setState(() => _filterStatus = 'low_stock');
                        _filterProducts();
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Out of Stock',
                      isSelected: _filterStatus == 'out_of_stock',
                      color: const Color(0xFFF44336),
                      onTap: () {
                        setState(() => _filterStatus = 'out_of_stock');
                        _filterProducts();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    'NO PRODUCTS FOUND',
                    style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.black54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProducts,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final variations = (product['variations'] as List?) ?? [];
                      return _ProductCard(
                        product: product,
                        variations: variations,
                        onUpdated: _loadProducts,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Theme.of(context).colorScheme.primary) : Colors.white,
          border: Border.all(
            width: 2,
            color: isSelected ? (color ?? Theme.of(context).colorScheme.primary) : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.pressStart2p(
            fontSize: 9,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
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

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? 'Unknown';
    final cost = _parseDouble(product['cost']) ?? 0.0;
    final price = _parseDouble(product['price']);
    final id = product['id'] as int;
    
    // Calculate total stock and profit margin
    int totalStock = 0;
    for (var v in variations) {
      totalStock += (v['quantity'] as num?)?.toInt() ?? 0;
    }
    
    final profitMargin = (price != null && cost > 0) 
        ? ((price - cost) / cost) * 100 
        : null;
    
    // Determine stock status
    final bool isOutOfStock = totalStock == 0;
    final bool isLowStock = totalStock > 0 && totalStock <= 5;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.pressStart2p(fontSize: 11),
                                ),
                              ),
                              if (isOutOfStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF44336),
                                    border: Border.all(width: 2, color: Colors.black),
                                  ),
                                  child: Text(
                                    'OUT',
                                    style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.white),
                                  ),
                                )
                              else if (isLowStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800),
                                    border: Border.all(width: 2, color: Colors.black),
                                  ),
                                  child: Text(
                                    'LOW',
                                    style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.white),
                                  ),
                                ),
                            ],
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
                        if (profitMargin != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${profitMargin.toStringAsFixed(0)}% profit',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 8,
                              color: profitMargin > 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Stock: $totalStock',
                      style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.black87),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () => _showEditDialog(context, product, variations),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('EDIT'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context, id, name),
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      label: const Text('DELETE', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.red),
                      ),
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> product, List<dynamic> variations) {
    // TODO: Implement edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming next!')),
    );
  }

  void _showDeleteDialog(BuildContext context, int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('DELETE PRODUCT?', style: GoogleFonts.pressStart2p(fontSize: 12)),
        content: Text(
          'Are you sure you want to delete "$name"? This action cannot be undone.',
          style: GoogleFonts.pressStart2p(fontSize: 10),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ApiService.deleteProduct(id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PRODUCT DELETED SUCCESSFULLY!')),
          );
          onUpdated();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ERROR: ${e.toString()}')),
          );
        }
      }
    }
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
  final TextEditingController _priceCtrl = TextEditingController();
  final List<_VariationRowData> _variations = [_VariationRowData()];
  double? _profitMargin;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _costCtrl.dispose();
    _priceCtrl.dispose();
    for (final v in _variations) {
      v.dispose();
    }
    super.dispose();
  }

  void _calculateProfitMargin() {
    final cost = double.tryParse(_costCtrl.text.trim());
    final price = double.tryParse(_priceCtrl.text.trim());
    
    if (cost != null && price != null && cost > 0) {
      setState(() {
        _profitMargin = ((price - cost) / cost) * 100;
      });
    } else {
      setState(() {
        _profitMargin = null;
      });
    }
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
    final price = double.tryParse(_priceCtrl.text.trim());
    
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
        price: price,
        variations: variations,
      );

      // Clear form on success
      _nameCtrl.clear();
      _costCtrl.clear();
      _priceCtrl.clear();
      while (_variations.length > 1) {
        _variations.removeLast().dispose();
      }
      _variations[0].colorCtrl.clear();
      _variations[0].sizeCtrl.clear();
      _variations[0].qtyCtrl.clear();
      setState(() => _profitMargin = null);

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
                  decoration: const InputDecoration(
                    labelText: 'COST (What you paid)',
                    hintText: 'e.g. 10.00',
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _calculateProfitMargin(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'SELLING PRICE (What customers pay)',
                    hintText: 'e.g. 25.00',
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _calculateProfitMargin(),
                ),
                if (_profitMargin != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _profitMargin! > 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      border: Border.all(
                        width: 2,
                        color: _profitMargin! > 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFIT MARGIN:',
                          style: GoogleFonts.pressStart2p(fontSize: 10),
                        ),
                        Text(
                          '${_profitMargin!.toStringAsFixed(1)}%',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            color: _profitMargin! > 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  _priceCtrl.clear();
                  for (final v in _variations) {
                    v.colorCtrl.clear();
                    v.sizeCtrl.clear();
                    v.qtyCtrl.clear();
                  }
                  setState(() => _profitMargin = null);
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
