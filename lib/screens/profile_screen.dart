import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool isEditing = false;
  bool _isLoading = true;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController nisController;
  late TextEditingController nisnController;
  late TextEditingController tahunAngkatanController;
  late TextEditingController namaUsahaController;
  late TextEditingController phoneController;
  late TextEditingController websiteController;

  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    nisController = TextEditingController();
    nisnController = TextEditingController();
    tahunAngkatanController = TextEditingController();
    namaUsahaController = TextEditingController();
    phoneController = TextEditingController();
    websiteController = TextEditingController();
  }

  Future<void> _loadProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> userData = await AuthService().getUserProfile(token);
        setState(() {
          userProfile = userData;
          _populateControllers(userData);
          _isLoading = false;
        });
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil profil: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _populateControllers(Map<String, dynamic> userData) {
    nameController.text = userData['nama'] ?? '';
    emailController.text = userData['email'] ?? '';
    addressController.text = userData['alamat'] ?? '';
    nisController.text = userData['nis'] ?? '';
    nisnController.text = userData['nisn'] ?? '';
    tahunAngkatanController.text = userData['tahun_angkatan']?.toString() ?? '';
    namaUsahaController.text = userData['nama_usaha'] ?? '';
    phoneController.text = userData['nomor_telepon'] ?? '';
    websiteController.text = userData['link_web_usaha'] ?? '';
  }

  Future<void> _updateProfile() async {
    if (userProfile == null) return;

    final token = await AuthService().getToken() ?? '';
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token tidak ditemukan'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final updatedData = {
      'nama': nameController.text,
      'email': emailController.text,
      'alamat': addressController.text,
      'nis': nisController.text,
      'nisn': nisnController.text,
      'tahun_angkatan': tahunAngkatanController.text,
      'nama_usaha': namaUsahaController.text,
      'nomor_telepon': phoneController.text,
      'link_web_usaha': websiteController.text,
    };

    try {
      await AuthService().updateUser(userProfile!['id'], updatedData, token);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      setState(() {
        isEditing = false;
      });
      // Reload profile to get updated data
      await _loadProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal', style: TextStyle(color: Colors.grey.shade700)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await AuthService().logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _cancelEdit() {
    if (userProfile != null) {
      _populateControllers(userProfile!);
    }
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _cancelEdit,
              color: Colors.white,
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat profil...',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : userProfile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Gagal memuat profil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile Header
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.blue.shade100,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  userProfile!['nama'] ?? 'Nama tidak tersedia',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userProfile!['email'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                if (userProfile!['tahun_angkatan'] != null)
                                  Text(
                                    'Angkatan ${userProfile!['tahun_angkatan']}',
                                    style: TextStyle(
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                            _buildEditableField(
                              label: 'Nama Lengkap',
                              controller: nameController,
                              icon: Icons.person,
                              isEditing: isEditing,
                            ),
                            _buildEditableField(
                              label: 'Email',
                              controller: emailController,
                              icon: Icons.email,
                              isEditing: isEditing,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _buildEditableField(
                              label: 'Alamat',
                              controller: addressController,
                              icon: Icons.location_on,
                              isEditing: isEditing,
                              maxLines: 2,
                            ),
                            _buildEditableField(
                              label: 'Nomor Telepon',
                              controller: phoneController,
                              icon: Icons.phone,
                              isEditing: isEditing,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Education Information
                        _buildSectionCard(
                          title: 'Informasi Pendidikan',
                          children: [
                            _buildEditableField(
                              label: 'NIS',
                              controller: nisController,
                              icon: Icons.badge,
                              isEditing: isEditing,
                            ),
                            _buildEditableField(
                              label: 'NISN',
                              controller: nisnController,
                              icon: Icons.card_membership,
                              isEditing: isEditing,
                            ),
                            _buildEditableField(
                              label: 'Tahun Angkatan',
                              controller: tahunAngkatanController,
                              icon: Icons.calendar_today,
                              isEditing: isEditing,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Business Information (if available)
                        if (userProfile!['nama_usaha'] != null || userProfile!['link_web_usaha'] != null)
                          Column(
                            children: [
                              _buildSectionCard(
                                title: 'Informasi Usaha',
                                children: [
                                  if (userProfile!['nama_usaha'] != null)
                                    _buildEditableField(
                                      label: 'Nama Usaha',
                                      controller: namaUsahaController,
                                      icon: Icons.business,
                                      isEditing: isEditing,
                                    ),
                                  if (userProfile!['link_web_usaha'] != null)
                                    _buildEditableField(
                                      label: 'Link Web Usaha',
                                      controller: websiteController,
                                      icon: Icons.link,
                                      isEditing: isEditing,
                                      keyboardType: TextInputType.url,
                                    ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),

                        // Action Buttons
                        if (!isEditing)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit Profil'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                        if (isEditing)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _cancelEdit,
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
                                  onPressed: _updateProfile,
                                  child: Text(
                                    'Simpan',
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
                        SizedBox(height: 16),

                        // Logout Button
                        OutlinedButton(
                          onPressed: _confirmLogout,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout, color: Colors.red.shade700),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.red.shade400),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
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

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
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
          enabled: isEditing,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}