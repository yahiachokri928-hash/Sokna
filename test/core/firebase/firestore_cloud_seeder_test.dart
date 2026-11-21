import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/firebase/firestore_cloud_seeder.dart';

void main() {
  test('FirestoreCloudSeeder contains exactly 10 authentic Tunisian demo accounts', () {
    expect(FirestoreCloudSeeder.demoLandlords.length, equals(6));
    expect(FirestoreCloudSeeder.demoTenants.length, equals(4));
    expect(FirestoreCloudSeeder.allDemoAccounts.length, equals(10));

    for (final account in FirestoreCloudSeeder.allDemoAccounts) {
      expect(account.email, endsWith('@sokna.tn'));
      expect(account.phone, startsWith('+216'));
      expect(account.password, equals('Sokna2026!'));
      expect(account.avatarUrl, startsWith('https://images.unsplash.com'));
      expect(account.name.isNotEmpty, isTrue);
    }
  });

  test('FirestoreCloudSeeder landlords have role Propriétaire and tenants Locataire', () {
    for (final landlord in FirestoreCloudSeeder.demoLandlords) {
      expect(landlord.role, equals('Propriétaire'));
    }

    for (final tenant in FirestoreCloudSeeder.demoTenants) {
      expect(tenant.role, equals('Locataire'));
      expect(tenant.savedListingIds.isNotEmpty, isTrue);
    }
  });
}
