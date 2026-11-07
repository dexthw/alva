/// Metadados do produto usados pela interface.
///
/// A versão é mantida em sincronia com o `pubspec.yaml` (é a única forma de
/// lê-la sem adicionar `package_info_plus`).
class AppInfo {
  const AppInfo._();

  static const String version = '1.1.0';

  /// Repositório oficial do projeto.
  static const String repositoryUrl = 'https://github.com/dexthw/alva';

  static Uri get feedbackUrl =>
      Uri.parse('$repositoryUrl/issues/new?template=feedback.yml');

  static Uri get issuesUrl => Uri.parse('$repositoryUrl/issues');
}
