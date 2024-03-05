import 'package:application/implementations/autherization_service.dart';
import 'package:application/implementations/configuration.dart';
import 'package:application/implementations/device_service.dart';
import 'package:application/implementations/exception_manager.dart';
import 'package:application/implementations/http_provider.dart';
import 'package:application/implementations/http_server.dart';
import 'package:application/implementations/local_network_service.dart';
import 'package:application/implementations/local_storage.dart';
import 'package:application/implementations/logging_service.dart';
import 'package:application/implementations/observer.dart';
import 'package:application/implementations/otp_service.dart';
import 'package:application/implementations/page_router_service.dart';
import 'package:application/implementations/secret_manager.dart';
import 'package:application/implementations/session_service.dart';
import 'package:application/implementations/signature_service.dart';
import 'package:application/implementations/identity_manager.dart';
import 'package:application/implementations/signature_store.dart';
import 'package:application/implementations/authentication_service.dart';
import 'package:application/implementations/challanage_service.dart';
import 'package:application/implementations/token_service.dart';
import 'package:application/implementations/sync_service.dart';
import 'package:get_it/get_it.dart';
import 'package:infrastructure/interfaces/iauthorization_service.dart';
import 'package:infrastructure/interfaces/iconfiguration.dart';
import 'package:infrastructure/interfaces/idevices_service.dart';
import 'package:infrastructure/interfaces/iexception_manager.dart';
import 'package:infrastructure/interfaces/ihttp_provider_service.dart';
import 'package:infrastructure/interfaces/ihttp_server.dart';
import 'package:infrastructure/interfaces/iidentity_manager.dart';
import 'package:infrastructure/interfaces/ilocal_network_service.dart';
import 'package:infrastructure/interfaces/ilocal_storage.dart';
import 'package:infrastructure/interfaces/ilogging_service.dart';
import 'package:infrastructure/interfaces/iobserver.dart';
import 'package:infrastructure/interfaces/iotp_service.dart';
import 'package:infrastructure/interfaces/ipage_router_service.dart';
import 'package:infrastructure/interfaces/isecret_manager.dart';
import 'package:infrastructure/interfaces/isession_service.dart';
import 'package:infrastructure/interfaces/isignature_service.dart';
import 'package:infrastructure/interfaces/isignature_store.dart';
import 'package:infrastructure/interfaces/iauthentication_service.dart';
import 'package:infrastructure/interfaces/ichallanage_service.dart';
import 'package:infrastructure/interfaces/itoken_service.dart';
import 'package:infrastructure/interfaces/isync_service.dart';

GetIt getIt = GetIt.I;
void registerDependency() async {
  getIt.registerSingleton<IHttpProviderService>(HttpProvider());
  getIt.registerSingleton<IObserver>(Observer());
  getIt.registerSingleton<IChallangeService>(ChallangeService());
  getIt.registerSingleton<ILoggingService>(LoggingService());
  getIt.registerLazySingleton<IPageRouterService>(() {
    IObserver observer = getIt.get<IObserver>();
    return PageRouterService(observer);
  });
  getIt.registerSingleton<IlocalStorage>(LocalStorage());
  getIt.registerSingleton<ISignatureService>(SignatureService());
  getIt.registerLazySingleton<IConfiguration>(() {
    IlocalStorage localStorage = getIt.get<IlocalStorage>();
    return Configuration(storage: localStorage);
  });
  getIt.registerLazySingleton<ISecretManager>(
    () {
      IlocalStorage storage = getIt.get<IlocalStorage>();
      return SecretManger(
        localStorage: storage,
      );
    },
  );
  getIt.registerLazySingleton<IIdentityManager>(
    () {
      IlocalStorage storage0 = getIt.get<IlocalStorage>();
      ISignatureService signatureService = getIt.get<ISignatureService>();
      return IdentityManager(
        signatureService,
        storage0,
      );
    },
  );
  getIt.registerLazySingleton<ISignatureStore>(
    () {
      IlocalStorage storage1 = getIt.get<IlocalStorage>();
      return SignatureStore(storage1);
    },
  );
  getIt.registerLazySingleton<IAuthenticationService>(
    () {
      IHttpProviderService provider = getIt.get<IHttpProviderService>();
      return AuthenticationService(provider);
    },
  );
  getIt.registerLazySingleton<IOtpService>(
    () {
      IlocalStorage storage2 = getIt.get<IlocalStorage>();

      return OtpService(storage2);
    },
  );
  getIt.registerLazySingleton<IAuthorizationService>(
    () {
      IlocalStorage storage = getIt.get<IlocalStorage>();
      IOtpService otpService = getIt.get<IOtpService>();

      return AutherizationService(otpService, storage);
    },
  );
  getIt.registerLazySingleton<IHttpServer>(
    () {
      ILocalNetworkService localNetworkService =
          getIt.get<ILocalNetworkService>();
      ISignatureService signatureService = getIt.get<ISignatureService>();
      IChallangeService challangeService = getIt.get<IChallangeService>();
      ITokenService tokenService = getIt.get<ITokenService>();
      ISecretManager secretManager = getIt.get<ISecretManager>();
      IIdentityManager identityManager = getIt.get<IIdentityManager>();
      IOtpService otpService = getIt.get<IOtpService>();
      ISyncService syncService = getIt.get<ISyncService>();

      return HttpServer(
        localNetworkService,
        signatureService,
        challangeService,
        tokenService,
        secretManager,
        identityManager,
        otpService,
        syncService,
      );
    },
  );
  getIt.registerLazySingleton<ILocalNetworkService>(
    () {
      IHttpProviderService httpService = getIt.get<IHttpProviderService>();
      ISignatureService signatureService = getIt.get<ISignatureService>();
      IlocalStorage localStorage = getIt.get<IlocalStorage>();
      ISessionService sessionService = getIt.get<ISessionService>();
      IDevicesService deviceService = getIt.get<IDevicesService>();

      return LocalNetworkService(
        httpService,
        signatureService,
        localStorage,
        sessionService,
        deviceService,
      );
    },
  );
  getIt.registerLazySingleton<ITokenService>(
    () {
      IConfiguration configuration = getIt.get<IConfiguration>();
      IlocalStorage storage = getIt.get<IlocalStorage>();
      ILocalNetworkService localNetwork = getIt.get<ILocalNetworkService>();

      return TokenService(configuration, storage, localNetwork);
    },
  );
  getIt.registerLazySingleton<IDevicesService>(
    () {
      IlocalStorage storage = getIt.get<IlocalStorage>();
      IHttpProviderService providerService = getIt.get<IHttpProviderService>();

      return DeviceService(storage, providerService);
    },
  );
  getIt.registerLazySingleton<IExceptionManager>(
    () {
      ILoggingService loggingService = getIt.get<ILoggingService>();

      return ExceptionManager(loggingService);
    },
  );
  getIt.registerLazySingleton<ISessionService>(
    () {
      IlocalStorage localStorage = getIt.get<IlocalStorage>();

      return SessionService(localStorage);
    },
  );
  getIt.registerLazySingleton<ISyncService>(
    () {
      IlocalStorage localStorage = getIt.get<IlocalStorage>();
      ISecretManager secretManager = getIt.get<ISecretManager>();
      IIdentityManager identityManager = getIt.get<IIdentityManager>();
      IOtpService otpService = getIt.get<IOtpService>();
      ISessionService sessionService = getIt.get<ISessionService>();
      ILocalNetworkService localNetwork = getIt.get<ILocalNetworkService>();
      IHttpProviderService httpProviderService =
          getIt.get<IHttpProviderService>();
      return SyncService(localStorage, secretManager, identityManager,
          otpService, sessionService, localNetwork, httpProviderService);
    },
  );
}

void registerFactory<T>(FactoryFunc<T> func) {
  getIt.registerFactory(() => func);
}

void registerSingleton<T>(FactoryFunc<T> instance) {
  getIt.registerSingleton(instance);
}

void registerLazySingleton<T>(FactoryFunc<T> func) {
  getIt.registerLazySingleton(() => func);
}
