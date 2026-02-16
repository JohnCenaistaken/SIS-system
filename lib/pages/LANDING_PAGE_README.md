# Student Information System (SIS) Landing Page

## Overview
A modern, interactive Flutter landing page for the Student Information System with Material Design 3, animations, and comprehensive features.

## Features Implemented

### ✅ Core Components
- **Hero Header**: Gradient background with app logo, tagline, and action buttons
- **Quick Stats Preview**: Displays GPA, upcoming classes, and pending assignments with shimmer loading
- **Feature Cards**: Interactive cards for Grade Tracking, Course Registration, Attendance Monitoring, and Academic Calendar
- **Announcements Section**: Expandable announcement tiles with priority indicators
- **Quick Actions Bar**: Bottom navigation with Dashboard, Courses, Grades, Profile, and Settings
- **Responsive Design**: Adapts to mobile, tablet, and desktop screen sizes

### ✅ Interactive Elements
- Tap animations on feature cards with scale effects
- Expandable announcements with smooth transitions
- Pull-to-refresh for announcements
- Staggered animations for feature cards on load
- Hero animations for page transitions
- Ripple effects on interactive elements

### ✅ State Management
- Provider-based state management
- Loading states with shimmer effects
- Error handling with retry functionality
- Mock data service for demonstration

## File Structure

```
lib/
├── Components/
│   ├── feature_card.dart          # Reusable feature card widget
│   ├── announcement_tile.dart    # Expandable announcement widget
│   └── quick_stats.dart           # Quick stats widget with shimmer
├── constants/
│   ├── app_colors.dart            # Color constants and theme
│   └── app_theme.dart             # Material Design 3 theme
├── models/
│   ├── announcement_model.dart    # Announcement data model
│   ├── feature_model.dart         # Feature data model
│   └── quick_stats_model.dart     # Quick stats data model
├── pages/
│   └── landing_page.dart          # Main landing page
├── providers/
│   └── landing_page_provider.dart # State management provider
├── services/
│   └── mock_data_service.dart    # Mock data service
└── utilities/
    └── responsive_layout.dart     # Responsive layout utilities
```

## Usage

### Running the Landing Page

The landing page is set as the initial route in `main.dart`. To access it:

```dart
Navigator.pushNamed(context, '/landing');
```

Or simply run the app - it's configured as the initial route.

### Customization

#### Colors
Edit `lib/constants/app_colors.dart` to customize the color scheme:
- Primary Blue: `#1A56DB`
- Accent Color: `#FF6B35`
- Customize gradients and status colors as needed

#### Theme
Edit `lib/constants/app_theme.dart` to customize:
- Light and dark themes
- Typography (Roboto for body, Poppins for headings)
- Material Design 3 components

#### Mock Data
Edit `lib/services/mock_data_service.dart` to:
- Add/remove features
- Modify announcements
- Update quick stats data

## Dependencies

All required dependencies are in `pubspec.yaml`:
- `provider`: State management
- `shimmer`: Loading animations
- `google_fonts`: Custom typography
- `intl`: Date formatting

## Design Specifications

- **Color Scheme**: University Blue (#1A56DB) primary, with accent colors
- **Typography**: Roboto (body), Poppins (headings)
- **Spacing**: 8px grid system
- **Material Design**: Material Design 3 components
- **Dark Mode**: Full support with adaptive theming

## Accessibility

- Semantic labels for screen readers
- Proper contrast ratios
- Keyboard navigation support
- Internationalization-ready structure

## Performance Optimizations

- Const constructors where possible
- Minimal rebuilds with Provider
- Efficient list rendering with Sliver widgets
- Optimized animations

## Next Steps

1. Connect to real API endpoints (replace `MockDataService`)
2. Implement authentication flow
3. Add user profile preview when logged in
4. Connect quick actions to actual pages
5. Add internationalization (i18n) support
