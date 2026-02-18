import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/datasources/parking_remote_datasource.dart';
import '../services/notification_service.dart';
import '../services/pwa_service.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/parking_lot_repository_impl.dart';
import '../../data/repositories/parking_slot_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/parking_lot_repository.dart';
import '../../domain/repositories/parking_slot_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_parking_lots_usecase.dart';
import '../../domain/usecases/get_user_by_email_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/occupy_slot_usecase.dart';
import '../../domain/usecases/release_slot_usecase.dart';
import '../../domain/usecases/reserve_slot_usecase.dart';
import '../../domain/usecases/watch_slots_usecase.dart';
import '../../domain/usecases/watch_slots_with_bookings_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/parking_lot/parking_lot_bloc.dart';
import '../../presentation/bloc/slot/slot_bloc.dart';

/// Dependency Injection Container
/// Uses GetIt for service locator pattern
/// Follows Dependency Inversion Principle
final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ============ External Dependencies ============
  
  // Firebase
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  
  sl.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );
  
  // ============ Data Sources ============
  
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );
  
  sl.registerLazySingleton<ParkingRemoteDataSource>(
    () => ParkingRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );
  
  sl.registerLazySingleton<NotificationDataSource>(
    () => NotificationDataSourceImpl(
      firebaseMessaging: sl(),
    ),
  );
  
  // ============ Services ============
  
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(
      dataSource: sl(),
      repository: sl(),
    ),
  );
  
  sl.registerLazySingleton<PWAService>(
    () => PWAService(),
  );
  
  // ============ Repositories ============
  
  sl.registerLazySingleton<ParkingLotRepository>(
    () => ParkingLotRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<ParkingSlotRepository>(
    () => ParkingSlotRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      dataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );
  
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      firestore: sl(),
    ),
  );
  
  // ============ Use Cases ============
  
  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(
      repository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => GetUserByEmailUseCase(
      repository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => GetUserByIdUseCase(sl()),
  );
  
  sl.registerLazySingleton(
    () => GetParkingLotsUseCase(
      repository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => ReserveSlotUseCase(
      bookingRepository: sl(),
      lotRepository: sl(),
      locationRepository: sl(),
      userRepository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => OccupySlotUseCase(
      bookingRepository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => ReleaseSlotUseCase(
      bookingRepository: sl(),
      userRepository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => WatchSlotsUseCase(
      repository: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => WatchSlotsWithBookingsUseCase(
      slotRepository: sl(),
      bookingRepository: sl(),
    ),
  );
  
  // ============ BLoCs ============
  
  sl.registerFactory(
    () => AuthBloc(
      authDataSource: sl(),
      getCurrentUserUseCase: sl(),
      notificationService: sl(),
    ),
  );
  
  sl.registerFactory(
    () => ParkingLotBloc(
      getParkingLotsUseCase: sl(),
    ),
  );
  
  sl.registerFactory(
    () => SlotBloc(
      watchSlotsWithBookingsUseCase: sl(),
      reserveSlotUseCase: sl(),
      occupySlotUseCase: sl(),
      releaseSlotUseCase: sl(),
    ),
  );
}
