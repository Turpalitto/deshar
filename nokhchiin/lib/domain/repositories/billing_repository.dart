import '../entities/subscription_entity.dart';

abstract class BillingRepository {
  Future<SubscriptionEntity> getSubscription();
  Future<SubscriptionEntity> startTrial();
  Future<SubscriptionEntity> purchasePremium();
  Future<SubscriptionEntity> restorePurchases();
  Stream<SubscriptionEntity> watchSubscription();
}
