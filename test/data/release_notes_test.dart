import 'package:alva/core/app_info.dart';
import 'package:alva/data/release_notes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('primeira instalação não abre as novidades', () {
    expect(
      shouldShowWhatsNew(
        seenVersion: null,
        habitCount: 0,
        currentVersion: AppInfo.version,
      ),
      isFalse,
    );
  });

  test('atualização de uma instalação com dados abre', () {
    expect(
      shouldShowWhatsNew(
        seenVersion: null,
        habitCount: 3,
        currentVersion: AppInfo.version,
      ),
      isTrue,
    );
  });

  test('versão já vista não abre de novo', () {
    expect(
      shouldShowWhatsNew(
        seenVersion: '1.0.2',
        habitCount: 3,
        currentVersion: AppInfo.version,
      ),
      isTrue,
    );
    expect(
      shouldShowWhatsNew(
        seenVersion: AppInfo.version,
        habitCount: 3,
        currentVersion: AppInfo.version,
      ),
      isFalse,
    );
  });

  test('a nota atual corresponde à versão do app', () {
    expect(currentRelease.version, AppInfo.version);
    expect(currentRelease.date, isNotEmpty);
    expect(currentRelease.news, isNotEmpty);
    expect(currentRelease.improvements, isNotEmpty);
    expect(currentRelease.fixes, isNotEmpty);
  });
}
