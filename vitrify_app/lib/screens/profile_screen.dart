import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/purchase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = ApiService();
  final _auth = AuthService();
  final _purchases = PurchaseService();

  int _credits = 0;
  bool _isLoadingCredits = true;

  List<Package> _packages = [];
  bool _isLoadingPackages = true;
  String? _packagesError;

  // Şu an satın alma işlemi devam eden paketin identifier'ı (buton spinner'ı için)
  String? _purchasingPackageId;

  @override
  void initState() {
    super.initState();
    _loadCredits();
    _loadPackages();
  }

  Future<void> _loadCredits() async {
    try {
      final credits = await _api.getCredits();
      if (!mounted) return;
      setState(() {
        _credits = credits;
        _isLoadingCredits = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCredits = false);
    }
  }

  Future<void> _loadPackages() async {
    setState(() {
      _isLoadingPackages = true;
      _packagesError = null;
    });

    try {
      final offerings = await _purchases.getOfferings();
      final packages = offerings.current?.availablePackages ?? [];

      if (!mounted) return;
      setState(() {
        _packages = packages;
        _isLoadingPackages = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _packagesError = AppLocalizations.of(context)!.profilePackagesLoadError;
        _isLoadingPackages = false;
      });
    }
  }

  Future<void> _buyPackage(Package package) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _purchasingPackageId = package.identifier);

    final result = await _purchases.purchase(package);

    if (!mounted) return;

    switch (result.outcome) {
      case PurchaseOutcome.success:
        final credits = _purchases.creditsFor(package);
        try {
          await _api.addCredits(
            credits: credits,
            storeTransactionId: result.transactionId ?? package.identifier,
            platform: Theme.of(context).platform == TargetPlatform.iOS
                ? 'ios'
                : 'android',
          );
          await _loadCredits();
          _showMessage(l10n.profileCreditsAdded(credits));
        } catch (e) {
          _showMessage(l10n.profilePurchaseCompletedButCreditsFailed('$e'));
        }
        break;
      case PurchaseOutcome.cancelled:
        break;
      case PurchaseOutcome.error:
        _showMessage(result.errorMessage ?? l10n.profilePurchaseFailed);
        break;
    }

    if (!mounted) return;
    setState(() => _purchasingPackageId = null);
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    // AuthGate, oturum kapandığını otomatik algılayıp LoginScreen'e yönlendirir
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.derinGri,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileAppBarTitle),
        backgroundColor: AppColors.geceSiyahi,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _creditBalanceCard(),
          const SizedBox(height: 32),
          _sectionTitle(l10n.profileBuyCreditsTitle, l10n.profileBuyCreditsSubtitle),
          const SizedBox(height: 12),
          _packagesList(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, color: AppColors.hataKirmizi),
              label: Text(
                l10n.profileSignOut,
                style: const TextStyle(color: AppColors.hataKirmizi),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.hataKirmizi),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.derinGri,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.bolt, color: AppColors.vitrifyMavisi, size: 32),
          const SizedBox(height: 8),
          _isLoadingCredits
              ? const CircularProgressIndicator(color: AppColors.vitrifyMavisi)
              : Text(
                  '$_credits',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.safBeyaz,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.profileCreditsRemaining,
            style: const TextStyle(color: AppColors.acikGri, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _packagesList() {
    if (_isLoadingPackages) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.vitrifyMavisi),
        ),
      );
    }

    if (_packagesError != null) {
      return Text(_packagesError!,
          style: const TextStyle(color: AppColors.acikGri));
    }

    if (_packages.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.profileNoPackages,
        style: const TextStyle(color: AppColors.acikGri),
      );
    }

    return Column(
      children: _packages.map((package) {
        final credits = _purchases.creditsFor(package);
        final isPurchasing = _purchasingPackageId == package.identifier;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.derinGri,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.storeProduct.title,
                        style: const TextStyle(
                          color: AppColors.safBeyaz,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (credits > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.profileCreditsSuffix(credits),
                          style: const TextStyle(
                              color: AppColors.acikGri, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isPurchasing ? null : () => _buyPackage(package),
                  child: isPurchasing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.safBeyaz,
                          ),
                        )
                      : Text(package.storeProduct.priceString),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.safBeyaz,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.acikGri),
        ),
      ],
    );
  }
}
