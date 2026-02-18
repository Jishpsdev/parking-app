import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// Migration script to create Firebase Auth users and restructure user data
/// 
/// This script:
/// 1. Reads existing users from 'users' collection
/// 2. Creates Firebase Auth accounts with email/password
/// 3. Updates user documents to use Firebase Auth UID as document ID
/// 4. Removes email field (since it's in Firebase Auth)
Future<void> migrateUsersToFirebaseAuth() async {
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = auth.FirebaseAuth.instance;
  
  print('🚀 Starting user migration to Firebase Auth...');
  print('');
  
  try {
    // Get all users from the current collection
    final usersSnapshot = await firestore.collection('users').get();
    
    if (usersSnapshot.docs.isEmpty) {
      print('⚠️  No users found to migrate');
      return;
    }
    
    print('📊 Found ${usersSnapshot.docs.length} users to migrate');
    print('');
    
    int successCount = 0;
    int skipCount = 0;
    int errorCount = 0;
    
    for (final doc in usersSnapshot.docs) {
      final userData = doc.data();
      final email = userData['email'] as String;
      final name = userData['name'] as String;
      final userType = userData['userType'] as String;
      
      try {
        // Default password for migration (users should reset this)
        const defaultPassword = 'Password123!';
        
        print('👤 Migrating: $name ($email)...');
        
        // Create Firebase Auth user
        auth.UserCredential userCredential;
        try {
          userCredential = await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: defaultPassword,
          );
        } catch (e) {
          if (e.toString().contains('email-already-in-use')) {
            print('   ⚠️  Auth user already exists, fetching existing user...');
            
            // Sign in to get the user
            userCredential = await firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: defaultPassword,
            );
            skipCount++;
          } else {
            throw e;
          }
        }
        
        final authUser = userCredential.user!;
        
        // Update display name in Firebase Auth
        await authUser.updateDisplayName(name);
        
        // Create/Update user document with Auth UID as document ID
        await firestore.collection('users').doc(authUser.uid).set({
          'name': name,
          'userType': userType,
          'currentLocation': userData['currentLocation'],
          'activeReservationId': userData['activeReservationId'],
          'createdAt': userData['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
        
        // Delete old document if it has a different ID
        if (doc.id != authUser.uid) {
          await firestore.collection('users').doc(doc.id).delete();
          print('   ✓ Created Auth user and migrated data (UID: ${authUser.uid})');
        } else {
          print('   ✓ Updated existing document');
        }
        
        // Sign out after migration
        await firebaseAuth.signOut();
        
        successCount++;
      } catch (e) {
        print('   ❌ Error: $e');
        errorCount++;
      }
      
      print('');
    }
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('✅ MIGRATION COMPLETE!');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📊 Summary:');
    print('   • Successfully migrated: $successCount');
    print('   • Skipped (already exists): $skipCount');
    print('   • Errors: $errorCount');
    print('   • Total processed: ${usersSnapshot.docs.length}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');
    print('⚠️  IMPORTANT:');
    print('   • Default password: "Password123!"');
    print('   • Users should change their password on first login');
    print('   • Email field removed from Firestore (now in Firebase Auth)');
    print('   • Document IDs now use Firebase Auth UIDs');
    print('');
  } catch (e) {
    print('❌ Migration failed: $e');
    rethrow;
  }
}
