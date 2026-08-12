import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';
import 'lesson_screen.dart';
import 'review_screen.dart';
import 'story_list_screen.dart';
import 'abc_screen.dart';

class WorldMapScreen extends StatefulWidget {
  final LearnerProfile profile;
  const WorldMapScreen({super.key, required this.profile});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  bool _worldUnlocked(int world) {
    if (world == 1) return true;
    final previous = AppData.lessons.where((l) => l.world == world - 1);
    final lessonsDone = previous.every(
      (l) => ProgressStore.instance.isLessonCompleted(widget.profile.id, l.id),
    );
    if (!lessonsDone) return false;

    // If the previous world has a mini-story, it must be completed too —
    // reading comprehension is a required step, not just a bonus.
    final hasStory = AppData.stories.any((s) => s.world == world - 1);
    if (!hasStory) return true;
    return ProgressStore.instance.isStoryCompleted(widget.profile.id, world - 1);
  }

  bool _worldStoryPending(int world) {
    final lessons = AppData.lessons.where((l) => l.world == world);
    final lessonsDone = lessons.every(
      (l) => ProgressStore.instance.isLessonCompleted(widget.profile.id, l.id),
    );
    if (!lessonsDone) return false;
    final hasStory = AppData.stories.any((s) => s.world == world);
    if (!hasStory) return false;
    return !ProgressStore.instance.isStoryCompleted(widget.profile.id, world);
  }

  @override
  Widget build(BuildContext context) {
    final completed = ProgressStore.instance.completedLessons(widget.profile.id);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.profile.emoji} ${widget.profile.name}'),
          actions: [
            IconButton(
              tooltip: 'אותיות ABC',
              icon: const Icon(Icons.abc),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AbcScreen()),
                );
              },
            ),
            IconButton(
              tooltip: 'פינת קריאה',
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoryListScreen(profile: widget.profile),
                  ),
                );
              },
            ),
            Builder(
              builder: (context) {
                final due = ProgressStore.instance.dueCount(widget.profile.id);
                return IconButton(
                  tooltip: 'תרגול יומי',
                  icon: Badge(
                    label: Text('$due'),
                    isLabelVisible: due > 0,
                    child: const Icon(Icons.refresh_rounded),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(profile: widget.profile),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: AppData.worlds.length,
          itemBuilder: (context, index) {
            final world = AppData.worlds[index];
            final lessons = AppData.lessons.where((l) => l.world == world.id).toList();
            final done = lessons.where((l) => completed.contains(l.id)).length;
            final unlocked = _worldUnlocked(world.id);
            final storyPending = _worldStoryPending(world.id);
            return Card(
              child: ExpansionTile(
                enabled: unlocked,
                leading: Text(world.emoji, style: const TextStyle(fontSize: 32)),
                title: Text(
                  'עולם ${world.id} — ${world.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  !unlocked
                      ? '🔒 נעול'
                      : storyPending
                          ? '${world.goal}  •  $done/7  •  📖 נותר לקרוא את הסיפור'
                          : '${world.goal}  •  $done/7',
                ),
                children: unlocked
                    ? lessons.map((lesson) {
                        final isDone = completed.contains(lesson.id);
                        final previousDone = lesson.indexInWorld == 1 ||
                            completed.contains(lesson.id - 1);
                        return ListTile(
                          enabled: previousDone,
                          leading: Icon(
                            isDone
                                ? Icons.check_circle
                                : lesson.boss
                                    ? Icons.emoji_events_outlined
                                    : lesson.checkpoint
                                        ? Icons.refresh
                                        : Icons.play_circle_outline,
                          ),
                          title: Text('שיעור ${lesson.id}: ${lesson.title}'),
                          trailing: previousDone
                              ? const Icon(Icons.chevron_left)
                              : const Icon(Icons.lock_outline),
                          onTap: previousDone
                              ? () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LessonScreen(
                                        profile: widget.profile,
                                        lesson: lesson,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                }
                              : null,
                        );
                      }).toList()
                    : const [],
              ),
            );
          },
        ),
      ),
    );
  }
}
