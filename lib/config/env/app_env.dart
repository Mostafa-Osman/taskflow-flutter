enum EnvName { dev, staging, prod }

class AppEnv {
  const AppEnv({
    required this.name,
    required this.apiBaseUrl,
    required this.mockDelay,
    required this.enableHttpLogging,
    required this.useMockBackend,
  });

  final EnvName name;
  final String apiBaseUrl;
  final Duration mockDelay;
  final bool enableHttpLogging;
  final bool useMockBackend;

  String get label => switch (name) {
    EnvName.dev => 'Development',
    EnvName.staging => 'Staging',
    EnvName.prod => 'Production',
  };

  static AppEnv fromDartDefine() {
    const raw = String.fromEnvironment('ENV', defaultValue: 'dev');
    return fromName(raw);
  }

  static AppEnv fromName(String raw) {
    switch (raw.toLowerCase()) {
      case 'staging':
        return stagingEnv;
      case 'prod':
      case 'production':
        return prodEnv;
      case 'dev':
      case 'development':
      default:
        return devEnv;
    }
  }
}

const devEnv = AppEnv(
  name: EnvName.dev,
  apiBaseUrl: 'https://api.dev.taskflow.local',
  mockDelay: Duration(milliseconds: 350),
  enableHttpLogging: true,
  useMockBackend: true,
);

const stagingEnv = AppEnv(
  name: EnvName.staging,
  apiBaseUrl: 'https://api.staging.taskflow.local',
  mockDelay: Duration(milliseconds: 250),
  enableHttpLogging: true,
  useMockBackend: true,
);

const prodEnv = AppEnv(
  name: EnvName.prod,
  apiBaseUrl: 'https://api.taskflow.local',
  mockDelay: Duration(milliseconds: 200),
  enableHttpLogging: false,
  useMockBackend: true,
);
