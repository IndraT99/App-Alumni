import 'package:flutter/material.dart';
import '../models/alumni.dart';
import '../services/auth_service.dart';
import 'petugas_dashboard.dart';

class EditAlumniPage extends StatefulWidget {
  final int alumniId;
  EditAlumniPage({required this.alumniId});

  @override
  _EditAlumniPageState createState() => _EditAlumniPageState();
}

class _EditAlumniPageState extends State<EditAlumniPage> {
  final _formKey = GlobalKey<FormState>();

  late AuthService authService;

  // semua controller yang ingin diedit
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nisController = TextEditingController();
  final _nisnController = TextEditingController();
  final _tahunAngkatanController = TextEditingController();
  final _namaUsahaController = TextEditingController();
  final _nomorTeleponController = TextEditingController();
  final _linkWebUsahaController = TextEditingController();

  Alumni? _alumni;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    _fetchAlumniData();
  }

  Future<void> _fetchAlumniData() async {
    try {
      final token = await authService.getToken();
      final data = await authService.getAlumniById(widget.alumniId, token!);

      setState(() {
        _alumni = data;
        _nameController.text = data.nama;
        _emailController.text = data.email;
        _alamatController.text = data.alamat ?? "";
        _nisController.text = data.nis ?? "";
        _nisnController.text = data.nisn ?? "";
        _tahunAngkatanController.text = (data.tahunAngkatan?.toString() ?? "");
        _namaUsahaController.text = data.namaUsaha ?? "";
        _nomorTeleponController.text = data.nomorTelepon ?? "";
        _linkWebUsahaController.text = data.linkWebUsaha ?? "";
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> updateAlumni() async {
    if (!_formKey.currentState!.validate() || _alumni == null) return;

    setState(() {
      _saving = true;
    });

    final token = await authService.getToken();
    final payload = {
      'nama': _nameController.text,
      'alamat': _alamatController.text,
      'nis': _nisController.text,
      'nisn': _nisnController.text,
      'email': _emailController.text,
      'tahun_angkatan': _tahunAngkatanController.text,
      'nama_usaha': _namaUsahaController.text,
      'nomor_telepon': _nomorTeleponController.text,
      'link_web_usaha': _linkWebUsahaController.text,
    };

    try {
      final res = await authService.updateUser(_alumni!.id, payload, token!);
      if ((res['message'] ?? '').toString().toLowerCase().contains('berhasil')) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alumni berhasil diperbarui'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } else {
        throw Exception(res.toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update gagal: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _nisController.dispose();
    _nisnController.dispose();
    _tahunAngkatanController.dispose();
    _namaUsahaController.dispose();
    _nomorTeleponController.dispose();
    _linkWebUsahaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data Alumni',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat data alumni...',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : _alumni == null
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
                        'Data tidak ditemukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Kembali'),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Pribadi',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _nameController,
                                      label: 'Nama Lengkap',
                                      icon: Icons.person,
                                      validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) => (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _alamatController,
                                      label: 'Alamat',
                                      icon: Icons.location_on,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _nomorTeleponController,
                                      label: 'Nomor Telepon',
                                      icon: Icons.phone,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Pendidikan',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _nisController,
                                      label: 'NIS',
                                      icon: Icons.badge,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _nisnController,
                                      label: 'NISN',
                                      icon: Icons.card_membership,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _tahunAngkatanController,
                                      label: 'Tahun Angkatan',
                                      icon: Icons.calendar_today,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Usaha (Opsional)',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _namaUsahaController,
                                      label: 'Nama Usaha',
                                      icon: Icons.business,
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
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _saving
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                          },
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
                                    onPressed: _saving ? null : updateAlumni,
                                    child: _saving
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            'Simpan Perubahan',
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
                          ],
                        ),
                      ),
                    ),
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
}