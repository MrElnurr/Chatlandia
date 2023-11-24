import 'dart:math';

class RandomEmojiGenerator {
  final List<String> emojis = [
    '😀',
    '😍',
    '🥳',
    '🐱',
    '🌈',
    '🎉',
    '🍕',
    '🚀',
    '🌻',
    '🎸'
  ];

  String getRandomEmoji() {
    final randomIndex = Random().nextInt(emojis.length - 1);
    return emojis[randomIndex];
  }
}
