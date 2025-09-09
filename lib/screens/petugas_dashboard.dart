import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/alumni.dart';
import 'edit_alumni.dart';
import 'package:http/http.dart' as http;
import 'tambah_alumni.dart';

class PetugasDashboard extends StatefulWidget {
  @override
  _PetugasDashboardState createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  late AuthService authService;
  late Future<List<Alumni>> alumniList;
  late List<Alumni> filteredAlumni = [];
  late TextEditingController searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    searchController = TextEditingController();
    alumniList = authService.getAlumni();

    alumniList.then((alumni) {
      setState(() {
        filteredAlumni = alumni;
      });
    });
  }

  Future<void> deleteAlumni(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus alumni ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final uri = Uri.parse("${AuthService.api}/user/delete/$id");

    final token = await authService.getToken();
    final res = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...authService.headers,
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        alumniList = authService.getAlumni();
        alumniList.then((alumni) {
          setState(() {
            filteredAlumni = alumni;
          });
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alumni berhasil dihapus'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus alumni'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void editAlumni(Alumni alumni) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlumniPage(alumniId: alumni.id),
      ),
    ).then((_) {
      // Refresh data after returning from edit screen
      setState(() {
        alumniList = authService.getAlumni();
        alumniList.then((alumni) {
          setState(() {
            filteredAlumni = alumni;
          });
        });
      });
    });
  }

  Future<void> logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await authService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void filterAlumni(String query) {
    alumniList.then((alumni) {
      setState(() {
        filteredAlumni = alumni
            .where((alumni) =>
                alumni.nama.toLowerCase().contains(query.toLowerCase()) ||
                alumni.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _endSearch() {
    setState(() {
      _isSearching = false;
      searchController.clear();
      alumniList.then((alumni) {
        setState(() {
          filteredAlumni = alumni;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
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
        child: FutureBuilder<List<Alumni>>(
          future: alumniList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
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
              );
            }

            if (snapshot.hasError) {
              return Center(
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
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Silakan coba lagi nanti',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          alumniList = authService.getAlumni();
                        });
                      },
                      child: Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada data alumni',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TambahAlumniScreen()),
                        );
                      },
                      child: Text('Tambah Alumni Pertama'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final alumni = filteredAlumni.isEmpty ? snapshot.data! : filteredAlumni;

            return Column(
              children: [
                if (!_isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Manajemen Alumni',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                if (!_isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      '${alumni.length} alumni ditemukan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: alumni.length,
                    itemBuilder: (context, index) {
                      final alumniItem = alumni[index];
                      return _buildAlumniCard(alumniItem, context);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahAlumniScreen()),
          ).then((_) {
            // Refresh data after returning from add screen
            setState(() {
              alumniList = authService.getAlumni();
              alumniList.then((alumni) {
                setState(() {
                  filteredAlumni = alumni;
                });
              });
            });
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
    );
  }

  AppBar _buildNormalAppBar() {
    return AppBar(
      title: Text(
        "Dashboard Petugas",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue.shade700,
      elevation: 4,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: _startSearch,
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: logout,
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: _endSearch,
      ),
      title: TextField(
        controller: searchController,
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari nama atau email alumni...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onChanged: filterAlumni,
      ),
      backgroundColor: Colors.blue.shade700,
      actions: [
        if (searchController.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: Colors.white),
            onPressed: () {
              searchController.clear();
              alumniList.then((alumni) {
                setState(() {
                  filteredAlumni = alumni;
                });
              });
            },
          ),
      ],
    );
  }

  Widget _buildAlumniCard(Alumni alumni, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
            ),
            child: Icon(
              Icons.person,
              color: Colors.blue.shade700,
            ),
          ),
          title: Text(
            alumni.nama,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                alumni.email,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Angkatan: ${alumni.tahunAngkatan ?? "Tidak diketahui"}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue.shade600),
                onPressed: () => editAlumni(alumni),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade600),
                onPressed: () => deleteAlumni(alumni.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlumniSearchDelegate extends SearchDelegate {
  final List<Alumni> alumniList;
  final Function(String) onSearch;

  AlumniSearchDelegate(this.alumniList, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = alumniList
        .where((alumni) =>
            alumni.nama.toLowerCase().contains(query.toLowerCase()) ||
            alumni.email.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(results, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = alumniList
        .where((alumni) =>
            alumni.nama.toLowerCase().contains(query.toLowerCase()) ||
            alumni.email.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(suggestions, context);
  }

  Widget _buildSearchResults(List<Alumni> results, BuildContext context) {
    return Container(
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
      child: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada hasil ditemukan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Coba dengan kata kunci lain',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final alumniItem = results[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      title: Text(
                        alumniItem.nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(alumniItem.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue.shade600),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAlumniPage(alumniId: alumniItem.id),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red.shade600),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}