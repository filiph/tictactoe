abstract class SettingsPersistence {
  Future<void> saveMute(bool value);

  Future<void> saveMusicOn(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<bool> getMuted({required bool defaultValue});

  Future<bool> getMusicOn();

  Future<bool> getSoundsOn();
}
