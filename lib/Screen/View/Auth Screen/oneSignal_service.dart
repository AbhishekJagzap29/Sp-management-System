import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  static const String _appId = "6b0ada3a-1709-41de-b400-1ea65a035c08";
  String? _playerId;
  bool _initialized = false;

  /// Initialize OneSignal
  Future<void> initOneSignal() async {
    if (_initialized) return;

    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // Initialize SDK
      OneSignal.initialize(_appId);

      // Request notification permission
      final permission = await OneSignal.Notifications.requestPermission(true);
      if (!permission) {
        debugPrint('❌ Notification permission denied');
        return;
      }

      // Try to get Player ID
      _playerId = OneSignal.User.pushSubscription.id;
      debugPrint("🎯 Initial OneSignal Player ID: $_playerId");

      // Listen for subscription changes
      OneSignal.User.pushSubscription.addObserver((state) {
        _playerId = state.current.id;
        debugPrint("✅ OneSignal Player ID Updated: $_playerId");
      });

      // Setup notification listeners
      _setupNotificationListeners();

      _initialized = true;
      debugPrint("✅ OneSignal initialized successfully");
    } catch (e) {
      debugPrint('❌ OneSignal initialization error: $e');
    }
  }

  /// Retry mechanism to fetch Player ID
  Future<String?> getPlayerId({int retries = 5}) async {
    if (!_initialized) {
      await initOneSignal();
    }

    int attempts = 0;
    while ((_playerId == null || _playerId!.isEmpty) && attempts < retries) {
      await Future.delayed(const Duration(seconds: 2));
      _playerId = OneSignal.User.pushSubscription.id;
      attempts++;
      debugPrint('⏳ Waiting for Player ID (attempt $attempts) -> $_playerId');
    }

    return _playerId;
  }

  /// Get cached Player ID
  String? get playerId => _playerId;

  void _setupNotificationListeners() {
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('🔔 Notification clicked: ${event.notification.notificationId}');
      debugPrint('Title: ${event.notification.title}');
      debugPrint('Body: ${event.notification.body}');
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint('📲 Foreground notification: ${event.notification.jsonRepresentation()}');
    });

    OneSignal.InAppMessages.addClickListener((event) {
      debugPrint("💬 In-app message clicked: ${event.message}");
    });
  }
}



















// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:flutter/foundation.dart';

// class OneSignalService {
//   static final OneSignalService _instance = OneSignalService._internal();
//   factory OneSignalService() => _instance;
//   OneSignalService._internal();

//   static const String _appId = "6b0ada3a-1709-41de-b400-1ea65a035c08";
//   String? _playerId;
//   bool _initialized = false;

//   /// Initialize OneSignal
//   Future<void> initOneSignal() async {
//     if (_initialized) return;
    
//     try {
//       OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

//       // Initialize SDK
//       OneSignal.initialize(_appId);

//       // Request permission for notifications
//       final permission = await OneSignal.Notifications.requestPermission(true);
//       if (!permission) {
//         debugPrint('Notification permission denied');
//         return;
//       }

//       // Get current device state and player ID
//       final deviceState = await OneSignal.User.pushSubscription;
//       _playerId = deviceState.id;
//       debugPrint("Initial OneSignal Player ID: $_playerId");

//       // Listen for player ID changes
//       OneSignal.User.pushSubscription.addObserver((state) {
//         _playerId = state.current.id;
//         debugPrint("OneSignal Player ID Updated: $_playerId");
//       });

//       // Set up notification listeners
//       _setupNotificationListeners();
      
//       _initialized = true;
//       debugPrint("OneSignal initialized successfully");
//     } catch (e) {
//       debugPrint('OneSignal initialization error: $e');
//     }
//   }

//   /// Set up notification listeners
//   void _setupNotificationListeners() {
//     // Notification click listener
//     OneSignal.Notifications.addClickListener((event) {
//       debugPrint('Notification clicked: ${event.notification.notificationId}');
//       debugPrint('Title: ${event.notification.title}');
//       debugPrint('Body: ${event.notification.body}');
//     });

//     // Foreground notification display listener
//     OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//       debugPrint('Notification will display: ${event.notification.jsonRepresentation()}');
//     });

//     // In-app message click listener
//     OneSignal.InAppMessages.addClickListener((event) {
//       debugPrint("In-app message clicked: ${event.message}");
//     });
//   }

//   /// Get Player ID with retry mechanism
//   Future<String?> getPlayerId({int retries = 3}) async {
//     if (!_initialized) {
//       await initOneSignal();
//     }

//     // If playerId is still null, wait and retry
//     int attempts = 0;
//     while (_playerId == null && attempts < retries) {
//       await Future.delayed(const Duration(seconds: 1));
//       attempts++;
//       debugPrint('Waiting for Player ID (attempt $attempts)');
//     }

//     return _playerId;
//   }

//   /// Get current Player ID (cached)
//   String? get playerId => _playerId;
// }
