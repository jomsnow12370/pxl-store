import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
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
          _index == 1 ? 'INVENTORY' : _index == 3 ? 'CONFIG' : 'DASHBOARD',
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, -4),
              blurRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[700],
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                size: 24,
                color: _index == 0 ? const Color(0xFF4CAF50) : Colors.black,
              ),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag,
                size: 24,
                color: _index == 1 ? const Color(0xFF2196F3) : Colors.black,
              ),
              label: 'INVENTORY',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.point_of_sale,
                size: 24,
                color: _index == 2 ? const Color(0xFFFF9800) : Colors.black,
              ),
              label: 'POS',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 24,
                color: _index == 3 ? const Color(0xFF9E9E9E) : Colors.black,
              ),
              label: 'CONFIG',
            ),
                      ],
        ),
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
        return const POSScreen(key: ValueKey('pos-screen'));
      case 3:
        return const _ConfigScreen(key: ValueKey('config-screen'));
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
            Tab(text: 'VIEW ITEMS'),
            Tab(text: 'ADD ITEM'),
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

  int _getTotalStock() {
    int totalStock = 0;
    for (var product in _filteredProducts) {
      final variations = (product['variations'] as List?) ?? [];
      for (var v in variations) {
        totalStock += (v['quantity'] as num?)?.toInt() ?? 0;
      }
    }
    return totalStock;
  }

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
          child: Column(
            children: [
              // Inventory header with capacity
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50),
                  border: const Border(
                    top: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                    right: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '🎒',
                          style: GoogleFonts.pressStart2p(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ITEM INVENTORY',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            color: const Color(0xFFECF0F1),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34495E),
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '(${_getTotalStock()})',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 10,
                          color: const Color(0xFFECF0F1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Grid view for items
              Expanded(
                child: _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '📦',
                              style: GoogleFonts.pressStart2p(fontSize: 48),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'NO ITEMS FOUND',
                              style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProducts,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            final variations = (product['variations'] as List?) ?? [];
                            return _InventoryItemCard(
                              product: product,
                              variations: variations,
                              onUpdated: _loadProducts,
                            );
                          },
                        ),
                      ),
              ),
            ],
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

class _InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final List<dynamic> variations;
  final VoidCallback onUpdated;

  const _InventoryItemCard({
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

  String _getItemIcon(String itemName) {
    final name = itemName.toLowerCase();
    if (name.contains('shirt') || name.contains('tee')) return '👕';
    if (name.contains('pants') || name.contains('jeans')) return '👖';
    if (name.contains('cap') || name.contains('hat')) return '🧢';
    if (name.contains('shoes') || name.contains('sneakers')) return '👟';
    if (name.contains('watch') || name.contains('time')) return '⌚';
    if (name.contains('bag') || name.contains('backpack')) return '🎒';
    if (name.contains('phone') || name.contains('mobile')) return '📱';
    if (name.contains('laptop') || name.contains('computer')) return '💻';
    if (name.contains('headphone') || name.contains('ear')) return '🎧';
    if (name.contains('camera') || name.contains('photo')) return '📷';
    if (name.contains('game') || name.contains('controller')) return '🎮';
    return '📦'; // Default icon
  }

  void _showDeleteDialog(BuildContext context, int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('DELETE ITEM?', style: GoogleFonts.pressStart2p(fontSize: 12)),
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

    if (confirmed == true) {
      try {
        await ApiService.deleteProduct(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ITEM DELETED SUCCESSFULLY!')),
        );
        onUpdated(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? 'Unknown';
    final price = _parseDouble(product['price']) ?? 0.0;
    final photoUrl = product['photo_url'] as String?;
    
    // Calculate total stock
    int totalStock = 0;
    for (var v in variations) {
      totalStock += (v['quantity'] as num?)?.toInt() ?? 0;
    }
    
    final isInStock = totalStock > 0;
    final itemIcon = _getItemIcon(name);

    return GestureDetector(
      onTap: () {
        // Show item details dialog
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            child: Container(
              width: 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E50),
                      border: const Border(
                        top: BorderSide(color: Colors.black, width: 3),
                        left: BorderSide(color: Colors.black, width: 3),
                        right: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name.toUpperCase(),
                          style: GoogleFonts.pressStart2p(
                            fontSize: 14,
                            color: const Color(0xFFECF0F1),
                          ),
                        ),
                        Text(
                          itemIcon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  // Content (Scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.black, width: 3),
                            right: BorderSide(color: Colors.black, width: 3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (photoUrl != null && photoUrl.isNotEmpty)
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: ClipRRect(
                                  child: Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(Icons.image, size: 48),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (photoUrl != null && photoUrl.isNotEmpty)
                              const SizedBox(height: 16),
                            // Price section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '💰 PRICE',
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '₱${price.toStringAsFixed(2)}',
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 16,
                                          color: const Color(0xFF27AE60),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '📦 TOTAL',
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '$totalStock units',
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 12,
                                          color: isInStock ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Variations section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2C3E50),
                                    const Color(0xFF34495E),
                                  ],
                                ),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '🎮 VARIATIONS',
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 10,
                                          color: const Color(0xFFECF0F1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3498DB),
                                          border: Border.all(color: Colors.black, width: 1),
                                        ),
                                        child: Text(
                                          '${variations.length} types',
                                          style: GoogleFonts.pressStart2p(
                                            fontSize: 8,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    color: const Color(0xFF7F8C8D),
                                  ),
                                  const SizedBox(height: 8),
                                  ...variations.map((v) {
                                    final color = v['color'] as String? ?? '';
                                    final size = v['size'] as String? ?? '';
                                    final qty = (v['quantity'] as num?)?.toInt() ?? 0;
                                    final isLow = qty > 0 && qty <= 5;
                                    final isEmpty = qty == 0;
                                    
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isEmpty 
                                              ? const Color(0xFFE74C3C).withOpacity(0.2)
                                              : isLow 
                                                  ? const Color(0xFFF39C12).withOpacity(0.2)
                                                  : const Color(0xFF27AE60).withOpacity(0.2),
                                          border: Border.all(
                                            color: isEmpty 
                                                ? const Color(0xFFE74C3C)
                                                : isLow 
                                                    ? const Color(0xFFF39C12)
                                                    : const Color(0xFF27AE60),
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Color badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.black, width: 1),
                                              ),
                                              child: Text(
                                                color.toUpperCase(),
                                                style: GoogleFonts.pressStart2p(
                                                  fontSize: 8,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            // Size badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.black, width: 1),
                                              ),
                                              child: Text(
                                                size.toUpperCase(),
                                                style: GoogleFonts.pressStart2p(
                                                  fontSize: 8,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            // Stock indicator
                                            Row(
                                              children: [
                                                Text(
                                                  isEmpty ? '❌' : isLow ? '⚠️' : '✅',
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'x$qty',
                                                  style: GoogleFonts.pressStart2p(
                                                    fontSize: 10,
                                                    color: isEmpty 
                                                        ? const Color(0xFFE74C3C)
                                                        : isLow 
                                                            ? const Color(0xFFF39C12)
                                                            : const Color(0xFF27AE60),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Actions
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 3),
                        right: BorderSide(color: Colors.black, width: 3),
                        bottom: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Text(
                              'CLOSE',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // TODO: Add edit functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Text(
                              'EDIT',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showDeleteDialog(context, product['id'] as int, name);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE74C3C),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Text(
                              'DELETE',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isInStock ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
          border: Border.all(
            color: isInStock ? Colors.black : Colors.red,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Item icon or image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            itemIcon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          itemIcon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
              ),
            ),
            // Item name
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name.length > 7 
                          ? '${name.substring(0, 5)}...'
                          : name,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 7,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'x$totalStock',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 6,
                        color: isInStock ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      '💰${price.toInt()}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 6,
                        color: const Color(0xFF27AE60),
                        fontWeight: FontWeight.bold,
                      ),
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
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.3),
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
        title: Text('DELETE ITEM?', style: GoogleFonts.pressStart2p(fontSize: 12)),
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
  File? _selectedImage;
  Uint8List? _webImageBytes; // For web platform
  String? _uploadedImageUrl;
  bool _isUploading = false;

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

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          // For web, read bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
          });
        } else {
          // For mobile/desktop, use file
          setState(() {
            _selectedImage = File(image.path);
          });
        }
        
        // Upload the image
        _uploadImage(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadImage(XFile imageFile) async {
    setState(() {
      _isUploading = true;
    });
    
    try {
      final result = await ApiService.uploadPhotoFromXFile(imageFile);
      
      print('DEBUG: Upload result: $result');
      
      if (result['success'] == true) {
        final baseUrl = ApiService.getBaseUrl().replaceAll('/api', '');
        final fullUrl = '$baseUrl${result['data']['url']}';
        
        print('DEBUG: Base URL: $baseUrl');
        print('DEBUG: Photo URL from server: ${result['data']['url']}');
        print('DEBUG: Final photo URL: $fullUrl');
        
        setState(() {
          _uploadedImageUrl = fullUrl;
          _isUploading = false;
        });
        
        print('DEBUG: _uploadedImageUrl set to: $_uploadedImageUrl');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo uploaded! URL: ${_uploadedImageUrl?.substring(0, 50)}...')),
          );
        }
      } else {
        print('DEBUG: Upload returned success: false');
        throw Exception(result['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print('DEBUG: Upload caught exception: $e');
      
      setState(() {
        _isUploading = false;
      });
      
      if (mounted) {
        // Show error in a dialog for better visibility
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Upload Failed'),
            content: SingleChildScrollView(
              child: Text('Error: $e'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _webImageBytes = null;
      _uploadedImageUrl = null;
    });
  }

  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;
    
    // Check if photo is still uploading
    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PLEASE WAIT FOR PHOTO TO UPLOAD')),
      );
      return;
    }

    final name = _nameCtrl.text.trim();
    final cost = double.tryParse(_costCtrl.text.trim());
    final price = double.tryParse(_priceCtrl.text.trim());
    
    if (name.isEmpty || cost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ENTER NAME AND COST')),
      );
      return;
    }
    
    // Warn if image was selected but upload failed
    if ((_selectedImage != null || _webImageBytes != null) && _uploadedImageUrl == null) {
      print('DEBUG: WARNING - Image selected but upload URL is null!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo upload may have failed. Product will be saved without photo.'),
          duration: Duration(seconds: 3),
        ),
      );
      await Future.delayed(const Duration(seconds: 1)); // Give user time to see the message
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

    print('DEBUG: About to save product with photo URL: $_uploadedImageUrl');

    try {
      final response = await ApiService.createProduct(
        name: name,
        cost: cost,
        price: price,
        photoUrl: _uploadedImageUrl,
        variations: variations,
      );
      
      print('DEBUG: Product saved successfully. Response: $response');

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
      setState(() {
        _profitMargin = null;
        _selectedImage = null;
        _webImageBytes = null;
        _uploadedImageUrl = null;
      });

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
      padding: const EdgeInsets.all(16.0),
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
                  child: _isUploading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : kIsWeb && _webImageBytes != null
                          ? Image.memory(
                              _webImageBytes!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => 
                                  const Icon(Icons.image, color: Colors.black54),
                            )
                          : !kIsWeb && _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => 
                                      const Icon(Icons.image, color: Colors.black54),
                                )
                              : _uploadedImageUrl != null
                                  ? Image.network(
                                      _uploadedImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => 
                                          const Icon(Icons.image, color: Colors.black54),
                                    )
                                  : const Icon(Icons.image, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    if (_selectedImage == null && _webImageBytes == null && _uploadedImageUrl == null)
                      OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('ADD PHOTO'),
                      ),
                    if (_selectedImage != null || _webImageBytes != null || _uploadedImageUrl != null) ...[
                      OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.edit),
                        label: const Text('CHANGE'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete),
                        label: const Text('REMOVE'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ],
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
                  decoration: const InputDecoration(labelText: 'ITEM NAME', hintText: 'Graphic Tee'),
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
            title: 'VARIATIONS',
            child: Column(
              children: [
                for (int i = 0; i < _variations.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: _variations[i].colorCtrl.text.isEmpty ? null : _variations[i].colorCtrl.text,
                            decoration: const InputDecoration(
                              labelText: 'COLOR',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            isExpanded: true,
                            items: ['Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Gray', 'Pink']
                                .map((color) => DropdownMenuItem(
                                      value: color,
                                      child: Text(color, style: const TextStyle(fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                _variations[i].colorCtrl.text = value;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: _variations[i].sizeCtrl.text.isEmpty ? null : _variations[i].sizeCtrl.text,
                            decoration: const InputDecoration(
                              labelText: 'SIZE',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            isExpanded: true,
                            items: ['XS', 'S', 'M', 'L', 'XL', 'XXL', '30', '32', '34', '36']
                                .map((size) => DropdownMenuItem(
                                      value: size,
                                      child: Text(size, style: const TextStyle(fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                _variations[i].sizeCtrl.text = value;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _variations[i].qtyCtrl,
                            decoration: const InputDecoration(
                              labelText: 'QTY',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () => _removeRow(i),
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          tooltip: 'Remove',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final List<Map<String, dynamic>> _cart = [];
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];
  bool _isLoading = true;
  
  double _subtotal = 0.0;
  double _total = 0.0;

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

  Future<void> _loadProducts() async {
    try {
      final products = await ApiService.getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: ${e.toString()}')),
        );
      }
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final name = product['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    // Show variation picker for products with variations
    final variations = product['variations'] as List? ?? [];
    if (variations.isNotEmpty) {
      _showVariationPicker(product, variations);
    } else {
      // Add directly if no variations
      _addVariationToCart(product, {});
    }
  }

  void _showVariationPicker(Map<String, dynamic> product, List<dynamic> variations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'SELECT VARIATION',
          style: GoogleFonts.pressStart2p(fontSize: 12),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: variations.length,
            itemBuilder: (context, index) {
              final variation = variations[index] as Map<String, dynamic>;
              final size = variation['size']?.toString() ?? 'N/A';
              final color = variation['color']?.toString() ?? 'N/A';
              final quantity = variation['quantity'] as int? ?? 0;
              final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    '$size / $color',
                    style: GoogleFonts.pressStart2p(fontSize: 10),
                  ),
                  subtitle: Text(
                    'Stock: $quantity',
                    style: GoogleFonts.pressStart2p(fontSize: 8),
                  ),
                  trailing: Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: GoogleFonts.pressStart2p(fontSize: 10),
                  ),
                  onTap: quantity > 0
                      ? () {
                          Navigator.of(context).pop();
                          _addVariationToCart(product, variation);
                        }
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL', style: GoogleFonts.pressStart2p(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  void _addVariationToCart(Map<String, dynamic> product, Map<String, dynamic> variation) {
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    
    setState(() {
      _cart.add({
        'product': product,
        'variation': variation,
        'quantity': 1,
        'price': price,
        'lineTotal': price,
      });
      _calculateTotals();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ITEM ADDED TO CART!')),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
      _calculateTotals();
    });
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeFromCart(index);
      return;
    }
    
    setState(() {
      _cart[index]['quantity'] = quantity;
      _cart[index]['lineTotal'] = _cart[index]['price'] * quantity;
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    _subtotal = _cart.fold(0.0, (sum, item) => sum + (item['lineTotal'] as double));
    _total = _subtotal;
  }

  void _checkout() {
    if (_cart.isEmpty) return;
    _showCashPaymentDialog();
  }

  void _showCashPaymentDialog() {
    double cashReceived = 0.0;
    double change = 0.0;
    final TextEditingController cashController = TextEditingController(text: '0.00');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void updateChange() {
            cashReceived = double.tryParse(cashController.text.replaceAll(',', '')) ?? 0.0;
            change = cashReceived - _total;
            setState(() {});
          }
          
          void addAmount(double amount) {
            cashReceived = double.tryParse(cashController.text.replaceAll(',', '')) ?? 0.0;
            cashReceived += amount;
            cashController.text = cashReceived.toStringAsFixed(2);
            updateChange();
          }
          
          void setExactAmount() {
            cashController.text = _total.toStringAsFixed(2);
            updateChange();
          }
          
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CASH PAYMENT',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Icon(Icons.money, color: Colors.green, size: 20),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Total Due
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL DUE:',
                              style: GoogleFonts.pressStart2p(fontSize: 10),
                            ),
                            Text(
                              '₱${_total.toStringAsFixed(2)}',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 12,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Cash Received Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CASH RECEIVED',
                              style: GoogleFonts.pressStart2p(fontSize: 8),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '₱',
                                    style: GoogleFonts.pressStart2p(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: cashController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.pressStart2p(fontSize: 16),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (value) => updateChange(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Change
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDD835),
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CHANGE:',
                                style: GoogleFonts.pressStart2p(fontSize: 10),
                              ),
                              Text(
                                '₱${change >= 0 ? change.toStringAsFixed(2) : '0.00'}',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 12,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Quick Amount Buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildQuickAmountButton('+100', () => addAmount(100)),
                            _buildQuickAmountButton('+200', () => addAmount(200)),
                            _buildQuickAmountButton('+500', () => addAmount(500)),
                            _buildQuickAmountButton('+1000', () => addAmount(1000)),
                            _buildExactButton(setExactAmount),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              cashController.dispose();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF44336),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Text(
                              'CANCEL',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: change >= 0
                                ? () {
                                    cashController.dispose();
                                    Navigator.of(context).pop();
                                    _processCheckout('cash', cashReceived, change);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Text(
                              'COMPLETE',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10,
                                color: change >= 0 ? const Color(0xFF4CAF50) : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAmountButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.pressStart2p(
            fontSize: 9,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExactButton(VoidCallback onTap) {
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: Text(
          'EXACT',
          style: GoogleFonts.pressStart2p(
            fontSize: 9,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processCheckout(String paymentMethod, double cashReceived, double change) async {
    // TODO: Implement actual checkout process (save to database)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'CHECKOUT COMPLETED!\nTotal: ₱${_total.toStringAsFixed(2)}\nCash: ₱${cashReceived.toStringAsFixed(2)}\nChange: ₱${change.toStringAsFixed(2)}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    
    setState(() {
      _cart.clear();
      _calculateTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isMobile = screenWidth < 600;
    
    // Calculate grid columns based on screen size
    int crossAxisCount;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Scaffold(
      body: isDesktop
          ? Row(
              children: [
                // Product selection panel (desktop only)
                Expanded(
                  flex: 3,
                  child: _buildProductGrid(crossAxisCount),
                ),
                // Cart panel (desktop only)
                Expanded(
                  flex: 1,
                  child: _buildCartPanel(),
                ),
              ],
            )
          : _buildProductGrid(crossAxisCount),
      floatingActionButton: isMobile || isTablet
          ? _buildFloatingCartButton()
          : null,
    );
  }

  Widget _buildProductGrid(int crossAxisCount) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'SEARCH PRODUCTS...',
              hintStyle: GoogleFonts.pressStart2p(fontSize: 10),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            style: GoogleFonts.pressStart2p(fontSize: 10),
          ),
        ),
        // Products grid
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return _buildProductCard(product);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['name'] as String? ?? 'Unknown';
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    final photoUrl = product['photo_url'] as String?;
    final variations = product['variations'] as List? ?? [];
    
    // Calculate total stock
    int totalStock = 0;
    for (var v in variations) {
      totalStock += (v['quantity'] as num?)?.toInt() ?? 0;
    }
    
    final isInStock = totalStock > 0;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: isInStock ? Colors.black : Colors.red,
          width: 3,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isInStock ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
              isInStock ? const Color(0xFFE8E8E8) : const Color(0xFFFFE8E8),
            ],
          ),
        ),
        child: InkWell(
          onTap: isInStock ? () => _addToCart(product) : null,
          borderRadius: BorderRadius.zero,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with ITEM CARD text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C3E50),
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                      left: BorderSide(color: Colors.black, width: 2),
                      right: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Text(
                    '─── ITEM CARD ─────',
                    style: GoogleFonts.pressStart2p(
                      fontSize: isMobile ? 7 : 8,
                      color: const Color(0xFFECF0F1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Product image with icon overlay
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: photoUrl != null && photoUrl.isNotEmpty
                                ? Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: SizedBox(
                                          width: isMobile ? 16 : 20,
                                          height: isMobile ? 16 : 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.grey[100],
                                      child: Icon(
                                        Icons.image,
                                        size: isMobile ? 24 : 32,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[100],
                                  child: Icon(
                                    Icons.image,
                                    size: isMobile ? 24 : 32,
                                    color: Colors.grey[400],
                                  ),
                                ),
                        ),
                        // Pixel icon overlay
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text(
                              '🖼️',
                              style: TextStyle(fontSize: isMobile ? 10 : 12),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ),
                
                // Product name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    name.toUpperCase(),
                    style: GoogleFonts.pressStart2p(
                      fontSize: isMobile ? 7 : 8,
                      color: Colors.black,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Divider line
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                
                // Price and stock info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '💰',
                            style: TextStyle(fontSize: isMobile ? 10 : 12),
                          ),
                          Text(
                            '₱${price.toStringAsFixed(2)}',
                            style: GoogleFonts.pressStart2p(
                              fontSize: isMobile ? 9 : 10,
                              color: const Color(0xFF27AE60),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '📦',
                            style: TextStyle(fontSize: isMobile ? 10 : 12),
                          ),
                          Text(
                            isInStock ? 'x$totalStock' : 'OUT',
                            style: GoogleFonts.pressStart2p(
                              fontSize: isMobile ? 8 : 9,
                              color: isInStock ? const Color(0xFF2980B9) : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Add button
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isInStock ? const Color(0xFFE74C3C) : Colors.grey,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🛒',
                          style: TextStyle(fontSize: isMobile ? 10 : 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isInStock ? 'ADD' : 'SOLD OUT',
                          style: GoogleFonts.pressStart2p(
                            fontSize: isMobile ? 8 : 9,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildFloatingCartButton() {
    final isEmpty = _cart.isEmpty;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: isEmpty ? null : _showCartBottomSheet,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            if (_cart.isNotEmpty)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    '${_cart.length}',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        label: Text(
          '₱${_total.toStringAsFixed(0)}',
          style: GoogleFonts.pressStart2p(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SHOPPING CART',
                  style: GoogleFonts.pressStart2p(fontSize: 12),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            // Cart items
            Expanded(
              child: ListView.builder(
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  final product = item['product'] as Map<String, dynamic>;
                  final variation = item['variation'] as Map<String, dynamic>;
                  final quantity = item['quantity'] as int;
                  final lineTotal = item['lineTotal'] as double;
                  
                  final name = product['name'] as String? ?? 'Unknown';
                  final size = variation['size']?.toString() ?? 'N/A';
                  final color = variation['color']?.toString() ?? 'N/A';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.pressStart2p(fontSize: 10),
                          ),
                          Text(
                            '$size / $color',
                            style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _updateQuantity(index, quantity - 1),
                                    icon: const Icon(Icons.remove, size: 16),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: GoogleFonts.pressStart2p(fontSize: 10),
                                  ),
                                  IconButton(
                                    onPressed: () => _updateQuantity(index, quantity + 1),
                                    icon: const Icon(Icons.add, size: 16),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                ],
                              ),
                              // Price
                              Text(
                                '₱${lineTotal.toStringAsFixed(2)}',
                                style: GoogleFonts.pressStart2p(fontSize: 10),
                              ),
                            ],
                          ),
                          // Remove button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _removeFromCart(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'REMOVE',
                                style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Totals and checkout
            Column(
              children: [
                _buildTotalRow('Subtotal', _subtotal),
                const Divider(),
                _buildTotalRow('TOTAL', _total, isBold: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(
                      'CHECKOUT',
                      style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          // Cart header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Text(
              'SHOPPING CART',
              style: GoogleFonts.pressStart2p(fontSize: 12),
            ),
          ),
          // Cart items
          Expanded(
            child: _cart.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final item = _cart[index];
                      final product = item['product'] as Map<String, dynamic>;
                      final variation = item['variation'] as Map<String, dynamic>;
                      final quantity = item['quantity'] as int;
                      final lineTotal = item['lineTotal'] as double;
                      
                      final name = product['name'] as String? ?? 'Unknown';
                      final size = variation['size']?.toString() ?? 'N/A';
                      final color = variation['color']?.toString() ?? 'N/A';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.pressStart2p(fontSize: 10),
                              ),
                              Text(
                                '$size / $color',
                                style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Quantity controls
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _updateQuantity(index, quantity - 1),
                                        icon: const Icon(Icons.remove, size: 16),
                                        padding: const EdgeInsets.all(4),
                                      ),
                                      Text(
                                        '$quantity',
                                        style: GoogleFonts.pressStart2p(fontSize: 10),
                                      ),
                                      IconButton(
                                        onPressed: () => _updateQuantity(index, quantity + 1),
                                        icon: const Icon(Icons.add, size: 16),
                                        padding: const EdgeInsets.all(4),
                                      ),
                                    ],
                                  ),
                                  // Price
                                  Text(
                                    '₱${lineTotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.pressStart2p(fontSize: 10),
                                  ),
                                ],
                              ),
                              // Remove button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _removeFromCart(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    'REMOVE',
                                    style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Totals and checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                _buildTotalRow('Subtotal', _subtotal),
                const Divider(),
                _buildTotalRow('TOTAL', _total, isBold: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(
                      'CHECKOUT',
                      style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₱${amount.toStringAsFixed(2)}',
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigScreen extends StatefulWidget {
  const _ConfigScreen({super.key});

  @override
  State<_ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<_ConfigScreen> {
  List<String> _colors = [];
  List<String> _sizes = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadConfiguration() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Replace with actual API calls
      // For now, use default values
      setState(() {
        _colors = ['Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Gray', 'Pink'];
        _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '30', '32', '34', '36'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addColor() async {
    final color = _colorController.text.trim();
    if (color.isEmpty) return;

    setState(() {
      _colors.add(color);
      _colorController.clear();
    });

    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Color "$color" added!')),
    );
  }

  Future<void> _removeColor(String color) async {
    setState(() {
      _colors.remove(color);
    });

    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Color "$color" removed!')),
    );
  }

  Future<void> _addSize() async {
    final size = _sizeController.text.trim();
    if (size.isEmpty) return;

    setState(() {
      _sizes.add(size);
      _sizeController.clear();
    });

    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Size "$size" added!')),
    );
  }

  Future<void> _removeSize(String size) async {
    setState(() {
      _sizes.remove(size);
    });

    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Size "$size" removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ERROR LOADING CONFIG',
                style: GoogleFonts.pressStart2p(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: GoogleFonts.pressStart2p(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadConfiguration,
                child: Text('RETRY', style: GoogleFonts.pressStart2p(fontSize: 10)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colors Section
            _Section(
              title: 'COLOR OPTIONS',
              child: Column(
                children: [
                  // Add new color
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _colorController,
                          decoration: const InputDecoration(
                            labelText: 'Add Color',
                            hintText: 'e.g., Black, White, Red',
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addColor(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addColor,
                        child: Text('ADD', style: GoogleFonts.pressStart2p(fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Colors list
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colors.map((color) => _ColorChip(
                      color: color,
                      onDelete: () => _removeColor(color),
                    )).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sizes Section
            _Section(
              title: 'SIZE OPTIONS',
              child: Column(
                children: [
                  // Add new size
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _sizeController,
                          decoration: const InputDecoration(
                            labelText: 'Add Size',
                            hintText: 'e.g., S, M, L, 30, 32',
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addSize(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addSize,
                        child: Text('ADD', style: GoogleFonts.pressStart2p(fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sizes list
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sizes.map((size) => _SizeChip(
                      size: size,
                      onDelete: () => _removeSize(size),
                    )).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 HOW TO USE',
                    style: GoogleFonts.pressStart2p(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Add colors and sizes that you commonly use\n'
                    '• These options will appear as dropdowns in the Add Item form\n'
                    '• This makes adding variations much faster and more consistent\n'
                    '• Remove options that you no longer need',
                    style: GoogleFonts.pressStart2p(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String color;
  final VoidCallback onDelete;

  const _ColorChip({
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            color.toUpperCase(),
            style: GoogleFonts.pressStart2p(fontSize: 10),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String size;
  final VoidCallback onDelete;

  const _SizeChip({
    required this.size,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            size.toUpperCase(),
            style: GoogleFonts.pressStart2p(fontSize: 10),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
