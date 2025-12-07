# Ape Archive - Design System & Style Guide

**Version:** 1.0  
**Platform:** Flutter Mobile (iOS & Android)  
**Design Language:** Material 3 with custom brand colors  
**Accessibility:** WCAG 2.1 AA compliant

---

## Brand Identity

### Logo & Assets
- **Primary Logo:** Orange "APE" text with archive icon
- **App Icon:** Square variant optimized for iOS/Android
- **Splash Screen:** Logo with gradient background

### Brand Voice
- **Tone:** Friendly, supportive, educational
- **Target Audience:** Sri Lankan students (ages 13-25), teachers, contributors
- **Languages:** Sinhala, Tamil, English (primary: Sinhala)

---

## Color System

### Light Theme

```dart
// Primary (Orange/Coral)
const Color primaryColor = Color(0xFFFF5733); // hsl(3.2, 100%, 59.4%)
const Color primaryLight = Color(0xFFFF8A66);
const Color primaryDark = Color(0xFFCC4629);
const Color onPrimary = Color(0xFFFFFFFF);

// Background & Surface
const Color backgroundColor = Color(0xFFFFFFFF); // Pure white
const Color surfaceColor = Color(0xFFFFFFFF);
const Color cardColor = Color(0xFFFFFFFF);

// Foreground (Text)
const Color foregroundColor = Color(0xFF1A1614); // hsl(20, 14%, 10%)
const Color onSurface = Color(0xFF1A1614);
const Color onBackground = Color(0xFF1A1614);

// Secondary
const Color secondaryColor = Color(0xFFF6F1EE); // hsl(30, 20%, 96%)
const Color onSecondary = Color(0xFF1A1614);

// Muted (Low emphasis text/icons)
const Color mutedColor = Color(0xFFEDE6E0); // hsl(30, 15%, 92%)
const Color mutedForeground = Color(0xFF857566); // hsl(20, 10%, 40%)

// Accent (Same as primary for consistency)
const Color accentColor = Color(0xFFFF5733);
const Color onAccent = Color(0xFFFFFFFF);

// Semantic Colors
const Color successColor = Color(0xFF10B981); // Green
const Color warningColor = Color(0xFFF59E0B); // Amber
const Color errorColor = Color(0xFFEF4444); // Red hsl(0, 84.2%, 60.2%)
const Color infoColor = Color(0xFF3B82F6); // Blue

// Borders & Dividers
const Color borderColor = Color(0xFFE6D8CE); // hsl(30, 25%, 85%)
const Color dividerColor = Color(0xFFE6D8CE);

// Input Fields
const Color inputFillColor = Color(0xFFFAF5F0);
const Color inputBorderColor = Color(0xFFE6D8CE);
const Color inputFocusBorderColor = Color(0xFFFF5733);
```

### Dark Theme

```dart
// Primary (Orange - slightly desaturated for dark mode)
const Color darkPrimaryColor = Color(0xFFFF6B47);
const Color darkPrimaryLight = Color(0xFFFF9880);
const Color darkPrimaryDark = Color(0xFFE65431);
const Color darkOnPrimary = Color(0xFF1A1614);

// Background & Surface
const Color darkBackgroundColor = Color(0xFF0D0B0A); // hsl(20, 14%, 4%)
const Color darkSurfaceColor = Color(0xFF1A1614); // Slightly lighter
const Color darkCardColor = Color(0xFF1A1614);

// Foreground (Text)
const Color darkForegroundColor = Color(0xFFFAF5F0); // hsl(30, 50%, 96%)
const Color darkOnSurface = Color(0xFFFAF5F0);
const Color darkOnBackground = Color(0xFFFAF5F0);

// Secondary
const Color darkSecondaryColor = Color(0xFF2D2724); // hsl(20, 10%, 15%)
const Color darkOnSecondary = Color(0xFFFAF5F0);

// Muted
const Color darkMutedColor = Color(0xFF3D3531); // hsl(20, 8%, 21%)
const Color darkMutedForeground = Color(0xFFA39486); // hsl(30, 12%, 58%)

// Semantic Colors (adjusted for dark bg)
const Color darkSuccessColor = Color(0xFF34D399);
const Color darkWarningColor = Color(0xFFFBBF24);
const Color darkErrorColor = Color(0xFFF87171);
const Color darkInfoColor = Color(0xFF60A5FA);

// Borders & Dividers
const Color darkBorderColor = Color(0xFF3D3531);
const Color darkDividerColor = Color(0xFF3D3531);

// Input Fields
const Color darkInputFillColor = Color(0xFF1A1614);
const Color darkInputBorderColor = Color(0xFF3D3531);
const Color darkInputFocusBorderColor = Color(0xFFFF6B47);
```

### High Contrast Mode
- Increase contrast ratios to 7:1 minimum
- Use pure black (#000000) and white (#FFFFFF) for text
- Thicker borders (2px minimum)

---

## Typography

### Font Family
**Source Sans Pro** (Google Fonts)
- Weights: 400 (Regular), 600 (SemiBold), 700 (Bold)
- Fallback: System default (SF Pro on iOS, Roboto on Android)

### Text Styles (Material 3)

```dart
// Display (Large titles)
displayLarge: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 57,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.25,
),
displayMedium: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 45,
  fontWeight: FontWeight.w400,
),
displaySmall: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 36,
  fontWeight: FontWeight.w400,
),

// Headline (Section titles)
headlineLarge: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 32,
  fontWeight: FontWeight.w700, // Bold for headlines
),
headlineMedium: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 28,
  fontWeight: FontWeight.w700,
),
headlineSmall: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 24,
  fontWeight: FontWeight.w600,
),

// Title (Card titles, dialog headers)
titleLarge: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 22,
  fontWeight: FontWeight.w600,
),
titleMedium: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.15,
),
titleSmall: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
),

// Body (Paragraphs, descriptions)
bodyLarge: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.5,
),
bodyMedium: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
),
bodySmall: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.4,
),

// Label (Buttons, chips, badges)
labelLarge: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
),
labelMedium: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
),
labelSmall: TextStyle(
  fontFamily: 'Source Sans Pro',
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
),
```

### Accessibility Text Scaling
- Support Dynamic Type (iOS) / Font Scale (Android)
- Min scale: 0.8x, Max scale: 2.0x
- Ensure buttons remain tappable at max scale (min 44x44pt)

---

## Spacing & Layout

### Spacing Scale (Tailwind-inspired)
```dart
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
```

### Layout Grid
- **Columns:** 4 (mobile), 8 (tablet), 12 (large screens)
- **Gutter:** 16px (mobile), 24px (tablet+)
- **Margins:** 16px (mobile), 24px (tablet), 32px (desktop)

### Safe Areas & Notches
- Respect platform safe areas (top notch, bottom home indicator)
- Use `SafeArea` widget on all screens
- Bottom navigation bar: 56px + safe area inset

---

## Border Radius

```dart
class BorderRadii {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 9999.0; // Fully rounded
}
```

### Component-Specific Radii
- **Cards:** 12px
- **Buttons:** 12px
- **Input Fields:** 8px
- **Chips/Badges:** 9999px (pill shape)
- **Bottom Sheets:** 16px (top corners only)
- **Dialogs:** 16px

---

## Shadows & Elevation

### Elevation Levels (Material 3)
```dart
// Level 0: No shadow (flat)
elevation0: BoxShadow(
  color: Colors.transparent,
  offset: Offset(0, 0),
  blurRadius: 0,
)

// Level 1: Subtle lift (cards, chips)
elevation1: BoxShadow(
  color: Color(0x0A000000), // 4% opacity
  offset: Offset(0, 1),
  blurRadius: 2,
)

// Level 2: Floating (FAB, app bar)
elevation2: BoxShadow(
  color: Color(0x14000000), // 8% opacity
  offset: Offset(0, 2),
  blurRadius: 4,
)

// Level 3: Modal (dialogs, bottom sheets)
elevation3: BoxShadow(
  color: Color(0x1F000000), // 12% opacity
  offset: Offset(0, 4),
  blurRadius: 8,
)

// Level 4: High emphasis (nav drawer)
elevation4: BoxShadow(
  color: Color(0x29000000), // 16% opacity
  offset: Offset(0, 6),
  blurRadius: 12,
)
```

### Dark Mode Shadows
- Use tinted shadows (primary color at 20% opacity)
- Reduce shadow intensity by 50%
- Add subtle border for definition

---

## Iconography

### Icon Set
- **Primary:** Material Icons (built-in)
- **Custom:** Lucide Icons (via `lucide_icons` package)
- **Size Scale:**
  - Small: 16px (inline text icons)
  - Medium: 24px (default buttons, list items)
  - Large: 32px (FAB, prominent actions)
  - XLarge: 48px (empty states, illustrations)

### Subject Icons (Color-coded)
```dart
const subjectIcons = {
  'Economics': {icon: Icons.trending_up, color: Color(0xFFF59E0B)},
  'Physics': {icon: Icons.science, color: Color(0xFF3B82F6)},
  'Chemistry': {icon: Icons.biotech, color: Color(0xFF10B981)},
  'Biology': {icon: Icons.spa, color: Color(0xFF059669)},
  'Mathematics': {icon: Icons.calculate, color: Color(0xFF8B5CF6)},
  'ICT': {icon: Icons.computer, color: Color(0xFFF97316)},
  // ... add more subjects
};
```

---

## Components

### Buttons

#### Primary Button (Filled)
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: onPrimary,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0, // Flat in M3
  ),
  onPressed: () {},
  child: Text('Primary Action'),
)
```

#### Secondary Button (Outlined)
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    side: BorderSide(color: borderColor, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {},
  child: Text('Secondary Action'),
)
```

#### Tertiary Button (Text)
```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
  onPressed: () {},
  child: Text('Tertiary Action'),
)
```

### Cards

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: borderColor, width: 1),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card Title', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        Text('Card content goes here...'),
      ],
    ),
  ),
)
```

### Input Fields

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Placeholder text',
    filled: true,
    fillColor: inputFillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: inputBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: inputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: inputFocusBorderColor, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
)
```

### Chips/Badges

```dart
Chip(
  label: Text('Tag Name'),
  backgroundColor: secondaryColor,
  labelStyle: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(9999),
    side: BorderSide(color: borderColor),
  ),
)
```

### Bottom Navigation

```dart
NavigationBar(
  height: 64,
  destinations: [
    NavigationDestination(icon: Icon(Icons.home), label: 'Library'),
    NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
    NavigationDestination(icon: Icon(Icons.upload), label: 'Upload'),
    NavigationDestination(icon: Icon(Icons.forum), label: 'Forum'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  ],
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
)
```

---

## Animation & Motion

### Duration Scale
```dart
class Durations {
  static const int instant = 50;
  static const int fast = 150;
  static const int normal = 250;
  static const int slow = 400;
  static const int slower = 600;
}
```

### Curves
- **Standard:** `Curves.easeInOut` (default)
- **Emphasized:** `Curves.easeOutCubic` (enter animations)
- **Decelerated:** `Curves.fastOutSlowIn` (exit animations)
- **Spring:** `Curves.elasticOut` (playful interactions)

### Transitions
- **Page Transitions:** Fade + Slide (200ms)
- **Modal Sheets:** Slide up from bottom (300ms)
- **Dialogs:** Scale + Fade (200ms)
- **List Items:** Staggered fade-in (50ms delay per item)

---

## Empty States & Illustrations

### Empty State Pattern
```dart
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.folder_open, size: 64, color: mutedForeground),
      SizedBox(height: 16),
      Text('No resources yet', style: titleMedium),
      SizedBox(height: 8),
      Text('Upload your first resource to get started', style: bodySmall),
      SizedBox(height: 24),
      ElevatedButton.icon(
        icon: Icon(Icons.upload),
        label: Text('Upload Resource'),
        onPressed: () {},
      ),
    ],
  ),
)
```

---

## Accessibility

### Semantic Labels
- All icons must have `Semantics` labels
- Interactive elements: min 44x44pt tap target
- Focus indicators: 2px border with primary color

### Screen Reader Support
- Use `Semantics` widget for custom components
- Announce dynamic content changes with `announceInSemanticsTree`
- Provide text alternatives for images

### Keyboard Navigation (Tablets/External Keyboards)
- Support Tab key navigation
- Highlight focused elements
- Support Enter/Space for activation

---

## Platform-Specific Considerations

### iOS
- Use `CupertinoNavigationBar` for iOS-style navigation
- Respect iOS swipe-back gesture
- Use `CupertinoAlertDialog` for native dialogs

### Android
- Material Design 3 by default
- Support Material You dynamic colors (Android 12+)
- Use Android-style back button handling

---

## References

- Material 3 Guidelines: https://m3.material.io/
- Flutter Theming: https://docs.flutter.dev/cookbook/design/themes
- WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
- Web Design Tokens: `ape-archive-web/src/app/globals.css`
