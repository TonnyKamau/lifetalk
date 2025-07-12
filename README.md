# LifeTalk - AI-Powered Social Communication Game

An AI-powered interactive game that helps users master social communication, build emotional intelligence, and grow confidence through immersive, real-life scenarios.

## 🚀 Project Overview

LifeTalk is a mobile-first game that simulates realistic social interactions powered by AI. The game helps users improve communication skills through feedback, coaching, and progress tracking — making self-growth fun, engaging, and repeatable.

## 🧩 Key Features Implemented

### 1. Interactive Scenario Engine
- **100+ Realistic Life Situations** across:
  - Romantic relationships
  - Friendships
  - Family dynamics
  - Workplace conflicts
  - Public speaking
  - Confidence building
- **Free-text responses** - Users respond naturally
- **AI characters respond in real-time** with personality adaptation
- **Character traits and learning objectives** for each scenario

### 2. AI Feedback System
After each message or conversation:
- **Scores user's communication** on:
  - Empathy
  - Clarity
  - Confidence
  - Listening
  - Assertiveness
  - Emotional Intelligence
  - Public Speaking
- **Provides coaching suggestions** with psychology-backed advice
- **Detailed skill analysis** with visual feedback

### 3. LifeTalk Mentor (AI Coach Mode)
- **Ask questions** like:
  - "What did I do wrong?"
  - "How can I improve?"
  - "Give me a better version of my response."
- **GPT-powered explanations** using psychology-backed advice
- **Personalized coaching** based on personality assessment

### 4. Personality Adaptation Engine
- **Onboarding quiz** with 5 key questions:
  - Social energy preferences
  - Conflict resolution style
  - Communication preferences
  - Stress response patterns
  - Feedback style
- **Adapts scenarios and characters** to challenge weakest areas
- **Offers specific growth path suggestions**
- **Personalized AI responses** based on personality type

### 5. User Progress Tracker
Tracks:
- **XP in each social skill category**
- **Daily activity streaks**
- **Scenario completion**
- **Career stage progression**
- **Achievement system**

Awards:
- **Badges** (e.g., "Golden Listener", "Smooth Talker")
- **Titles** (based on user choices and growth)
- **Progress bars per skill**
- **Virtual currency (coins)** for premium features

### 6. Daily Challenge Mode
- **One surprise situation per day** (5–10 mins)
- **Timed response option** (simulate pressure)
- **Double XP rewards**
- **Special daily challenge badge**

### 7. Career Mode (Life Path Storylines)
Structured life simulation:
- **High School** → University → Work → Relationship → Leadership
- **Each life stage** introduces new communication challenges
- **Progressive difficulty** and skill requirements
- **Character types** evolve with career progression

### 8. Practice Mode
Choose a focus:
- **Apologies**
- **Assertive speaking**
- **Handling rejection**
- **Confessing feelings**
- **Motivating others**
- **Public speaking**
- **Conflict resolution**

### 9. Enhanced Conversation Experience
- **Real-time feedback** on each message
- **Skill score visualization**
- **Coaching tips** for improvement
- **Suggested improvements** for responses
- **Character personality adaptation**
- **Scenario difficulty indicators**

### 10. Achievement System
- **Milestone achievements** (First Steps, Dedicated Learner)
- **Skill-based achievements** (Golden Listener, Smooth Talker)
- **Consistency rewards** (7-day streaks)
- **Progress achievements** (Life Journey)
- **Reward system** with coins, badges, and titles

## 🛠️ Technical Implementation

### Tech Stack
| Layer | Tools |
|-------|-------|
| Frontend | Flutter |
| Backend | Firebase (Auth, Firestore, Analytics) |
| AI | OpenAI GPT-4o API (Gemini) |
| State Mgmt | Provider |
| Storage | SQLite (offline saves) |
| UI/UX | Material Design 3, Custom animations |

### Core Models
- **Scenario**: Enhanced with personality adaptation, career stages, learning objectives
- **Conversation**: Real-time messaging with skill scoring
- **UserProgress**: Comprehensive tracking with personality traits, career progression
- **PersonalityResult**: Detailed personality assessment with growth areas
- **Achievement**: Gamification system with rewards

### AI Service Features
- **Personality-aware responses** based on user assessment
- **Advanced skill scoring** with 7 different communication skills
- **Real-time feedback generation** with coaching tips
- **Scenario adaptation** based on user's growth areas
- **Coach mode** for personalized advice

### Enhanced Game Provider
- **Scenario organization** by category and career stage
- **Daily challenge system** with rotation
- **Achievement tracking** and rewards
- **Personality result management**
- **Recommended scenarios** based on personality

## 🎮 User Journey

### 1. Onboarding
- **Welcome experience** with app introduction
- **Personality assessment** (5 questions, 2 minutes)
- **Goal setting** (Confidence, Dating, Family, etc.)
- **Tutorial** with AI guidance

### 2. Home Screen Options
- 🕹️ **Play Daily Challenge**
- 🎯 **Continue Career Mode**
- 🧪 **Open Practice Lab**
- 📊 **View Growth**
- ⚙️ **Customize preferences**

### 3. Playing a Scenario
- **Scenario intro** with character and context
- **AI starts conversation** with personality-adapted responses
- **User types natural responses**
- **Real-time feedback** after each message
- **Skill scores** displayed with visual indicators
- **Coaching suggestions** for improvement

### 4. Reflection & Growth
- **Replay scenarios** with different approaches
- **Ask mentor** for improvement advice
- **Earn XP** and unlock next scenarios
- **Track progress** across skill categories
- **Achieve badges** and titles

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Dart SDK (3.8.1+)
- Firebase project setup
- Gemini API key

### Installation
1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Set up Firebase configuration
4. Add your Gemini API key to `.env`
5. Run the app: `flutter run`

### Environment Variables
Create a `.env` file with:
```
GEMINI_KEY=your_gemini_api_key_here
```

## 🎯 Future Features (Planned)

### Phase 2: Advanced Features
- **Voice Mode**: Speak instead of typing
- **Community Scenarios**: User-created content
- **Shareable Story Reels**: Export interactions
- **Premium Coaching**: Deep-dive social growth plans

### Phase 3: Monetization
- **Premium packs** (dating, career, emotional healing)
- **AI mentor sessions**
- **Special characters** (celebrity styles, therapist roleplay)
- **Personalized coaching reports**

## 🤝 Contributing

This is a comprehensive social communication learning platform. Contributions are welcome for:
- New scenario creation
- UI/UX improvements
- AI prompt optimization
- Feature enhancements

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with Flutter and Firebase
- Powered by Google's Gemini AI
- Designed for social skill development
- Inspired by real communication challenges

---

**LifeTalk**: Making social growth engaging, measurable, and fun! 🚀
