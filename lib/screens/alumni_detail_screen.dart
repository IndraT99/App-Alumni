import 'package:flutter/material.dart';
import '../models/alumni.dart';

class AlumniDetailScreen extends StatelessWidget {
  final Alumni alumni;

  AlumniDetailScreen({required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Alumni',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                      border: Border.all(
                        color: Colors.blue.shade300,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    alumni.nama,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    alumni.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Personal Information Card
            _buildInfoCard(
              title: 'Informasi Pribadi',
              children: [
                _buildInfoRow('Tahun Angkatan', alumni.tahunAngkatan.toString()),
                _buildInfoRow('NIS', alumni.nis),
                _buildInfoRow('NISN', alumni.nisn),
                if (alumni.nomorTelepon != null)
                  _buildInfoRow('Nomor Telepon', alumni.nomorTelepon!),
              ],
            ),
            SizedBox(height: 16),
            
            // Address Information Card
            _buildInfoCard(
              title: 'Alamat',
              children: [
                Text(
                  alumni.alamat,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Business Information Card (if available)
            if (alumni.namaUsaha != null || alumni.linkWebUsaha != null)
              _buildInfoCard(
                title: 'Informasi Usaha',
                children: [
                  if (alumni.namaUsaha != null)
                    _buildInfoRow('Nama Usaha', alumni.namaUsaha!),
                  if (alumni.linkWebUsaha != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Link Web Usaha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            // Add functionality to open the link
                          },
                          child: Text(
                            alumni.linkWebUsaha!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
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
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}