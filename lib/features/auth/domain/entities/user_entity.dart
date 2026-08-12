import 'package:equatable/equatable.dart';

/// Every role called out in the spec. Each maps to its own dashboard
/// and permission set once the dashboard module is built.
enum UserRole {
  superAdmin,
  companyOwner,
  projectManager,
  siteEngineer,
  supervisor,
  storeKeeper,
  accountant,
  contractor,
  labor,
  client;

  String get label {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.companyOwner:
        return 'Company Owner';
      case UserRole.projectManager:
        return 'Project Manager';
      case UserRole.siteEngineer:
        return 'Site Engineer';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.storeKeeper:
        return 'Store Keeper';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.contractor:
        return 'Contractor';
      case UserRole.labor:
        return 'Labor';
      case UserRole.client:
        return 'Client';
    }
  }
}

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.companyId,
    this.emailVerified = false,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? companyId;
  final bool emailVerified;
  final String? photoUrl;

  /// True until Company Setup has been completed — drives the
  /// post-login redirect in the router.
  bool get needsCompanySetup => companyId == null;

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    String? companyId,
    bool? emailVerified,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      emailVerified: emailVerified ?? this.emailVerified,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, role, companyId, emailVerified, photoUrl];
}
