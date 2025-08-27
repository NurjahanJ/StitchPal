# StitchPal

StitchPal is a Flutter application that helps crochet enthusiasts create, manage, and track their crochet projects. The app leverages OpenAI's API to generate custom crochet patterns and yarn suggestions based on user input, along with AI-generated images of the patterns.

## Features

- **Custom Pattern Generation**: Create unique crochet patterns based on your descriptions using OpenAI's GPT-4 model
- **AI-Generated Pattern Images**: Visualize your patterns with AI-generated images
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
- Pattern Result Screen: View the generated pattern with instructions, materials, yarn suggestions, and AI-generated images
- Saved Projects Screen: Manage your saved crochet projects

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **OpenAI API**: For pattern generation (GPT-4), yarn suggestions, and image generation (DALL-E)
- **Material Design 3**: Modern UI components and theming

## Setup

### Prerequisites

- Flutter SDK (latest version)
- OpenAI API key

### Installation

1. Clone the repository
2. Create a `.env` file in the **project root directory** (not in the assets directory) with your OpenAI API key:
   ```
   OPENAI_API_KEY=your_api_key_here
   ```
3. Run `flutter pub get` to install dependencies
4. Run the app with `flutter run`

### Deployment to Vercel

This project is configured for easy deployment to Vercel:

1. Fork or push this repository to your GitHub account
2. Connect your GitHub repository to Vercel
3. Add the following environment variables in your Vercel project settings:
   - `OPENAI_API_KEY`: Your OpenAI API key
4. Deploy! Vercel will automatically use the `vercel.json` and `build.sh` files to build and deploy your Flutter web app

#### Manual Deployment

You can also deploy manually using the Vercel CLI:

1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in the project directory
3. Follow the prompts to link your project

## Environment Variables and Security

The app uses the following environment variables:

- `OPENAI_API_KEY`: Your OpenAI API key for accessing GPT-4 and DALL-E

⚠️ **IMPORTANT SECURITY NOTES**:
- The `.env` file is included in `.gitignore` to prevent exposing sensitive information
- **NEVER commit your API key to the repository**
- If you accidentally commit your API key, revoke it immediately from your OpenAI account
- Ensure the `.env` file is in the project root directory, not in subdirectories
- GitHub's secret scanning may block pushes containing API keys for your protection

## Current Development Status

The app is currently under active development (Last Updated: May 16, 2025) with the following items being worked on:
- Implementing the global assistant modal for enhanced user guidance
- Refining the stitch counter functionality
- Optimizing the main app structure and build configuration

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
