# StitchPal

StitchPal is a Flutter application that helps crochet enthusiasts create, manage, and track their crochet projects. The app leverages OpenAI's API to generate custom crochet patterns and yarn suggestions based on user input.

## Features

- **Custom Pattern Generation**: Create unique crochet patterns based on your descriptions using OpenAI's GPT-4 model
- **Yarn Suggestions**: Get personalized yarn recommendations for your projects that are saved with your patterns
- **Project Management**: Save, track, and organize your crochet projects
- **Progress Tracking**: Monitor your progress on each project
- **Crochet Tools**: Access helpful tools including:
  - **Stitch Counter**: Keep track of your stitches as you work
  - **Stitch Guide**: Reference common crochet stitches and techniques
  - **Gauge Calculator**: Calculate your gauge for perfect sizing
  - **Conversion Charts**: Convert between different hook sizes and yarn weights
  - **Project Timer**: Track time spent on projects with break reminders
- **Hand Health Features**:
  - **Break Reminders**: Receive notifications every 30 minutes to take breaks
  - **Hand Stretch Guide**: Follow guided stretches to prevent hand fatigue

## Screenshots

- Project Input Screen: Enter your crochet project description and select tags
- Pattern Result Screen: View the generated pattern with instructions and materials
- Saved Projects Screen: Manage your saved crochet projects

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **OpenAI API**: For pattern generation (GPT-4) and yarn suggestions
- **Material Design 3**: Modern UI components and theming

## Setup

### Prerequisites

- Flutter SDK (latest version)
- OpenAI API key

### Installation

1. Clone the repository
2. Create a `.env` file in the project root with your OpenAI API key:
   ```
   OPENAI_API_KEY=your_api_key_here
   ```
3. Run `flutter pub get` to install dependencies
4. Run the app with `flutter run`

## Environment Variables

The app uses the following environment variables:

- `OPENAI_API_KEY`: Your OpenAI API key for accessing GPT-4 and DALL-E

For security, the `.env` file is included in `.gitignore` to prevent exposing sensitive information.

## Project Structure

- `lib/models/`: Data models for patterns, materials, and saved projects
- `lib/screens/`: UI screens for different app sections
- `lib/services/`: Service classes for API interactions
- `lib/widgets/`: Reusable UI components
- `lib/theme.dart`: App-wide theming and styling

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
