import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/paywall_view_model.dart';
import '../../view_models/app_view_model.dart';
import 'subscription_card.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ChangeNotifierProvider(
      create: (_) => PaywallViewModel(),
      child: Consumer2<PaywallViewModel, AppViewModel>(
        builder: (context, paywallVM, appVM, _) {
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
                                      child: SubscriptionCard(
                                        title: 'Monthly',
                                        price: '\$4.99',
                                        billingPeriod: '/month',
                                        features: [
                                          'Unlimited access',
                                          'Ad-free experience',
                                          'Priority support',
                                        ],
                                        isSelected: paywallVM.selectedPlan == 'month',
                                        onTap: () {
                                          paywallVM.selectPlan('month');
                                        },
                                        discount: null,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: SubscriptionCard(
                                        title: 'Yearly',
                                        price: '\$39.99',
                                        billingPeriod: '/year',
                                        features: [
                                          'Everything in Monthly',
                                          'Save 33% compared to monthly',
                                          'Best value',
                                        ],
                                        isSelected: paywallVM.selectedPlan == 'year',
                                        onTap: () {
                                          paywallVM.selectPlan('year');
                                        },
                                        discount: '33% OFF',
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    SubscriptionCard(
                                      title: 'Monthly',
                                      price: '\$4.99',
                                      billingPeriod: '/month',
                                      features: [
                                        'Unlimited access',
                                        'Ad-free experience',
                                        'Priority support',
                                      ],
                                      isSelected: paywallVM.selectedPlan == 'month',
                                      onTap: () {
                                        paywallVM.selectPlan('month');
                                      },
                                      discount: null,
                                    ),
                                    const SizedBox(height: 16),
                                    SubscriptionCard(
                                      title: 'Yearly',
                                      price: '\$39.99',
                                      billingPeriod: '/year',
                                      features: [
                                        'Everything in Monthly',
                                        'Save 33% compared to monthly',
                                        'Best value',
                                      ],
                                      isSelected: paywallVM.selectedPlan == 'year',
                                      onTap: () {
                                        paywallVM.selectPlan('year');
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
                        onPressed: paywallVM.isLoading
                            ? null
                            : () {
                                paywallVM.purchase(() async {
                                  // Set subscription in AppViewModel
                                  await appVM.setSubscription(paywallVM.selectedPlan);
                                  
                                  // Wait for state to update
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  
                                  // Close PaywallScreen - AppRouter will auto-rebuild
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 16 : 20,
                          ),
                        ),
                        child: paywallVM.isLoading
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
        },
      ),
    );
  }
}
