# Reusable UI Components

This directory contains reusable widget components used throughout the Floor Bot Mobile app.

## Buttons

### CustomPrimaryButton

A primary button widget with the app's main styling (dark background, white text).

**Features:**

- Loading state support
- Optional icons (leading or trailing)
- Customizable width and height
- Follows app theme automatically

**Usage:**

```dart
CustomPrimaryButton(
  text: 'Sign in',
  onPressed: () {
    // Handle action
  },
  isLoading: false, // optional
  icon: Icons.arrow_forward, // optional
)
```

### CustomOutlinedButton

An outlined button widget with border styling.

**Features:**

- Loading state support
- Optional leading icon (great for Google, Facebook buttons)
- Customizable border and text colors
- Rounded corners

**Usage:**

```dart
CustomOutlinedButton(
  text: 'Continue with Google',
  onPressed: () {
    // Handle action
  },
  leadingIcon: SvgPicture.asset('assets/svgs/google_icon.svg'),
  borderColor: Colors.grey[300],
  textColor: Colors.black,
)
```

### CustomTextButton

A simple text button for secondary actions.

**Features:**

- Customizable text color, size, and weight
- Optional icons
- Minimal styling

**Usage:**

```dart
CustomTextButton(
  text: '+ Create an account',
  onPressed: () {
    // Handle action
  },
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
)
```

## Common Widgets

### OrDivider

A horizontal divider with text in the center (commonly used for "Or" between login options).

**Features:**

- Customizable text
- Customizable line and text colors
- Adjustable thickness

**Usage:**

```dart
const OrDivider() // Uses default "Or" text

OrDivider(
  text: 'OR',
  lineColor: Colors.grey,
  textColor: Colors.black54,
)
```

## Theme Integration

All components automatically use the app's theme colors and text styles defined in:

- `app_themes.dart` - For colors and widget themes
- `app_texts.dart` - For text styles

This ensures consistent styling across the entire app without manual configuration.
