import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/purchase_service.dart';
import '../services/theme_controller.dart';
import '../widgets/app_alert.dart';
import '../widgets/refreshable.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> implements Refreshable {
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

  // MainScreen bu sekmeye her geçildiğinde çağırır (IndexedStack initState'i
  // tekrar çalıştırmadığı için kredi bilgisi başka türlü bayat kalırdı)
  @override
  Future<void> refresh() async {
    await Future.wait([_loadCredits(), _loadPackages()]);
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
    AppAlert.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileAppBarTitle),
        backgroundColor: AppColors.derinGri(context),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_auth.currentUser?.email != null) ...[
            _accountEmailCard(_auth.currentUser!.email!),
            const SizedBox(height: 16),
          ],
          _creditBalanceCard(),
          const SizedBox(height: 32),
          _sectionTitle(l10n.profileThemeTitle, ''),
          const SizedBox(height: 12),
          _themeSelector(),
          const SizedBox(height: 32),
          _sectionTitle(l10n.profileBuyCreditsTitle, l10n.profileBuyCreditsSubtitle),
          const SizedBox(height: 12),
          _packagesList(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: Icon(Icons.logout, color: AppColors.hataKirmizi(context)),
              label: Text(
                l10n.profileSignOut,
                style: TextStyle(color: AppColors.hataKirmizi(context)),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.hataKirmizi(context)),
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

  Widget _accountEmailCard(String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.derinGri(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.email_outlined, color: AppColors.acikGri(context), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              email,
              style: TextStyle(color: AppColors.safBeyaz(context)),
              overflow: TextOverflow.ellipsis,
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
        color: AppColors.derinGri(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Icon(Icons.bolt, color: AppColors.vitrifyMavisi(context), size: 32),
          const SizedBox(height: 8),
          _isLoadingCredits
              ? CircularProgressIndicator(color: AppColors.vitrifyMavisi(context))
              : Text(
                  '$_credits',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.safBeyaz(context),
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.profileCreditsRemaining,
            style: TextStyle(color: AppColors.acikGri(context), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _packagesList() {
    if (_isLoadingPackages) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.vitrifyMavisi(context)),
        ),
      );
    }

    if (_packagesError != null) {
      return Text(_packagesError!,
          style: TextStyle(color: AppColors.acikGri(context)));
    }

    if (_packages.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.profileNoPackages,
        style: TextStyle(color: AppColors.acikGri(context)),
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
              color: AppColors.derinGri(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.storeProduct.title,
                        style: TextStyle(
                          color: AppColors.safBeyaz(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (credits > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.profileCreditsSuffix(credits),
                          style: TextStyle(
                              color: AppColors.acikGri(context), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isPurchasing ? null : () => _buyPackage(package),
                  child: isPurchasing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.safBeyaz(context),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.safBeyaz(context),
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.acikGri(context)),
          ),
        ],
      ],
    );
  }

  Widget _themeSelector() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (context, mode, _) {
        final l10n = AppLocalizations.of(context)!;
        return SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
              value: ThemeMode.light,
              icon: const Icon(Icons.light_mode_outlined),
              label: Text(l10n.profileThemeLight),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              icon: const Icon(Icons.brightness_auto_outlined),
              label: Text(l10n.profileThemeSystem),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: const Icon(Icons.dark_mode_outlined),
              label: Text(l10n.profileThemeDark),
            ),
          ],
          selected: {mode},
          showSelectedIcon: false,
          onSelectionChanged: (selection) =>
              ThemeController.instance.setMode(selection.first),
        );
      },
    );
  }
}
