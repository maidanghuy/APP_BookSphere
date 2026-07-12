import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:booksphere_app/features/profile/presentation/settings_screen.dart';
import 'package:booksphere_app/features/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// BS-APP-24 – Profile Screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(profileProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: profileAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => AppErrorView(
          message: l10n.unknownError,
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Avatar + name ──────────────────────────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      _initials(profile.fullName ?? profile.username),
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (profile.fullName != null && profile.fullName!.isNotEmpty)
                    Text(
                      profile.fullName!,
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 4),
                  if (profile.username != null && profile.username!.isNotEmpty)
                    Text(
                      '@${profile.username}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (profile.isActive != null)
                    _StatusBadge(isActive: profile.isActive!),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Info card ──────────────────────────────────
            Card(
              child: Column(
                children: [
                  if (profile.username != null && profile.username!.isNotEmpty)
                    _InfoTile(
                      label: l10n.profileUsername,
                      value: profile.username!,
                    ),
                  if (profile.fullName != null && profile.fullName!.isNotEmpty)
                    _InfoTile(
                      label: l10n.profileFullName,
                      value: profile.fullName!,
                    ),
                  if (profile.email != null && profile.email!.isNotEmpty)
                    _InfoTile(
                      label: l10n.profileEmail,
                      value: profile.email!,
                    ),
                  if (profile.phone != null && profile.phone!.isNotEmpty)
                    _InfoTile(
                      label: l10n.profilePhone,
                      value: profile.phone!,
                    ),
                  if (profile.role != null && profile.role!.isNotEmpty)
                    _InfoTile(
                      label: l10n.profileRole,
                      value: _roleLabel(profile.role!, l10n),
                      isLast: true,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Settings ───────────────────────────────────
            Card(
              child: ListTile(
                title: Text(l10n.profileSettings),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Logout ─────────────────────────────────────
            const LogoutButton(),
          ],
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _roleLabel(String role, dynamic l10n) {
    return switch (role.toUpperCase()) {
      'MEMBER' => l10n.profileMemberRole as String,
      'ADMIN' => l10n.profileAdminRole as String,
      'LIBRARIAN' => l10n.profileLibrarianRole as String,
      _ => role,
    };
  }
}

// ── Status badge ──────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final color = isActive ? Colors.green.shade600 : colorScheme.error;
    final label =
        isActive ? l10n.profileActive : l10n.profileInactive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

// ── Info tile ─────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
