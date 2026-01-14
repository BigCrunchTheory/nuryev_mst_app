import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/app_view_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Consumer<AppViewModel>(
      builder: (context, appVM, _) {
        final subscription = appVM.subscription;

        if (subscription == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
                    onTap: () async {
                      await appVM.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/onboarding',
                          (route) => false,
                        );
                      }
                    },
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
                              'You have a ${subscription.plan} subscription',
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
                                subscription.plan.toUpperCase(),
                                isMobile: isMobile,
                              ),
                              const Divider(),
                              _buildInfoRow(
                                'Expires On',
                                '${subscription.endDate.day}/${subscription.endDate.month}/${subscription.endDate.year}',
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
      },
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
