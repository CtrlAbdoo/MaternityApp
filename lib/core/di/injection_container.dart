import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:maternity_app/core/network/network_info.dart';
import 'package:maternity_app/data/datasources/auth_remote_datasource.dart';
import 'package:maternity_app/data/datasources/medication_remote_datasource.dart';
import 'package:maternity_app/data/datasources/pregnancy_remote_datasource.dart';
import 'package:maternity_app/data/datasources/user_datasource.dart' as user_data;
import 'package:maternity_app/data/datasources/user_local_datasource.dart';
import 'package:maternity_app/data/datasources/user_remote_datasource.dart' as user_remote;
import 'package:maternity_app/data/repositories/auth_repository_impl.dart';
import 'package:maternity_app/data/repositories/medication_repository_impl.dart';
import 'package:maternity_app/data/repositories/pregnancy_repository_impl.dart';
import 'package:maternity_app/data/repositories/user_repository_impl.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';
import 'package:maternity_app/domain/repositories/medication_repository.dart';
import 'package:maternity_app/domain/repositories/pregnancy_repository.dart';
import 'package:maternity_app/domain/repositories/user_repository.dart';
import 'package:maternity_app/domain/usecases/auth/get_current_user.dart';
import 'package:maternity_app/domain/usecases/auth/sign_in_with_email.dart';
import 'package:maternity_app/domain/usecases/auth/sign_out.dart';
import 'package:maternity_app/domain/usecases/auth/sign_up_with_email.dart';
import 'package:maternity_app/domain/usecases/medication/add_medication.dart';
import 'package:maternity_app/domain/usecases/medication/get_medications.dart';
import 'package:maternity_app/domain/usecases/pregnancy/get_current_pregnancy.dart';
import 'package:maternity_app/domain/usecases/pregnancy/update_pregnancy.dart';
import 'package:maternity_app/domain/usecases/user/get_user_profile.dart';
import 'package:maternity_app/domain/usecases/user/update_user_profile.dart';
import 'package:maternity_app/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/medication/medication_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/pregnancy/pregnancy_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/user/user_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// Initialize dependencies
Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthDataSource(auth: sl()),
  );
  
  // First register the base data source used by the remote data source
  sl.registerLazySingleton<user_data.UserDataSource>(
    () => user_data.FirebaseUserDataSource(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<user_remote.UserRemoteDataSource>(
    () => user_remote.FirebaseUserDataSource(
      userDataSource: sl<user_data.UserDataSource>(),
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<UserLocalDataSource>(
    () => SharedPrefsUserDataSource(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<PregnancyRemoteDataSource>(
    () => FirebasePregnancyDataSource(firestore: sl()),
  );
  sl.registerLazySingleton<MedicationRemoteDataSource>(
    () => FirebaseMedicationDataSource(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<user_remote.UserRemoteDataSource>(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PregnancyRepository>(
    () => PregnancyRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  // Auth
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  
  // User
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  
  // Pregnancy
  sl.registerLazySingleton(() => GetCurrentPregnancy(sl()));
  sl.registerLazySingleton(() => UpdatePregnancy(sl()));
  
  // Medication
  sl.registerLazySingleton(() => GetMedications(sl()));
  sl.registerLazySingleton(() => AddMedication(sl()));

  // ViewModels
  sl.registerFactory(
    () => AuthViewModel(
      getCurrentUser: sl(),
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signOut: sl(),
    ),
  );
  sl.registerFactory(
    () => UserViewModel(
      getUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );
  sl.registerFactory(
    () => PregnancyViewModel(
      getCurrentPregnancy: sl(),
      updatePregnancy: sl(),
    ),
  );
  sl.registerFactory(
    () => MedicationViewModel(
      getMedications: sl(),
      addMedication: sl(),
    ),
  );
}

/// Register view models for a specific feature
void registerFeatureViewModels() {
  // Register feature-specific view models here
  // Example:
  // sl.registerFactory(() => PregnancyViewModel(getCurrentPregnancy: sl()));
}

/// Clean up resources
void dispose() {
  // Clean up any resources if needed
} 