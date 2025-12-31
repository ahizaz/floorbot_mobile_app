# Custom Text Field Component

A reusable text input field component that provides consistent styling across the app and supports various input types including password fields with show/hide functionality.

## Features

- ✅ Optional label above the field
- ✅ Customizable hint text
- ✅ Password field with show/hide toggle
- ✅ Input validation support
- ✅ Keyboard type configuration
- ✅ Prefix and suffix icons support
- ✅ Auto-focus capability
- ✅ Form integration ready
- ✅ Follows app theme automatically

## Usage

### Basic Text Field

```dart
CustomTextField(
  hintText: 'Full Name',
  controller: _nameController,
  keyboardType: TextInputType.name,
)
```

### Email Field

```dart
CustomTextField(
  hintText: 'Email',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  },
)
```

### Password Field with Show/Hide

```dart
CustomTextField(
  hintText: 'Password',
  controller: _passwordController,
  keyboardType: TextInputType.visiblePassword,
  isPassword: true,
  showPasswordToggle: true,
  textInputAction: TextInputAction.done,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  },
)
```

### Field with Label

```dart
CustomTextField(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  controller: _nameController,
)
```

### Multiline Text Field

```dart
CustomTextField(
  hintText: 'Enter your message',
  controller: _messageController,
  maxLines: 5,
  textInputAction: TextInputAction.newline,
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `hintText` | `String` | required | Placeholder text shown when field is empty |
| `labelText` | `String?` | `null` | Optional label text shown above the field |
| `controller` | `TextEditingController?` | `null` | Controller for the text field |
| `keyboardType` | `TextInputType` | `TextInputType.text` | Type of keyboard to display |
| `isPassword` | `bool` | `false` | Whether this is a password field |
| `showPasswordToggle` | `bool` | `false` | Show the password visibility toggle button |
| `suffixIcon` | `Widget?` | `null` | Custom suffix icon widget |
| `prefixIcon` | `Widget?` | `null` | Custom prefix icon widget |
| `validator` | `String? Function(String?)?` | `null` | Validation function |
| `onChanged` | `void Function(String)?` | `null` | Callback when text changes |
| `onSaved` | `void Function(String?)?` | `null` | Callback when form is saved |
| `enabled` | `bool` | `true` | Whether the field is enabled |
| `maxLines` | `int` | `1` | Maximum number of lines |
| `textInputAction` | `TextInputAction?` | `null` | Action button on keyboard |
| `onFieldSubmitted` | `void Function(String)?` | `null` | Callback when field is submitted |
| `focusNode` | `FocusNode?` | `null` | Focus node for the field |
| `autofocus` | `bool` | `false` | Whether to autofocus this field |
| `initialValue` | `String?` | `null` | Initial value for the field |

## Complete Form Example

```dart
class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process form data
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Full Name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          CustomTextField(
            hintText: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          CustomTextField(
            hintText: 'Password',
            controller: _passwordController,
            isPassword: true,
            showPasswordToggle: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Styling

The component automatically uses your app's theme defined in:

- `InputDecorationTheme` - For borders, padding, colors
- `TextTheme` - For text styles

This ensures consistent appearance across all text fields in your app.
