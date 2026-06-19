import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProfileScreen extends StatefulWidget {
  const AuthProfileScreen({Key? key}) : super(key: key);

  @override
  State<AuthProfileScreen> createState() => _AuthProfileScreenState();
}

class _AuthProfileScreenState extends State<AuthProfileScreen> {
  // Firebase core instance variables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _waterGoalController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;
  User? _currentUser;
  String _selectedCategory = 'Student';

  @override
  void initState() {
    super.initState();
    _checkCurrentUserState();
  }

  // Listens to check if an active authenticated token already exists on the device
  void _checkCurrentUserState() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _fetchUserProfileData(user.uid);
    } else {
      _waterGoalController.text = '2.5';
    }
  }

  // RUBRIC: Firebase READ Operation - Pulls custom user parameter document profiles
  Future<void> _fetchUserProfileData(String uid) async {
    setState(() => _isLoading = true);
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _selectedCategory = data['userCategory'] ?? 'Student';
          _waterGoalController.text = (data['waterGoal'] ?? 2.5).toString();
        });
      }
    } catch (e) {
      _showSnackBar("Error retrieving profile metrics: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // RUBRIC: Firebase CREATE Operation - Registers credentials and writes initial profile documents
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isLoginMode) {
        // Authenticate existing user records
        UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        setState(() {
          _currentUser = creds.user;
        });
        await _fetchUserProfileData(creds.user!.uid);
        _showSnackBar("Logged in successfully!");
      } else {
        // Create brand new security credential block
        UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        double targetWater = double.tryParse(_waterGoalController.text) ?? 2.5;

        // Populate initial Firestore data collection entry
        await _firestore.collection('users').doc(creds.user!.uid).set({
          'email': creds.user!.email,
          'userCategory': _selectedCategory,
          'waterGoal': targetWater,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _currentUser = creds.user;
        });
        _showSnackBar("Account registered successfully!");
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "An authentication error occurred.");
    } catch (e) {
      _showSnackBar("Error connecting to database: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // RUBRIC: Firebase UPDATE Operation - Modifies existing collection records
  Future<void> _updateProfile() async {
    if (_currentUser == null) return;
    
    double? updatedGoal = double.tryParse(_waterGoalController.text);
    if (updatedGoal == null) {
      _showSnackBar("Please enter a valid numeric value for water goals.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'userCategory': _selectedCategory,
        'waterGoal': updatedGoal,
      });
      _showSnackBar("Profile changes synchronized with Cloud Firestore!");
    } catch (e) {
      _showSnackBar("Failed to save changes: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      setState(() {
        _currentUser = null;
        _emailController.clear();
        _passwordController.clear();
        _waterGoalController.text = '2.5';
      });
      _showSnackBar("Signed out safely.");
    } catch (e) {
      _showSnackBar("Error signing out: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    // The visual styling matches the deep emerald theme specified in your HTML prototype
    final Color primaryColor = const Color(0xFF0F4C3A);
    final Color accentColor = const Color(0xFFD4AF37);

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: _currentUser == null ? _buildAuthForm(primaryColor, accentColor) : _buildProfileDashboard(primaryColor),
            ),
    );
  }

  Widget _buildAuthForm(Color primary, Color accent) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(Icons.account_circle, size: 80, color: primary),
          const SizedBox(height: 10),
          Text(
            _isLoginMode ? 'Welcome to Mizan' : 'Create System Account',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: (val) => val != null && val.contains('@') ? null : 'Provide a valid email address.',
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (val) => val != null && val.length >= 6 ? null : 'Password must be at least 6 characters.',
          ),
          if (!_isLoginMode) ...[
            const SizedBox(height: 15),
            TextFormField(
              controller: _waterGoalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Daily Water Goal (Liters)'),
              validator: (val) => double.tryParse(val ?? '') != null ? null : 'Enter a valid target decimal metric.',
            ),
          ],
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            onPressed: _handleSubmit,
            child: Text(_isLoginMode ? 'Login' : 'Register Account', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
            child: Text(
              _isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Login",
              style: TextStyle(color: primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDashboard(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Personalization Matrix', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
        const Divider(thickness: 1.2),
        const SizedBox(height: 10),
        Text('Authenticated ID Token: ${_currentUser!.email}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 25),
        const Text('Target Profile Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: ['Student', 'Working Adult', 'Elderly'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val ?? 'Student'),
        ),
        const SizedBox(height: 20),
        const Text('Adjust Daily Health Metric Target (Liters)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _waterGoalController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 35),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: _updateProfile,
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text('Update Profile', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: _signOut,
                icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                label: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}