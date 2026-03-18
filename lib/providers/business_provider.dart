import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_model.dart';
import '../services/business_service.dart';
import 'auth_provider.dart';

final businessServiceProvider = Provider((ref) {
  return BusinessService();
});

final currentBusinessProvider = FutureProvider<BusinessModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return null;
  }

  return ref.read(businessServiceProvider).getBusinessByOwnerId(user.uid);
});

final businessSlugAvailableProvider =
    FutureProvider.family<bool, String>((ref, slug) async {
  return ref.read(businessServiceProvider).isSlugAvailable(slug);
});
