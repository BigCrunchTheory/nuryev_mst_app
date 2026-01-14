import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuryev App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppRouter(),
    );
  }
}

// App Router - determines which screen to show based on subscription state
class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late Future<bool> _hasSubscription;

  @override
  void initState() {
    super.initState();
    _hasSubscription = _checkSubscription();
  }

  Future<bool> _checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_subscription') ?? false;
  }

  void _refreshRouter() {
    setState(() {
      _hasSubscription = _checkSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSubscription,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return MainScreen(onLogout: _refreshRouter);
        }

        return OnboardingScreen(onComplete: _refreshRouter);
      },
    );
  }
}

// ===== ONBOARDING SCREENS =====
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaywallScreen(
          onSubscriptionComplete: widget.onComplete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          OnboardingPage1(pageController: _pageController, isMobile: isMobile),
          OnboardingPage2(
            pageController: _pageController,
            onContinue: _goToPaywall,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage1 extends StatelessWidget {
  final PageController pageController;
  final bool isMobile;

  const OnboardingPage1({
    super.key,
    required this.pageController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade300,
            Colors.deepPurple.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: isMobile ? 20 : 40),
            Column(
              children: [
                Icon(
                  Icons.rocket_launch,
                  size: isMobile ? 100 : 150,
                  color: Colors.white,
                ),
                SizedBox(height: isMobile ? 30 : 50),
                Text(
                  'Welcome to Nuryev',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 20 : 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 80,
                  ),
                  child: Text(
                    'Discover amazing features and unlock your potential with our premium experience.',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 40 : 60),
              child: ElevatedButton(
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 40 : 60,
                    vertical: isMobile ? 16 : 20,
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onContinue;
  final bool isMobile;

  const OnboardingPage2({
    super.key,
    required this.pageController,
    required this.onContinue,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: isMobile ? 28 : 36,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.star,
                  size: isMobile ? 100 : 150,
                  color: Colors.yellow.shade300,
                ),
                SizedBox(height: isMobile ? 30 : 50),
                Text(
                  'Unlock Premium Features',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 20 : 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 80,
                  ),
                  child: Text(
                    'Choose a subscription plan that fits your needs and enjoy unlimited access.',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 40 : 60),
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 40 : 60,
                    vertical: isMobile ? 16 : 20,
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== PAYWALL SCREEN =====
class PaywallScreen extends StatefulWidget {
  final VoidCallback onSubscriptionComplete;

  const PaywallScreen({super.key, required this.onSubscriptionComplete});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedPlan = 'month';
  bool _isLoading = false;

  Future<void> _purchaseSubscription() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate purchase process
    await Future.delayed(const Duration(seconds: 2));

    // Save subscription state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_subscription', true);
    await prefs.setString('subscription_plan', _selectedPlan);
    await prefs.setInt(
      'subscription_date',
      DateTime.now().millisecondsSinceEpoch,
    );

    if (mounted) {
      // Pop paywall screen and then trigger refresh
      Navigator.of(context).pop();
      widget.onSubscriptionComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: isMobile ? 20 : 40),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 800,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 32),
                    child: Column(
                      children: [
                        Text(
                          'Select a Subscription Plan',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMobile ? 32 : 48),
                        if (!isMobile)
                          Row(
                            children: [
                              Expanded(
                                child: _SubscriptionCard(
                                  title: 'Monthly',
                                  price: '\$4.99',
                                  billingPeriod: '/month',
                                  features: [
                                    'Unlimited access',
                                    'Ad-free experience',
                                    'Priority support',
                                  ],
                                  isSelected: _selectedPlan == 'month',
                                  onTap: () {
                                    setState(() {
                                      _selectedPlan = 'month';
                                    });
                                  },
                                  discount: null,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _SubscriptionCard(
                                  title: 'Yearly',
                                  price: '\$39.99',
                                  billingPeriod: '/year',
                                  features: [
                                    'Everything in Monthly',
                                    'Save 33% compared to monthly',
                                    'Best value',
                                  ],
                                  isSelected: _selectedPlan == 'year',
                                  onTap: () {
                                    setState(() {
                                      _selectedPlan = 'year';
                                    });
                                  },
                                  discount: '33% OFF',
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _SubscriptionCard(
                                title: 'Monthly',
                                price: '\$4.99',
                                billingPeriod: '/month',
                                features: [
                                  'Unlimited access',
                                  'Ad-free experience',
                                  'Priority support',
                                ],
                                isSelected: _selectedPlan == 'month',
                                onTap: () {
                                  setState(() {
                                    _selectedPlan = 'month';
                                  });
                                },
                                discount: null,
                              ),
                              const SizedBox(height: 16),
                              _SubscriptionCard(
                                title: 'Yearly',
                                price: '\$39.99',
                                billingPeriod: '/year',
                                features: [
                                  'Everything in Monthly',
                                  'Save 33% compared to monthly',
                                  'Best value',
                                ],
                                isSelected: _selectedPlan == 'year',
                                onTap: () {
                                  setState(() {
                                    _selectedPlan = 'year';
                                  });
                                },
                                discount: '33% OFF',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Center(
              child: SizedBox(
                width: isMobile ? double.infinity : 400,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _purchaseSubscription,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 16 : 20,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 32),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String billingPeriod;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;
  final String? discount;

  const _SubscriptionCard({
    required this.title,
    required this.price,
    required this.billingPeriod,
    required this.features,
    required this.isSelected,
    required this.onTap,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? Colors.deepPurple.shade50
                  : Colors.grey.shade50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: price,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        TextSpan(
                          text: billingPeriod,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
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
          if (discount != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  discount!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ===== MAIN SCREEN =====
class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _subscriptionPlan;
  late DateTime _subscriptionDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionInfo();
  }

  Future<void> _loadSubscriptionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final plan = prefs.getString('subscription_plan') ?? 'month';
    final timestamp = prefs.getInt('subscription_date') ?? 0;
    final startDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
    // Calculate end date based on plan
    late DateTime endDate;
    if (plan == 'month') {
      endDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
    } else {
      endDate = DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
    
    setState(() {
      _subscriptionPlan = plan;
      _subscriptionDate = startDate;
      _endDate = endDate;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_subscription', false);
    if (mounted) {
      widget.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 900,
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(isMobile ? 20 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                          'You have a $_subscriptionPlan subscription',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 40),
                  // Subscription Info
                  Text(
                    'Subscription Details',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 20),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Plan',
                            _subscriptionPlan.toUpperCase(),
                            isMobile: isMobile,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Expires On',
                            '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                            isMobile: isMobile,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Status',
                            'Active',
                            valueColor: Colors.green,
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 40),
                  // Features List
                  Text(
                    'Your Benefits',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 20),
                  if (!isMobile)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 5,
                      children: [
                        _buildFeatureItem('Unlimited access to all content',
                            isMobile: false),
                        _buildFeatureItem('Ad-free experience',
                            isMobile: false),
                        _buildFeatureItem('Priority customer support',
                            isMobile: false),
                        _buildFeatureItem('Early access to new features',
                            isMobile: false),
                        _buildFeatureItem('Offline mode support',
                            isMobile: false),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildFeatureItem('Unlimited access to all content',
                            isMobile: true),
                        _buildFeatureItem('Ad-free experience', isMobile: true),
                        _buildFeatureItem('Priority customer support',
                            isMobile: true),
                        _buildFeatureItem('Early access to new features',
                            isMobile: true),
                        _buildFeatureItem('Offline mode support',
                            isMobile: true),
                      ],
                    ),
                  SizedBox(height: isMobile ? 24 : 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? valueColor, required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature, {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: isMobile ? 24 : 28,
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
