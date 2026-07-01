/// Feature toggles for staged rollout (billing, audio, sync, etc.).
abstract final class FeatureFlags {
  /// Native speaker audio + TTS. Disabled until recordings are ready.
  static const bool audioEnabled = false;
}
