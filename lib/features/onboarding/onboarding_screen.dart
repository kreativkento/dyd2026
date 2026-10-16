import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/delegate_service.dart';
import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/delegate_models.dart';
import '../../widgets/app_title_banner.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.returnTo = '/event',
  });

  /// Route to open after Continue or Skip (e.g. `/event` or `/digital-id`).
  final String returnTo;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _idController = TextEditingController();

  bool _submitting = false;
  String? _idError;

  @override
  void dispose() {
    _nicknameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _skip() {
    context.go(widget.returnTo);
  }

  Future<void> _submit() async {
    setState(() => _idError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final delegate = await DelegateService.instance.findById(_idController.text);
      if (delegate == null) {
        setState(() {
          _idError = 'ID code not found. Please check and try again.';
          _submitting = false;
        });
        return;
      }

      final profile = UserProfile.fromDelegate(
        nickname: _nicknameController.text.trim(),
        delegate: delegate,
      );
      await UserProfileService.instance.saveProfile(profile);

      if (mounted) context.go(widget.returnTo);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppTitleBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Welcome to DYD 2026',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your nickname and delegate ID to get started. '
                  'Your ID must match our official participant list.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nicknameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nickname',
                          hintText: 'How should we call you?',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a nickname';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: 'ID Number',
                          hintText: 'e.g. ABC123',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.pin_outlined),
                          errorText: _idError,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your ID number';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          if (_idError != null) {
                            setState(() => _idError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _submitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Continue'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _submitting ? null : _skip,
                        child: const Text('Skip for now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
