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
    expect(currentRelease.total, greaterThan(0));
    expect(currentRelease.news, isNotEmpty);
  });

  test('o histórico está da versão mais recente para a mais antiga', () {
    expect(
      releaseHistory.map((ReleaseNote note) => note.version).toList(),
      <String>['1.2.1', '1.2.0', '1.1.0', '1.0.2', '1.0.0'],
    );
    expect(releaseHistory.first.version, AppInfo.version);
    expect(
      releaseHistory.every((ReleaseNote note) => note.total > 0),
      isTrue,
    );
  });
}
