import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/pin_gate.dart';
import 'world_map_screen.dart';
import 'parent_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  final List<LearnerProfile> profiles;
  final Future<void> Function(String) onSpeakHebrew;

  const ProfileScreen({
    super.key,
    required this.profiles,
    required this.onSpeakHebrew,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('English Adventure'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'מצב הורה',
              onPressed: () async {
                final ok = await PinGate.verify(context);
                if (!ok || !context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParentDashboardScreen(profiles: profiles),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'מי לומד עכשיו?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => onSpeakHebrew('מי לומד עכשיו? בחרו פרופיל.'),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('השמע הוראה'),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.05,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: profiles.map((profile) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorldMapScreen(profile: profile),
                          ),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(profile.emoji, style: const TextStyle(fontSize: 58)),
                              const SizedBox(height: 10),
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
