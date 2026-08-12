import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';
import 'story_screen.dart';

/// "Reading Corner" — lists mini-stories the child can read. A story for
/// world N is available once world N itself is unlocked (same rule as
/// the main world map), so this never lets a child read ahead of content
/// they haven't reached yet. Completing a story's comprehension
/// question(s) is required to unlock the NEXT world (see
/// WorldMapScreen._worldUnlocked).
class StoryListScreen extends StatefulWidget {
  final LearnerProfile profile;
  const StoryListScreen({super.key, required this.profile});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  bool _worldUnlocked(int world) {
    if (world <= 1) return true;
    final previousWorldLessons =
        AppData.lessons.where((l) => l.world == world - 1);
    final completed = ProgressStore.instance.completedLessons(widget.profile.id);
    return previousWorldLessons.every((l) => completed.contains(l.id));
  }

  @override
  Widget build(BuildContext context) {
    final available = AppData.stories.where((s) => _worldUnlocked(s.world)).toList();
    final completedStories = ProgressStore.instance.completedStories(widget.profile.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('פינת קריאה 📖')),
        body: SafeArea(
          child: available.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'עוד מעט! השלימו את עולם 1 כדי לפתוח\nאת הסיפור הראשון.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Card(
                        color: Colors.amber.shade50,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            '📌 קריאת הסיפור וענייה נכונה על השאלה נדרשות כדי לפתוח את העולם הבא.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: available.length,
                        itemBuilder: (context, i) {
                          final story = available[i];
                          final world = AppData.worlds.firstWhere((w) => w.id == story.world);
                          final done = completedStories.contains(story.world);
                          return Card(
                            child: ListTile(
                              leading: Text(world.emoji, style: const TextStyle(fontSize: 28)),
                              title: Text(story.title, style: const TextStyle(fontSize: 18)),
                              subtitle: Text('עולם ${story.world}: ${world.title}'),
                              trailing: done
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : const Icon(Icons.chevron_left),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoryScreen(
                                      profile: widget.profile,
                                      story: story,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
