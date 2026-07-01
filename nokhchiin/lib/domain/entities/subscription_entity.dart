import 'package:equatable/equatable.dart';

enum SubscriptionTier { free, trial, premium }

/// Статус подписки пользователя.
class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    this.tier = SubscriptionTier.free,
    this.trialEndsAt,
    this.expiresAt,
    this.productId,
  });

  final SubscriptionTier tier;
  final DateTime? trialEndsAt;
  final DateTime? expiresAt;
  final String? productId;

  bool get isPremium =>
      tier == SubscriptionTier.premium ||
      (tier == SubscriptionTier.trial &&
          trialEndsAt != null &&
          trialEndsAt!.isAfter(DateTime.now()));

  bool get isTrialActive =>
      tier == SubscriptionTier.trial &&
      trialEndsAt != null &&
      trialEndsAt!.isAfter(DateTime.now());

  SubscriptionEntity copyWith({
    SubscriptionTier? tier,
    DateTime? trialEndsAt,
    DateTime? expiresAt,
    String? productId,
  }) =>
      SubscriptionEntity(
        tier: tier ?? this.tier,
        trialEndsAt: trialEndsAt ?? this.trialEndsAt,
        expiresAt: expiresAt ?? this.expiresAt,
        productId: productId ?? this.productId,
      );

  @override
  List<Object?> get props => [tier, trialEndsAt, expiresAt, productId];
}
