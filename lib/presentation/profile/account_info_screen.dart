import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:intl/intl.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  bool _isEditMode = false;

  // User data
  String email = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String uid = '';

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          _errorMessage = 'No user is currently logged in';
          _isLoading = false;
        });
        return;
      }

      uid = user.uid;
      email = user.email ?? '';

      // Fetch additional user data from Firestore
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          firstName = userData.data()?['firstName'] ?? '';
          lastName = userData.data()?['lastName'] ?? '';
          phoneNumber = userData.data()?['phone'] ?? '';

          _isLoading = false;
        });

        // Set controller values
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
        _phoneController.text = phoneNumber;
      } else {
        setState(() {
          _errorMessage = 'User profile data not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> updateData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updateData);

      setState(() {
        firstName = _firstNameController.text;
        lastName = _lastNameController.text;
        phoneNumber = _phoneController.text;
        _isEditMode = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully', 
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating profile: $e';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile: $e',
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently logged in');
      }

      // Delete Firestore data first
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      try {
        // Try to delete the Firebase Auth account
        await user.delete();
      } catch (authError) {
        // Handle specific Firebase Auth errors
        if (authError is firebase_auth.FirebaseAuthException) {
          if (authError.code == 'requires-recent-login') {
            // User needs to reauthenticate before deleting account

            // Sign out anyway
            await firebase_auth.FirebaseAuth.instance.signOut();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'For security reasons, please sign in again before deleting your account.',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              
              // Navigate to login screen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
              return;
            }
          }
        }
        // Rethrow other errors to be caught by the outer try-catch
        throw authError;
      }
      
      // Sign out
      await firebase_auth.FirebaseAuth.instance.signOut();
      
      // Navigate to login screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your account has been successfully deleted',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting account: $e';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete account: $e',
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inriaSerif(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadUserData,
                          child: Text(
                            'Retry',
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _isEditMode
                    ? _buildEditProfileView()
                    : _buildProfileView(),
      ),
    );
  }

  Widget _buildProfileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBarWithLogo(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Account information',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Email field
          _buildInfoField('e-mail', email),

          const SizedBox(height: 12),

          // First name field
          _buildInfoField('first name', firstName),

          const SizedBox(height: 12),

          // Last name field
          _buildInfoField('Last name', lastName),

          const SizedBox(height: 12),

          // Phone number field
          _buildInfoField(
              'Phone number', phoneNumber.isEmpty ? 'Not set' : phoneNumber),

          const SizedBox(height: 25),

          // Edit button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black26, width: 1),
                ),
                minimumSize: const Size(80, 36),
              ),
              child:  Text('Edit',
              style: GoogleFonts.inriaSerif(textStyle:const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Delete account button
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.pink.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2.5), // Border thickness
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: MaterialButton(
                  onPressed: () {
                    _showDeleteAccountDialog();
                  },
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Delete my account',
                    style: GoogleFonts.inriaSerif(textStyle: TextStyle(
                      fontSize: 22,
                      color: Colors.red.shade400,
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBarWithLogo(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Profile',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

         

          // First name and Last name fields in a row
          Row(
            children: [
              // First name
              Expanded(
                child: _buildEditField(
                  label: 'First name',
                  controller: _firstNameController,
                ),
              ),

              const SizedBox(width: 16),

              // Last name
              Expanded(
                child: _buildEditField(
                  label: 'Last name',
                  controller: _lastNameController,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Email field
          _buildEditField(
            label: 'Email',
            controller: _emailController,
            enabled: false,
          ),

          const SizedBox(height: 24),

          // Phone number field
          _buildEditField(
            label: 'Phone number',
            controller: _phoneController,
          ),

          const Spacer(),

          // Save button (using gradient border like delete button)
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.pink.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Container(
                margin: const EdgeInsets.all(2), // Border thickness
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: MaterialButton(
                  onPressed: _updateUserData,
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Update',
                    style: GoogleFonts.inriaSerif(textStyle:const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    bool isDate = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inriaSerif(
            textStyle: TextStyle(
              fontSize: 16, 
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: isDate,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: isDate ? 'YYYY-MM-DD' : '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: GoogleFonts.inriaSerif(
            textStyle: TextStyle(
              fontSize: 16,
              color: enabled ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.inriaSerif(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          style: GoogleFonts.inriaSerif(
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
