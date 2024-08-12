enum OnRatingEmotion { desperate, sad, neutral, happy, excited }

extension OnRatingEmotionExtension on OnRatingEmotion {
  String get name {
    switch (this) {
      case OnRatingEmotion.desperate:
        return 'Desperate';
      case OnRatingEmotion.sad:
        return 'Sad';
      case OnRatingEmotion.neutral:
        return 'Neutral';
      case OnRatingEmotion.happy:
        return 'Happy';
      case OnRatingEmotion.excited:
        return 'Excited';
    }
  }

  String get id {
    switch (this) {
      case OnRatingEmotion.desperate:
        return '1';
      case OnRatingEmotion.sad:
        return '2';
      case OnRatingEmotion.neutral:
        return '3';
      case OnRatingEmotion.happy:
        return '4';
      case OnRatingEmotion.excited:
        return '5';
    }
  }

  Object get message {
    switch (this) {
      case OnRatingEmotion.desperate:
        return {
          'title': 'I am sorry to hear that',
          'content':
              'You have done well today. Tomorrow will be better. Keep fighting!'
        };

      case OnRatingEmotion.sad:
        return {
          'title': 'I am sorry to hear that',
          'content':
              'You have done well today. Tomorrow will be better. Keep fighting!'
        };

      case OnRatingEmotion.neutral:
        return {
          'title': 'Not so bad',
          'content':
              'You have done well today. Tomorrow will be better. Keep fighting!'
        };

      case OnRatingEmotion.happy:
        return {
          'title': 'Thing seems to be going well',
          'content':
              'You have done well today. Tomorrow will be better. Keep fighting!'
        };

      case OnRatingEmotion.excited:
        return {
          'title': 'Great to hear that',
          'content':
              'You have done well today. Tomorrow will be better. Keep fighting!'
        };
    }
  }

  String get icon {
    switch (this) {
      case OnRatingEmotion.desperate:
        return '😭';
      case OnRatingEmotion.sad:
        return '😞';
      case OnRatingEmotion.neutral:
        return '😐';
      case OnRatingEmotion.happy:
        return '😊';
      case OnRatingEmotion.excited:
        return '😁';
    }
  }
}
