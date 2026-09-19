import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/revenue_cat_config.dart';

enum PurchaseOutcome { success, cancelled, error }

class PurchaseResult {
  final PurchaseOutcome outcome;
  final String? transactionId;
  final String? errorMessage;

  PurchaseResult.success(this.transactionId)
      : outcome = PurchaseOutcome.success,
        errorMessage = null;

  PurchaseResult.cancelled()
      : outcome = PurchaseOutcome.cancelled,
        transactionId = null,
        errorMessage = null;

  PurchaseResult.error(this.errorMessage)
      : outcome = PurchaseOutcome.error,
        transactionId = null;
}

class PurchaseService {
  // Uygulama açılışında bir kez çağrılır (main.dart)
  Future<void> init() async {
    final apiKey = Platform.isIOS
        ? RevenueCatConfig.iosApiKey
        : RevenueCatConfig.androidApiKey;

    await Purchases.configure(PurchasesConfiguration(apiKey));
  }

  // RevenueCat kullanıcısını Firebase uid'sine bağlar — cihaz değişse de
  // satın alma geçmişi aynı hesapla ilişkilendirilir
  Future<void> identify(String firebaseUid) async {
    try {
      await Purchases.logIn(firebaseUid);
    } catch (_) {
      // RevenueCat henüz yapılandırılmadıysa (placeholder API key) sessizce geç
    }
  }

  // Satın almadan HEMEN önce çağrılır — main.dart'taki identify() fire-and-
  // forget olduğu için satın alma anına kadar bitmemiş olabilir. Bu, RevenueCat
  // kullanıcısının doğru Firebase hesabına bağlı olduğunu KESİNLEŞTİRMEDEN
  // satın almaya izin vermez: aksi halde işlem RevenueCat'in anonim
  // kullanıcısına kaydolur, webhook bunu hiçbir hesapla eşleştiremez ve
  // kullanıcı öder ama kredi hiç eklenmez.
  Future<bool> ensureIdentified(String firebaseUid) async {
    try {
      await Purchases.logIn(firebaseUid);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Offerings> getOfferings() => Purchases.getOfferings();

  Future<PurchaseResult> purchase(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      final transactions = customerInfo.nonSubscriptionTransactions;
      final transactionId =
          transactions.isNotEmpty ? transactions.last.transactionIdentifier : null;
      return PurchaseResult.success(transactionId);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled();
      }
      return PurchaseResult.error(e.message ?? 'Satın alma başarısız.');
    } catch (e) {
      return PurchaseResult.error('Satın alma başarısız: $e');
    }
  }

  // Bu pakete karşılık gelen kredi miktarı (RevenueCatConfig'te tanımlı)
  int creditsFor(Package package) =>
      RevenueCatConfig.packageCredits[package.identifier] ?? 0;
}
