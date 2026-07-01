import 'dart:async';
import '../../domain/constants/subscription_limits.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/billing_repository.dart';
import '../../domain/repositories/repositories.dart';

/// Локальная реализация биллинга (заглушка до RevenueCat / in_app_purchase).
class BillingService implements BillingRepository {
  BillingService({
    required UserRepository userRepo,
    required Future<void> Function(bool) onPremiumChanged,
  })  : _userRepo = userRepo,
        _onPremiumChanged = onPremiumChanged;

  final UserRepository _userRepo;
  final Future<void> Function(bool) _onPremiumChanged;
  final _controller = StreamController<SubscriptionEntity>.broadcast();
  SubscriptionEntity _current = const SubscriptionEntity();

  @override
  Future<SubscriptionEntity> getSubscription() async {
    final profile = await _userRepo.getProfile();
    if (profile.isPremium) {
      return const SubscriptionEntity(tier: SubscriptionTier.premium);
    }
    return _current;
  }

  @override
  Stream<SubscriptionEntity> watchSubscription() => _controller.stream;

  void _emit(SubscriptionEntity sub) {
    _current = sub;
    _controller.add(sub);
  }

  @override
  Future<SubscriptionEntity> startTrial() async {
    final ends = DateTime.now().add(
      const Duration(days: SubscriptionLimits.trialDays),
    );
    final sub = SubscriptionEntity(
      tier: SubscriptionTier.trial,
      trialEndsAt: ends,
      productId: SubscriptionLimits.premiumProductId,
    );
    _emit(sub);
    await _onPremiumChanged(true);
    return sub;
  }

  @override
  Future<SubscriptionEntity> purchasePremium() async {
    final sub = SubscriptionEntity(
      tier: SubscriptionTier.premium,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      productId: SubscriptionLimits.premiumProductId,
    );
    _emit(sub);
    await _onPremiumChanged(true);
    return sub;
  }

  @override
  Future<SubscriptionEntity> restorePurchases() async {
    final profile = await _userRepo.getProfile();
    if (profile.isPremium) {
      const sub = SubscriptionEntity(tier: SubscriptionTier.premium);
      _emit(sub);
      return sub;
    }
    return _current;
  }
}
