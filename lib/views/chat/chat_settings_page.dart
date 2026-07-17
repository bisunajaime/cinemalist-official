import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/repository/chat/chat_repository.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  final _settings = ChatSettingsRepository();
  final _keyController = TextEditingController();
  String _selectedModel = 'deepseek/deepseek-chat';
  bool _obscureKey = true;
  bool _loaded = false;

  static const _models = [
    ('qwen/qwen3.6-flash', 'Qwen 3.6 Flash'),
    ('deepseek/deepseek-v4-flash', 'DeepSeek V4 Flash'),
    ('qwen/qwen3.6-plus', 'Qwen 3.6 Plus'),
    ('qwen/qwen3.7-max', 'Qwen 3.7 Max'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final key = await _settings.getApiKey();
    final model = await _settings.getModel();
    setState(() {
      _keyController.text = key ?? '';
      _selectedModel = model;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    await _settings.setApiKey(_keyController.text.trim());
    await _settings.setModel(_selectedModel);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat Settings', style: Styles.mBold.copyWith(fontSize: 18)),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('API KEY', style: Styles.heading.copyWith(fontSize: 20, color: AppColors.primaryLight))
                    .animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 8),
                Text(
                  'Get your API key from openrouter.ai',
                  style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _keyController,
                  obscureText: _obscureKey,
                  style: Styles.mReg.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'sk-or-...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureKey ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
                const SizedBox(height: 28),
                Text('MODEL', style: Styles.heading.copyWith(fontSize: 20, color: AppColors.primaryLight))
                    .animate(delay: 150.ms).fadeIn(duration: 300.ms),
                const SizedBox(height: 12),
                ...List.generate(_models.length, (i) {
                  final model = _models[i];
                  final selected = _selectedModel == model.$1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedModel = model.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppColors.primary.withValues(alpha: 0.4) : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: selected ? AppColors.primaryLight : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(model.$2, style: Styles.mBold.copyWith(fontSize: 14)),
                                Text(model.$1, style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: (200 + 40 * i).ms).fadeIn(duration: 250.ms);
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save Settings', style: Styles.mBold.copyWith(fontSize: 15)),
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 300.ms),
              ],
            ),
    );
  }
}
