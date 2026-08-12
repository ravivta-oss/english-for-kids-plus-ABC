import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';

class ParentDashboardScreen extends StatefulWidget {
  final List<LearnerProfile> profiles;
  const ParentDashboardScreen({super.key, required this.profiles});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  Future<void> _reset(LearnerProfile profile) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('לאפס את ${profile.name}?'),
        content: const Text('כל ההתקדמות ומדדי השליטה של הפרופיל יימחקו מהמכשיר.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ביטול')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('איפוס')),
        ],
      ),
    );
    if (yes == true) {
      await ProgressStore.instance.resetProfile(profile.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('מצב הורה')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'בדיקת ארבעת הפרופילים',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('כל פרופיל שומר התקדמות ומדדי Mastery בנפרד.'),
            const SizedBox(height: 16),
            ...widget.profiles.map((p) {
              final done = ProgressStore.instance.completedLessons(p.id).length;
              final percent = (done / AppData.lessons.length * 100).round();
              return Card(
                child: ListTile(
                  leading: Text(p.emoji, style: const TextStyle(fontSize: 34)),
                  title: Text(p.name),
                  subtitle: Text('$done / ${AppData.lessons.length} שיעורים • $percent%'),
                  trailing: IconButton(
                    tooltip: 'איפוס פרופיל',
                    onPressed: () => _reset(p),
                    icon: const Icon(Icons.restart_alt),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
