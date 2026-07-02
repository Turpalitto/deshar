/// Реестр путей к брендовым иконкам (flat vector, палитра DesignTokens).
abstract final class AppIcons {
  static const _base = 'assets/icons';

  // Tier 1 — navigation & key actions
  static const navHome = '$_base/nav_home.svg';
  static const navDictionary = '$_base/nav_dictionary.svg';
  static const actionReview = '$_base/action_review.svg';
  static const navProfile = '$_base/nav_profile.svg';
  static const navWorlds = '$_base/nav_worlds.svg';

  // Tier 2 — progress & gamification
  static const progressStreak = '$_base/progress_streak.svg';
  static const progressCoin = '$_base/progress_coin.svg';
  static const progressStar = '$_base/progress_star.svg';
  static const rewardTrophy = '$_base/reward_trophy.svg';
  static const rewardGift = '$_base/reward_gift.svg';
  static const rewardChest = '$_base/reward_chest.svg';
  static const rewardCelebration = '$_base/reward_celebration.svg';
  static const rewardCrown = '$_base/reward_crown.svg';
  static const stateLocked = '$_base/state_locked.svg';

  // Tier 3 — culture & brand
  static const cultureHeritage = '$_base/culture_heritage.svg';
  static const cultureMountains = '$_base/culture_mountains.svg';
  static const cultureHandshake = '$_base/culture_handshake.svg';
  static const cultureFeast = '$_base/culture_feast.svg';

  // Tier 4 — games & states
  static const gamePuzzle = '$_base/game_puzzle.svg';
  static const stateEmpty = '$_base/state_empty.svg';
  static const stateOffline = '$_base/state_offline.svg';
  static const gamePlay = '$_base/game_play.svg';
  static const gameBoss = '$_base/game_boss.svg';
  static const actionTyping = '$_base/action_typing.svg';
  static const actionCollections = '$_base/action_collections.svg';

  // Kids — age groups & mascot
  static const ageHatchling = '$_base/age_hatchling.svg';
  static const ageSprout = '$_base/age_sprout.svg';
  static const ageLeaf = '$_base/age_leaf.svg';
  static const mascotFox = '$_base/mascot_fox.svg';

  // Misc UI states
  static const stateSuccess = '$_base/state_success.svg';
  static const stateError = '$_base/state_error.svg';
  static const iconInfinity = '$_base/icon_infinity.svg';

  /// Иконки таб-бара (индекс → asset).
  static const tabBar = [navHome, navWorlds, actionReview, navProfile];

  static const ageGroups = [ageHatchling, ageSprout, ageLeaf];
}
