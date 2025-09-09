import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class TambahAlumniScreen extends StatefulWidget {
  @override
  _TambahAlumniScreenState createState() => _TambahAlumniScreenState();
}

class _TambahAlumniScreenState extends State<TambahAlumniScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _tahunAngkatanController = TextEditingController();
  final TextEditingController _namaUsahaController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _linkWebUsahaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  void _tambahAlumni() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password tidak cocok"),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password harus memiliki minimal 6 karakter"),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final Map<String, String> data = {
      'nama': _namaController.text,
      'alamat': _alamatController.text,
      'nis': _nisController.text,
      'nisn': _nisnController.text,
      'email': _emailController.text,
      'password': password,
      'tahun_angkatan': _tahunAngkatanController.text,
      'nama_usaha': _namaUsahaController.text,
      'nomor_telepon': _nomorTeleponController.text,
      'link_web_usaha': _linkWebUsahaController.text,
      'kategori': _kategoriController.text,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final response = await authService.register(data);

      if (response['message'] == "Registrasi berhasil") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alumni berhasil ditambahkan!'),
            backgroundColor: Colors.green.shade700,
            duration: Duration(seconds: 2),
          ),
        );
        // Clear form after success
        _formKey.currentState!.reset();
        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, true); // Return success signal
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Alumni Baru",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 40,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Form Tambah Alumni',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Isi data lengkap alumni baru',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Personal Information
                  _buildSectionCard(
                    title: 'Informasi Pribadi',
                    children: [
                      _buildTextField(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _alamatController,
                        label: 'Alamat',
                        icon: Icons.location_on,
                        maxLines: 2,
                        validator: (value) => value == null || value.isEmpty ? 'Alamat tidak boleh kosong' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _nomorTeleponController,
                        label: 'Nomor Telepon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Education Information
                  _buildSectionCard(
                    title: 'Informasi Pendidikan',
                    children: [
                      _buildTextField(
                        controller: _nisController,
                        label: 'NIS',
                        icon: Icons.badge,
                        validator: (value) => value == null || value.isEmpty ? 'NIS tidak boleh kosong' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _nisnController,
                        label: 'NISN',
                        icon: Icons.card_membership,
                        validator: (value) => value == null || value.isEmpty ? 'NISN tidak boleh kosong' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _tahunAngkatanController,
                        label: 'Tahun Angkatan',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Tahun angkatan tidak boleh kosong' : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Business Information
                  _buildSectionCard(
                    title: 'Informasi Usaha (Opsional)',
                    children: [
                      _buildTextField(
                        controller: _namaUsahaController,
                        label: 'Nama Usaha',
                        icon: Icons.business,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _kategoriController,
                        label: 'Kategori Usaha',
                        icon: Icons.category,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _linkWebUsahaController,
                        label: 'Link Web Usaha',
                        icon: Icons.link,
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Password Section
                  _buildSectionCard(
                    title: 'Keamanan Akun',
                    children: [
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: _obscurePassword,
                        onToggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Konfirmasi Password',
                        obscureText: _obscureConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _cancel,
                          child: Text('Batal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.grey.shade800,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _tambahAlumni,
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Tambah Alumni',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, color: Colors.blue.shade600),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}