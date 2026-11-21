import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'firestore_service.dart';

class TunisianDemoAccount {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String role;
  final String city;
  final String subtitle;
  final String avatarUrl;
  final List<String> savedListingIds;

  const TunisianDemoAccount({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
    required this.city,
    required this.subtitle,
    required this.avatarUrl,
    this.savedListingIds = const [],
  });
}

class FirestoreCloudSeeder {
  final AuthService authService;
  final FirestoreService firestoreService;

  static const String demoPassword = 'Sokna2026!';

  static const List<TunisianDemoAccount> demoLandlords = [
    TunisianDemoAccount(
      email: 'amine.benali@sokna.tn',
      password: demoPassword,
      name: 'Amine Ben Ali',
      phone: '+216 98 123 456',
      role: 'Propriétaire',
      city: 'Bizerte',
      subtitle: 'Bizerte (Vieux Port, Corniche & Rimel)',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    ),
    TunisianDemoAccount(
      email: 'salma.trabelsi@sokna.tn',
      password: demoPassword,
      name: 'Salma Trabelsi',
      phone: '+216 22 234 567',
      role: 'Propriétaire',
      city: 'La Marsa',
      subtitle: 'La Marsa & Gammarth',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    ),
    TunisianDemoAccount(
      email: 'youssef.gharbi@sokna.tn',
      password: demoPassword,
      name: 'Youssef Gharbi',
      phone: '+216 50 345 678',
      role: 'Propriétaire',
      city: 'Hammamet',
      subtitle: 'Hammamet & Nabeul',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    ),
    TunisianDemoAccount(
      email: 'ons.mansouri@sokna.tn',
      password: demoPassword,
      name: 'Ons Mansouri',
      phone: '+216 97 456 789',
      role: 'Propriétaire',
      city: 'Sousse',
      subtitle: 'Sousse (Kantaoui, Sahloul & Centre)',
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
    ),
    TunisianDemoAccount(
      email: 'mehdi.bouazizi@sokna.tn',
      password: demoPassword,
      name: 'Mehdi Bouazizi',
      phone: '+216 24 567 890',
      role: 'Propriétaire',
      city: 'Tunis',
      subtitle: 'Tunis & Ariana (Ennasr, Centre Urbain Nord)',
      avatarUrl:
          'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80',
    ),
    TunisianDemoAccount(
      email: 'nourhene.khelifi@sokna.tn',
      password: demoPassword,
      name: 'Nourhene Khelifi',
      phone: '+216 55 678 901',
      role: 'Propriétaire',
      city: 'Monastir',
      subtitle: 'Monastir, Ghazala & La Soukra',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
    ),
  ];

  static const List<TunisianDemoAccount> demoTenants = [
    TunisianDemoAccount(
      email: 'aziz.chaabane@sokna.tn',
      password: demoPassword,
      name: 'Aziz Chaabane',
      phone: '+216 28 789 012',
      role: 'Locataire',
      city: 'Bizerte',
      subtitle: 'Étudiant ISET Bizerte',
      avatarUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
      savedListingIds: ['sokna_001', 'sokna_005', 'sokna_011', 'sokna_014'],
    ),
    TunisianDemoAccount(
      email: 'meriem.jaziri@sokna.tn',
      password: demoPassword,
      name: 'Meriem Jaziri',
      phone: '+216 99 890 123',
      role: 'Locataire',
      city: 'Tunis',
      subtitle: 'Cadre supérieure • Tunis',
      avatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
      savedListingIds: ['sokna_001', 'sokna_003', 'sokna_008', 'sokna_012'],
    ),
    TunisianDemoAccount(
      email: 'bilel.hammami@sokna.tn',
      password: demoPassword,
      name: 'Bilel Hammami',
      phone: '+216 23 901 234',
      role: 'Locataire',
      city: 'Sousse',
      subtitle: 'Ingénieur • Sousse',
      avatarUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
      savedListingIds: ['sokna_003', 'sokna_009', 'sokna_010', 'sokna_015'],
    ),
    TunisianDemoAccount(
      email: 'ines.dridi@sokna.tn',
      password: demoPassword,
      name: 'Ines Dridi',
      phone: '+216 52 012 345',
      role: 'Locataire',
      city: 'Sfax',
      subtitle: 'Médecin interne • Sfax',
      avatarUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
      savedListingIds: ['sokna_002', 'sokna_004', 'sokna_013', 'sokna_016'],
    ),
  ];

  static List<TunisianDemoAccount> get allDemoAccounts => [
        ...demoLandlords,
        ...demoTenants,
      ];

  static List<TunisianDemoAccount> get demoAccounts => allDemoAccounts;

  FirestoreCloudSeeder({
    required this.authService,
    required this.firestoreService,
  });

  /// Seeds or reseeds the cloud Firestore database with 10 authentic Tunisian accounts,
  /// 16 authentic rental listings, and 36 tenant reviews.
  Future<void> seedCloudDatabase({bool forceReseed = false}) async {
    try {
      // 1. Idempotency check: if listings exist and forceReseed is false, exit early
      if (!forceReseed) {
        final existing = await firestoreService.listingsCollection.limit(1).get();
        if (existing.docs.isNotEmpty) {
          return;
        }
      }

      final Map<String, String> emailToUid = {};

      // 2. Create or sign into each of the 10 Tunisian accounts and save profiles
      for (final account in allDemoAccounts) {
        final uid = await _createOrSignInUser(account);
        emailToUid[account.email] = uid;
      }

      // 3. Define the 16 authentic Tunisian listings mapped to their respective landlords
      final listings = _getTunisianListings(emailToUid);

      // 4. Define the 36 realistic reviews across the listings
      final reviews = _getTunisianReviews(emailToUid);

      // 5. Seed listings for each landlord
      for (final listing in listings) {
        final ownerEmail = listing['ownerEmail'] as String;
        final ownerUid = emailToUid[ownerEmail]!;

        // Sign in as landlord to satisfy security rules (resource.data.ownerId == request.auth.uid)
        await _signInWithEmail(ownerEmail, demoPassword);

        final listingData = Map<String, dynamic>.from(listing)
          ..remove('ownerEmail')
          ..['ownerId'] = ownerUid
          ..['createdAt'] = FieldValue.serverTimestamp();

        await firestoreService.listingsCollection
            .doc(listing['id'] as String)
            .set(listingData, SetOptions(merge: true));
      }

      // 6. Seed reviews by signing in as each respective tenant
      final groupedReviewsByTenant = <String, List<Map<String, dynamic>>>{};
      for (final rev in reviews) {
        final tenantEmail = rev['tenantEmail'] as String;
        groupedReviewsByTenant.putIfAbsent(tenantEmail, () => []).add(rev);
      }

      for (final entry in groupedReviewsByTenant.entries) {
        final tenantEmail = entry.key;
        final tenantUid = emailToUid[tenantEmail]!;
        final tenantReviews = entry.value;

        // Sign in as tenant so request.auth.uid == reviewId
        await _signInWithEmail(tenantEmail, demoPassword);

        for (final rev in tenantReviews) {
          final listingId = rev['listingId'] as String;
          final reviewDoc = firestoreService.listingsCollection
              .doc(listingId)
              .collection('reviews')
              .doc(tenantUid);

          await reviewDoc.set({
            'id': tenantUid,
            'listingId': listingId,
            'userId': tenantUid,
            'userName': rev['userName'],
            'userAvatarUrl': rev['userAvatarUrl'],
            'rating': rev['rating'],
            'comment': rev['comment'],
            'createdAt': Timestamp.fromDate(rev['createdAt'] as DateTime),
          }, SetOptions(merge: true));
        }
      }

      // 7. Calculate exact average rating and reviewCount for each listing and update
      for (final listing in listings) {
        final listingId = listing['id'] as String;
        final snapshot = await firestoreService.listingsCollection
            .doc(listingId)
            .collection('reviews')
            .get();

        if (snapshot.docs.isNotEmpty) {
          final count = snapshot.docs.length;
          double total = 0.0;
          for (final doc in snapshot.docs) {
            total += (doc.data()['rating'] as num?)?.toDouble() ?? 5.0;
          }
          final double average = double.parse((total / count).toStringAsFixed(1));

          await firestoreService.listingsCollection.doc(listingId).update({
            'rating': average,
            'reviewCount': count,
          });
        }
      }

      // 8. Sign out so the application starts in clean unauthenticated / guest state
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Allows graceful continuation in offline or restricted environments
    }
  }

  Future<String> _createOrSignInUser(TunisianDemoAccount account) async {
    UserCredential cred;
    try {
      cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: account.email,
        password: account.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: account.email,
          password: account.password,
        );
      } else {
        rethrow;
      }
    }

    final user = cred.user!;
    await user.updateDisplayName(account.name);
    await user.updatePhotoURL(account.avatarUrl);

    // Write user document to Cloud Firestore
    await firestoreService.usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'name': account.name,
      'email': account.email,
      'profilURL': account.avatarUrl,
      'phone': account.phone,
      'role': account.role,
      'city': account.city,
      'savedListingIds': account.savedListingIds,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));

    return user.uid;
  }

  Future<void> _signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {}
  }

  List<Map<String, dynamic>> _getTunisianListings(Map<String, String> emailToUid) {
    return [
      {
        'id': 'sokna_001',
        'title': 'S+2 moderne avec vue panoramique sur mer',
        'city': 'La Marsa',
        'address': 'Avenue Habib Bourguiba, Marsa Plage',
        'propertyType': 'Appartement',
        'price': 1650,
        'rooms': 3,
        'surface': 110.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.9,
        'reviewCount': 3,
        'ownerEmail': 'salma.trabelsi@sokna.tn',
        'ownerName': 'Salma Trabelsi',
        'ownerPhone': '+216 22 234 567',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-01',
        'description':
            'Magnifique appartement S+2 haut standing entièrement meublé situé au cœur de La Marsa, à deux pas de la plage. Salon lumineux avec baie vitrée, cuisine équipée, suite parentale, climatisation centrale et place de parking en sous-sol.',
      },
      {
        'id': 'sokna_002',
        'title': 'Studio cosy pour étudiant ou jeune cadre',
        'city': 'Tunis',
        'address': 'Rue Alain Savary, Cité El Khadra',
        'propertyType': 'Studio',
        'price': 650,
        'rooms': 1,
        'surface': 42.0,
        'isFurnished': true,
        'hasParking': false,
        'imagePath':
            'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.6,
        'reviewCount': 2,
        'ownerEmail': 'mehdi.bouazizi@sokna.tn',
        'ownerName': 'Mehdi Bouazizi',
        'ownerPhone': '+216 24 567 890',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-25',
        'description':
            'Studio très bien agencé dans un immeuble sécurisé avec digicode et ascenseur. Proche des stations de métro et de toutes les commodités du centre urbain nord.',
      },
      {
        'id': 'sokna_003',
        'title': 'Villa contemporaine avec piscine et grand jardin',
        'city': 'Sousse',
        'address': 'Zone Touristique El Kantaoui',
        'propertyType': 'Villa',
        'price': 3200,
        'rooms': 6,
        'surface': 360.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=1200&q=80',
        'rating': 5.0,
        'reviewCount': 2,
        'ownerEmail': 'ons.mansouri@sokna.tn',
        'ownerName': 'Ons Mansouri',
        'ownerPhone': '+216 97 456 789',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-15',
        'description':
            'Somptueuse villa d\'architecte avec piscine privée sans vis-à-vis, vaste séjour traversant, 4 suites avec dressings, cuisine haut de gamme et garage fermé pour 2 voitures.',
      },
      {
        'id': 'sokna_004',
        'title': 'S+3 spacieux dans résidence calme et gardée',
        'city': 'Ariana',
        'address': 'Avenue Hédi Nouira, Ennasr 2',
        'propertyType': 'Appartement',
        'price': 1400,
        'rooms': 4,
        'surface': 145.0,
        'isFurnished': false,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.7,
        'reviewCount': 2,
        'ownerEmail': 'mehdi.bouazizi@sokna.tn',
        'ownerName': 'Mehdi Bouazizi',
        'ownerPhone': '+216 24 567 890',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-01',
        'description':
            'Grand appartement familial S+3 au 3ème étage avec ascenseur. Grand salon ouvrant sur un balcon avec vue dégagée, cuisine spacieuse avec séchoir et suite parentale.',
      },
      {
        'id': 'sokna_005',
        'title': 'Maison de charme avec patio traditionnel au Vieux Port',
        'city': 'Bizerte',
        'address': 'Quartier du Vieux Port, Bizerte',
        'propertyType': 'Maison',
        'price': 950,
        'rooms': 4,
        'surface': 160.0,
        'isFurnished': true,
        'hasParking': false,
        'imagePath':
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.9,
        'reviewCount': 3,
        'ownerEmail': 'amine.benali@sokna.tn',
        'ownerName': 'Amine Ben Ali',
        'ownerPhone': '+216 98 123 456',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-28',
        'description':
            'Authentique maison rénovée au bord du vieux port avec patio central lumineux, carrelage traditionnel, terrasse sur le toit offrant une vue imprenable sur le chenal.',
      },
      {
        'id': 'sokna_006',
        'title': 'Appartement S+1 pied dans l\'eau',
        'city': 'Nabeul',
        'address': 'Avenue Habib Thameur, Plage de Nabeul',
        'propertyType': 'Appartement',
        'price': 850,
        'rooms': 2,
        'surface': 65.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.6,
        'reviewCount': 2,
        'ownerEmail': 'youssef.gharbi@sokna.tn',
        'ownerName': 'Youssef Gharbi',
        'ownerPhone': '+216 50 345 678',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-05',
        'description':
            'Bel appartement S+1 avec terrasse face à la mer méditerranée. Idéal pour un couple ou travailleur nomade, meublé à neuf, wifi haut débit et parking sécurisé inclus.',
      },
      {
        'id': 'sokna_007',
        'title': 'Studio moderne proche facultés et technopôle',
        'city': 'Ariana',
        'address': 'Cité El Ghazala, Technopôle',
        'propertyType': 'Studio',
        'price': 550,
        'rooms': 1,
        'surface': 38.0,
        'isFurnished': true,
        'hasParking': false,
        'imagePath':
            'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.4,
        'reviewCount': 2,
        'ownerEmail': 'nourhene.khelifi@sokna.tn',
        'ownerName': 'Nourhene Khelifi',
        'ownerPhone': '+216 55 678 901',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-20',
        'description':
            'Studio fonctionnel spécialement équipé pour étudiants de SupCom, ESPRIT ou jeunes ingénieurs. Kitchenette équipée, bureau, lit double et connexion fibre.',
      },
      {
        'id': 'sokna_008',
        'title': 'Villa de standing avec pelouse et abri 3 voitures',
        'city': 'La Marsa',
        'address': 'Rue des Jasmins, Gammarth Supérieur',
        'propertyType': 'Villa',
        'price': 4500,
        'rooms': 5,
        'surface': 420.0,
        'isFurnished': false,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
        'rating': 5.0,
        'reviewCount': 2,
        'ownerEmail': 'salma.trabelsi@sokna.tn',
        'ownerName': 'Salma Trabelsi',
        'ownerPhone': '+216 22 234 567',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2027-01-01',
        'description':
            'Prestigieuse villa neuve sur les hauteurs de Gammarth. Architecture épurée, triples réceptions, baies vitrées chauffées au sol, suite parentale de 50 m² et système de vidéosurveillance.',
      },
      {
        'id': 'sokna_009',
        'title': 'Maison mitoyenne avec terrasse et garage',
        'city': 'Nabeul',
        'address': 'Boulevard de l\'Environnement, Hammamet Nord',
        'propertyType': 'Maison',
        'price': 1350,
        'rooms': 4,
        'surface': 175.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.7,
        'reviewCount': 2,
        'ownerEmail': 'youssef.gharbi@sokna.tn',
        'ownerName': 'Youssef Gharbi',
        'ownerPhone': '+216 50 345 678',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-10',
        'description':
            'Jolie maison de vacances ou résidence principale à 5 minutes de la plage de Hammamet Nord. Spacieux salon avec cheminée, 3 chambres, cour arborée et barbecue.',
      },
      {
        'id': 'sokna_010',
        'title': 'S+2 neuf dans résidence avec piscine commune',
        'city': 'Sousse',
        'address': 'Route Touristique, Sahloul 4',
        'propertyType': 'Appartement',
        'price': 1100,
        'rooms': 3,
        'surface': 95.0,
        'isFurnished': false,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.6,
        'reviewCount': 2,
        'ownerEmail': 'ons.mansouri@sokna.tn',
        'ownerName': 'Ons Mansouri',
        'ownerPhone': '+216 97 456 789',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-30',
        'description':
            'Appartement S+2 dans une résidence moderne très prisée de Sahloul. Double vitrage, chauffage central, cuisine agencée, piscine pour résidents et place de parking privée.',
      },
      {
        'id': 'sokna_011',
        'title': 'Maison coquette avec cour arborée à la Corniche',
        'city': 'Bizerte',
        'address': 'Route de la Corniche, Bizerte',
        'propertyType': 'Maison',
        'price': 1200,
        'rooms': 4,
        'surface': 190.0,
        'isFurnished': false,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1598228723793-52759bba239c?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.8,
        'reviewCount': 3,
        'ownerEmail': 'amine.benali@sokna.tn',
        'ownerName': 'Amine Ben Ali',
        'ownerPhone': '+216 98 123 456',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-01',
        'description':
            'Superbe maison familiale de plain-pied située sur la Corniche de Bizerte avec vue partielle sur mer. Jardin privé clôturé, garage fermé, 3 grandes chambres et quartier calme.',
      },
      {
        'id': 'sokna_012',
        'title': 'Studio indépendant avec entrée privée et terrasse',
        'city': 'La Marsa',
        'address': 'Rue Sidi Abdelaziz, Marsa Ville',
        'propertyType': 'Studio',
        'price': 750,
        'rooms': 1,
        'surface': 45.0,
        'isFurnished': true,
        'hasParking': false,
        'imagePath':
            'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.7,
        'reviewCount': 2,
        'ownerEmail': 'salma.trabelsi@sokna.tn',
        'ownerName': 'Salma Trabelsi',
        'ownerPhone': '+216 22 234 567',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-22',
        'description':
            'Studio très calme au rez-de-jardin d\'une villa à Marsa Ville. Meublé avec goût, lit queen size, salle d\'eau italienne, kitchenette équipée et petite terrasse privée.',
      },
      {
        'id': 'sokna_013',
        'title': 'S+3 de prestige au cœur du Centre Urbain Nord',
        'city': 'Tunis',
        'address': 'Centre Urbain Nord, Tunis',
        'propertyType': 'Appartement',
        'price': 1900,
        'rooms': 4,
        'surface': 165.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1502005229762-ee1b2b8ab32f?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.9,
        'reviewCount': 2,
        'ownerEmail': 'mehdi.bouazizi@sokna.tn',
        'ownerName': 'Mehdi Bouazizi',
        'ownerPhone': '+216 24 567 890',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-01',
        'description':
            'Appartement de standing exceptionnel au 6ème étage d\'un immeuble d\'affaires récent. Finitions marbre blanc, domotique intégrée, grand séjour avec vue dégagée, deux places de parking.',
      },
      {
        'id': 'sokna_014',
        'title': 'Villa familiale avec pergola et puits à Rimel',
        'city': 'Bizerte',
        'address': 'Zone Rimel, Menzel Jemil',
        'propertyType': 'Villa',
        'price': 1800,
        'rooms': 5,
        'surface': 280.0,
        'isFurnished': false,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.7,
        'reviewCount': 2,
        'ownerEmail': 'amine.benali@sokna.tn',
        'ownerName': 'Amine Ben Ali',
        'ownerPhone': '+216 98 123 456',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-20',
        'description':
            'Agréable villa entourée de pins maritimes à deux pas de la forêt et plage de Rimel. 4 chambres, salon avec plafond voûté, grand jardin avec arbres fruitiers et espace pour 3 véhicules.',
      },
      {
        'id': 'sokna_015',
        'title': 'Studio meublé avec kitchenette au centre-ville',
        'city': 'Sousse',
        'address': 'Avenue Léopold Senghor, Sousse Centre',
        'propertyType': 'Studio',
        'price': 480,
        'rooms': 1,
        'surface': 35.0,
        'isFurnished': true,
        'hasParking': false,
        'imagePath':
            'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.4,
        'reviewCount': 2,
        'ownerEmail': 'ons.mansouri@sokna.tn',
        'ownerName': 'Ons Mansouri',
        'ownerPhone': '+216 97 456 789',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-11-25',
        'description':
            'Studio très économique et pratique en plein centre de Sousse, à 5 minutes de la Médina et de la gare. Idéal pour étudiant ou court séjour professionnel.',
      },
      {
        'id': 'sokna_016',
        'title': 'S+2 moderne avec balcon filant à La Soukra',
        'city': 'Ariana',
        'address': 'Avenue Fattouma Bourguiba, La Soukra',
        'propertyType': 'Appartement',
        'price': 1250,
        'rooms': 3,
        'surface': 105.0,
        'isFurnished': true,
        'hasParking': true,
        'imagePath':
            'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80',
        'rating': 4.9,
        'reviewCount': 2,
        'ownerEmail': 'nourhene.khelifi@sokna.tn',
        'ownerName': 'Nourhene Khelifi',
        'ownerPhone': '+216 55 678 901',
        'ownerAvatarUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
        'availableFrom': '2026-12-05',
        'description':
            'Très bel appartement S+2 situé dans un quartier résidentiel huppé de La Soukra. Cuisine américaine équipée ouverte sur un séjour contemporain, dressing encastré et cellier.',
      },
    ];
  }

  List<Map<String, dynamic>> _getTunisianReviews(Map<String, String> emailToUid) {
    return [
      // sokna_001
      {
        'listingId': 'sokna_001',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Vue mer spectaculaire depuis le salon ! L\'appartement est impeccable et Salma est une hôte formidable.',
        'createdAt': DateTime(2026, 11, 10),
      },
      {
        'listingId': 'sokna_001',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Emplacement rêvé à Marsa Plage. La brise marine le soir est magique. Tout est neuf et propre.',
        'createdAt': DateTime(2026, 11, 12),
      },
      {
        'listingId': 'sokna_001',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Excellent séjour pour le travail. Wifi rapide et place de parking très sécurisée en sous-sol.',
        'createdAt': DateTime(2026, 11, 15),
      },
      // sokna_002
      {
        'listingId': 'sokna_002',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.5,
        'comment':
            'Très pratique pour les déplacements en métro vers le centre-ville. Calme et fonctionnel.',
        'createdAt': DateTime(2026, 11, 8),
      },
      {
        'listingId': 'sokna_002',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.7,
        'comment':
            'Studio bien équipé avec tout le nécessaire pour une étudiante ou jeune cadre. Mehdi est très réactif.',
        'createdAt': DateTime(2026, 11, 14),
      },
      // sokna_003
      {
        'listingId': 'sokna_003',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Villa somptueuse ! La piscine privée est d\'une propreté exemplaire. Ons a été aux petits soins.',
        'createdAt': DateTime(2026, 11, 5),
      },
      {
        'listingId': 'sokna_003',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'Superbe cadre pour des vacances en famille. Les 4 suites sont spacieuses et bien climatisées.',
        'createdAt': DateTime(2026, 11, 9),
      },
      // sokna_004
      {
        'listingId': 'sokna_004',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Quartier animé avec tous les commerces au pied de l\'immeuble. Résidence calme et bien gardée.',
        'createdAt': DateTime(2026, 11, 7),
      },
      {
        'listingId': 'sokna_004',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.6,
        'comment':
            'Appartement très spacieux avec une belle vue dégagée depuis le balcon. Idéal pour colocation.',
        'createdAt': DateTime(2026, 11, 11),
      },
      // sokna_005
      {
        'listingId': 'sokna_005',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Un bijou architectural ! Le patio traditionnel et la terrasse sur le Vieux Port sont inoubliables.',
        'createdAt': DateTime(2026, 11, 1),
      },
      {
        'listingId': 'sokna_005',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Amine est un propriétaire exemplaire, très accueillant et serviable. Emplacement magique.',
        'createdAt': DateTime(2026, 11, 6),
      },
      {
        'listingId': 'sokna_005',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'Charme authentique bizertin, dépaysement garanti. Le carrelage et les boiseries sont magnifiques.',
        'createdAt': DateTime(2026, 11, 13),
      },
      // sokna_006
      {
        'listingId': 'sokna_006',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.6,
        'comment':
            'Accès direct à la plage de sable doré. Se réveiller avec le bruit des vagues est extraordinaire.',
        'createdAt': DateTime(2026, 11, 4),
      },
      {
        'listingId': 'sokna_006',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 4.5,
        'comment':
            'Terrasse très agréable pour les petits-déjeuners. Proche des poteries de Nabeul.',
        'createdAt': DateTime(2026, 11, 8),
      },
      // sokna_007
      {
        'listingId': 'sokna_007',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.5,
        'comment':
            'Parfait pour les étudiants de SupCom ou ingénieurs d\'El Ghazala. Connexion fibre top !',
        'createdAt': DateTime(2026, 11, 2),
      },
      {
        'listingId': 'sokna_007',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.3,
        'comment':
            'Studio bien agencé, lit confortable et résidence sécurisée avec code d\'accès.',
        'createdAt': DateTime(2026, 11, 9),
      },
      // sokna_008
      {
        'listingId': 'sokna_008',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Prestige absolu à Gammarth ! Le jardin est majestueux et le calme est total.',
        'createdAt': DateTime(2026, 11, 3),
      },
      {
        'listingId': 'sokna_008',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 5.0,
        'comment':
            'Finitions très haut de gamme, salon immense. Salma nous a réservé un accueil très chaleureux.',
        'createdAt': DateTime(2026, 11, 10),
      },
      // sokna_009
      {
        'listingId': 'sokna_009',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Maison très conviviale à 5 min de la mer. La cour avec barbecue nous a régalés.',
        'createdAt': DateTime(2026, 11, 6),
      },
      {
        'listingId': 'sokna_009',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.6,
        'comment':
            'Youssef a pensé à chaque détail. Séjour reposant dans un quartier résidentiel tranquille.',
        'createdAt': DateTime(2026, 11, 12),
      },
      // sokna_010
      {
        'listingId': 'sokna_010',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.7,
        'comment':
            'La piscine de la résidence est super propre. Logement moderne avec double vitrage efficace.',
        'createdAt': DateTime(2026, 11, 8),
      },
      {
        'listingId': 'sokna_010',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 4.5,
        'comment':
            'Très bon rapport qualité-prix à Sahloul. Ons répond toujours rapidement aux messages.',
        'createdAt': DateTime(2026, 11, 14),
      },
      // sokna_011
      {
        'listingId': 'sokna_011',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'La Corniche de Bizerte est splendide ! La cour arborée apporte une vraie fraîcheur en été.',
        'createdAt': DateTime(2026, 11, 4),
      },
      {
        'listingId': 'sokna_011',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Maison spacieuse parfaite pour une famille. Amine nous a donné d\'excellents conseils de restos.',
        'createdAt': DateTime(2026, 11, 9),
      },
      {
        'listingId': 'sokna_011',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.7,
        'comment':
            'Proximité de la mer et calme absolu. Garage fermé très pratique pour la voiture.',
        'createdAt': DateTime(2026, 11, 15),
      },
      // sokna_012
      {
        'listingId': 'sokna_012',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Studio mignon et décoré avec goût dans une ruelle typique de Marsa Ville. Je recommande !',
        'createdAt': DateTime(2026, 11, 7),
      },
      {
        'listingId': 'sokna_012',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.6,
        'comment':
            'Entrée totalement indépendante, literie très confortable. Salma est très discrète et gentille.',
        'createdAt': DateTime(2026, 11, 13),
      },
      // sokna_013
      {
        'listingId': 'sokna_013',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'Standing impressionnant au 6ème étage. La domotique et la cuisine équipée sont au top.',
        'createdAt': DateTime(2026, 11, 2),
      },
      {
        'listingId': 'sokna_013',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'Vue panoramique sur le Grand Tunis. Emplacement idéal pour les réunions d\'affaires.',
        'createdAt': DateTime(2026, 11, 10),
      },
      // sokna_014
      {
        'listingId': 'sokna_014',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.7,
        'comment':
            'L\'air pur des pins de Rimel à 2 pas de la plage. La pergola ombragée est un vrai bonheur.',
        'createdAt': DateTime(2026, 11, 6),
      },
      {
        'listingId': 'sokna_014',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 4.6,
        'comment':
            'Idéal pour se ressourcer loin du bruit. Jardin vaste avec des arbres fruitiers.',
        'createdAt': DateTime(2026, 11, 12),
      },
      // sokna_015
      {
        'listingId': 'sokna_015',
        'tenantEmail': 'bilel.hammami@sokna.tn',
        'userName': 'Bilel Hammami',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
        'rating': 4.4,
        'comment':
            'Emplacement central imbattable près de la gare et des commerces. Prix très économique.',
        'createdAt': DateTime(2026, 11, 4),
      },
      {
        'listingId': 'sokna_015',
        'tenantEmail': 'aziz.chaabane@sokna.tn',
        'userName': 'Aziz Chaabane',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
        'rating': 4.3,
        'comment':
            'Très pratique pour un court séjour ou un stage à Sousse. Hôtesse arrangeante.',
        'createdAt': DateTime(2026, 11, 11),
      },
      // sokna_016
      {
        'listingId': 'sokna_016',
        'tenantEmail': 'ines.dridi@sokna.tn',
        'userName': 'Ines Dridi',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
        'rating': 4.9,
        'comment':
            'Quartier chic et résidentiel. Cuisine américaine magnifique et finitions modernes.',
        'createdAt': DateTime(2026, 11, 5),
      },
      {
        'listingId': 'sokna_016',
        'tenantEmail': 'meriem.jaziri@sokna.tn',
        'userName': 'Meriem Jaziri',
        'userAvatarUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
        'rating': 4.8,
        'comment':
            'Balcon filant très agréable pour le café du matin. Nourhene est d\'une grande gentillesse.',
        'createdAt': DateTime(2026, 11, 13),
      },
    ];
  }
}
