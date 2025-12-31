# Auth Controller & Bottom Sheet Documentation

This documentation covers the GetX-based authentication system with a unified bottom sheet that switches between sign-in and sign-up modes.

## Architecture Overview

The authentication system uses:

- **GetX** for state management
- **Single AuthBottomSheet** that dynamically switches between modes
- **AuthController** to manage all authentication logic and form state
- **Reactive UI** that responds to controller state changes

## Components

### 1. AuthController (`lib/app/controllers/auth_controller.dart`)

A GetX controller that manages all authentication state and logic.

#### Features

- ✅ Mode switching (sign-in ↔ sign-up)
- ✅ Form controllers (full name, email, password)
- ✅ Form validation
- ✅ Loading states
- ✅ Password visibility toggle
- ✅ Sign in / Sign up / Google sign-in methods
- ✅ Automatic form clearing

#### Usage

```dart
// Get or create controller
final authController = Get.put(AuthController());

// Switch modes
authController.switchToSignIn();
authController.switchToSignUp();
authController.toggleAuthMode();

// Perform actions
await authController.signIn();
await authController.signUp();
await authController.signInWithGoogle();

// Access state
bool isSignIn = authController.authMode == AuthMode.signIn;
bool loading = authController.isLoading;
bool showPassword = !authController.obscurePassword;
```

#### Available Methods

| Method | Description |
|--------|-------------|
| `switchToSignIn()` | Switch to sign-in mode and clear form |
| `switchToSignUp()` | Switch to sign-up mode and clear form |
| `toggleAuthMode()` | Toggle between sign-in and sign-up |
| `togglePasswordVisibility()` | Show/hide password |
| `clearForm()` | Clear all form fields |
| `validateForm()` | Validate current form state |
| `signIn()` | Perform sign in with email/password |
| `signUp()` | Create new account |
| `signInWithGoogle()` | Sign in with Google |

#### Validators

| Method | Description |
|--------|-------------|
| `validateFullName(String?)` | Validates name (min 2 chars) |
| `validateEmail(String?)` | Validates email format |
| `validatePassword(String?)` | Validates password (min 6 chars) |

### 2. AuthBottomSheet (`lib/app/views/screens/auth/auth_bottom_sheet.dart`)

A unified bottom sheet that dynamically switches between sign-in and sign-up views.

#### Features

- ✅ Single component for both auth modes
- ✅ Automatic UI updates based on controller state
- ✅ Smooth transitions between modes
- ✅ Back button with form clearing
- ✅ Terms & Privacy Policy with clickable links
- ✅ Loading states on buttons
- ✅ Form validation

#### Usage

```dart
// Show sign-in mode
Get.bottomSheet(
  const AuthBottomSheet(
    initialMode: AuthMode.signIn,
  ),
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
);

// Show sign-up mode
Get.bottomSheet(
  const AuthBottomSheet(
    initialMode: AuthMode.signUp,
  ),
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
);
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `initialMode` | `AuthMode` | `AuthMode.signIn` | Initial mode to display |

### 3. AuthMode Enum

```dart
enum AuthMode {
  signIn,  // Display sign-in form
  signUp,  // Display sign-up form (includes full name field)
}
```

## How It Works

### Flow Diagram

```
WelcomeScreen
    │
    ├─ "Sign in" button clicked
    │     └─> Get.bottomSheet(AuthBottomSheet(initialMode: signIn))
    │           └─> AuthController sets mode to signIn
    │                 └─> Shows: Email + Password fields
    │
    ├─ "Create account" button clicked
    │     └─> Get.bottomSheet(AuthBottomSheet(initialMode: signUp))
    │           └─> AuthController sets mode to signUp
    │                 └─> Shows: Full Name + Email + Password fields
    │
    └─ "Continue with Google" button clicked
          └─> AuthController.signInWithGoogle()
```

### Mode Switching

When user clicks "Create an account" or "Sign in" link inside the bottom sheet:

```
User clicks toggle link
    └─> controller.toggleAuthMode()
          └─> Mode changes (signIn ↔ signUp)
                └─> Obx() rebuilds UI automatically
                      └─> Form updates (adds/removes full name field)
```

## Implementation Examples

### Example 1: Basic Usage

```dart
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/auth_bottom_sheet.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          const AuthBottomSheet(initialMode: AuthMode.signIn),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Text('Sign In'),
    );
  }
}
```

### Example 2: Custom Integration

```dart
// Get controller instance
final authController = Get.find<AuthController>();

// Listen to auth mode changes
Obx(() {
  if (authController.authMode == AuthMode.signIn) {
    print('User is on sign-in screen');
  } else {
    print('User is on sign-up screen');
  }
});

// Check loading state
Obx(() {
  if (authController.isLoading) {
    return CircularProgressIndicator();
  }
  return SizedBox.shrink();
});
```

### Example 3: Custom Auth Actions

```dart
class CustomAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    
    return Column(
      children: [
        // Email field
        TextField(
          controller: controller.emailController,
        ),
        
        // Password field
        TextField(
          controller: controller.passwordController,
          obscureText: controller.obscurePassword,
        ),
        
        // Sign in button
        ElevatedButton(
          onPressed: controller.signIn,
          child: Text('Sign In'),
        ),
      ],
    );
  }
}
```

## State Management

The controller uses GetX observables (`Rx`) for reactive state:

```dart
// Observable values
final Rx<AuthMode> _authMode = AuthMode.signIn.obs;
final RxBool _isLoading = false.obs;
final RxBool _obscurePassword = true.obs;

// Access via getters
AuthMode get authMode => _authMode.value;
bool get isLoading => _isLoading.value;
bool get obscurePassword => _obscurePassword.value;
```

UI automatically rebuilds when these values change using `Obx()`:

```dart
Obx(() => Text(
  controller.authMode == AuthMode.signIn 
    ? 'Sign in' 
    : 'Sign up'
))
```

## Form Validation

All validators are centralized in the controller:

```dart
// In AuthController
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

// In form
CustomTextField(
  controller: controller.emailController,
  validator: controller.validateEmail,
)
```

## Customization

### Change Initial Mode

```dart
// Start with sign-up mode
Get.bottomSheet(
  const AuthBottomSheet(
    initialMode: AuthMode.signUp,
  ),
);
```

### Custom Actions After Auth

```dart
// In AuthController, modify signIn() or signUp():
Future<void> signIn() async {
  if (!validateForm()) return;
  
  _isLoading.value = true;
  
  try {
    // Your custom auth logic here
    await myAuthService.signIn(
      emailController.text,
      passwordController.text,
    );
    
    Get.back(); // Close bottom sheet
    Get.offAll(() => HomeScreen()); // Navigate to home
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    _isLoading.value = false;
  }
}
```

## Benefits of This Architecture

1. **Single Source of Truth**: All auth logic in one controller
2. **Reusable**: One bottom sheet for both sign-in and sign-up
3. **Maintainable**: Easy to add new auth methods or fields
4. **Reactive**: UI automatically updates with state changes
5. **Testable**: Controller logic separated from UI
6. **Clean**: No setState, no widget rebuilds, just reactive state

## Migration from Old Bottom Sheets

The old `SignInBottomSheet` and `SignUpBottomSheet` can be deleted. They're replaced by:

- `AuthController` - manages all state and logic
- `AuthBottomSheet` - single UI component for both modes

This reduces code duplication and makes the auth flow easier to maintain.
