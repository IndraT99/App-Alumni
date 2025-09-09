<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;  // Pastikan model User sudah dibuat
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function show($id)
{
    // Find the user by ID
    $user = User::find($id);

    // If the user is not found, return a 404 error
    if (!$user) {
        return response()->json(['message' => 'User tidak ditemukan'], 404);
    }

    // Return the user data in JSON format
    return response()->json($user);
}
        public function profile(Request $request)
    {
        // Mengambil data user yang sedang login
        $user = $request->user();

        // Kembalikan data profil user
        return response()->json([
            'id' => $user->id,
            'nama' => $user->nama,
            'email' => $user->email,
            'alamat' => $user->alamat,
            'nis' => $user->nis,
            'nisn' => $user->nisn,
            'tahun_angkatan' => $user->tahun_angkatan,
            'nama_usaha' => $user->nama_usaha,
            'nomor_telepon' => $user->nomor_telepon,
            'link_web_usaha' => $user->link_web_usaha,
            'role' => $user->role,
            'foto' => $user->foto,  // Asumsi ada kolom foto untuk gambar profil
            'kategori' => $user->kategori
        ]);
    }
    // Fungsi untuk mengambil data alumni saja (menyembunyikan petugas)
    public function index()
    {
        // Mengambil hanya data user yang berrole alumni
        $alumni = User::where('role', 'alumni')->get();

        // Mengembalikan data alumni dalam format JSON
        return response()->json($alumni);
    }

    // Fungsi untuk registrasi user
    public function register(Request $request)
    {
        $validatedData = $request->validate([
            'nama' => 'required|string|max:255',
            'alamat' => 'required|string|max:500',
            'nis' => 'nullable|string|max:20',
            'nisn' => 'nullable|string|max:20',
            'email' => 'required|email|unique:users,email',  // Memastikan validasi unik untuk email di tabel users
            'password' => 'required|string|min:6',
            'tahun_angkatan' => 'nullable|digits:4',
            'nama_usaha' => 'nullable|string|max:255',
            'nomor_telepon' => 'nullable|string|max:15',
            'link_web_usaha' => 'nullable|string|max:255',
            'kategori' => 'nullable|string|max:255',  // Menambahkan validasi kategori
        ]);

        // Simpan data user
        $user = new User();
        $user->nama = $validatedData['nama'];
        $user->alamat = $validatedData['alamat'];
        $user->nis = $validatedData['nis'];
        $user->nisn = $validatedData['nisn'];
        $user->email = $validatedData['email'];
        $user->password = Hash::make($validatedData['password']);
        $user->tahun_angkatan = $validatedData['tahun_angkatan'];
        $user->nama_usaha = $validatedData['nama_usaha'] ?? null;
        $user->nomor_telepon = $validatedData['nomor_telepon'] ?? null;
        $user->link_web_usaha = $validatedData['link_web_usaha'] ?? null;

        // Menambahkan kategori dan role otomatis
        $user->role = 'alumni';  // Atur role menjadi 'alumni'
        $user->kategori = $validatedData['kategori'] ?? null;  // Menyimpan kategori yang diberikan

        $user->save();

        return response()->json(['message' => 'Registrasi berhasil'], 200);
}

    // Fungsi untuk login user
    public function login(Request $request)
    {
        // Validasi data yang dikirimkan
        $validatedData = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        // Cari user berdasarkan email
        $user = User::where('email', $validatedData['email'])->first();

        if (!$user || !Hash::check($validatedData['password'], $user->password)) {
            return response()->json(['message' => 'Email atau password salah'], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user->id,
                'nama' => $user->nama,
                'email' => $user->email,
                'role' => $user->role,
            ],
            'token' => $token
        ], 200);

    }
    public function update(Request $request, $id)
    {
        // Validasi data yang dikirimkan
        $validatedData = $request->validate([
            'nama' => 'required|string|max:255',
            'alamat' => 'required|string|max:500',
            'nis' => 'nullable|string|max:20',
            'nisn' => 'nullable|string|max:20',
            'email' => 'required|email',  // Memastikan email tetap valid
            'password' => 'nullable|string|min:6',  // Password opsional jika tidak ingin diubah
            'tahun_angkatan' => 'nullable|digits:4',
            'nama_usaha' => 'nullable|string|max:255',
            'nomor_telepon' => 'nullable|string|max:15',
            'link_web_usaha' => 'nullable|string|max:255',
            'kategori' => 'nullable|string|max:255',
        ]);

        // Cari user berdasarkan ID
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        // Update data user
        $user->nama = $validatedData['nama'];
        $user->alamat = $validatedData['alamat'];
        $user->nis = $validatedData['nis'];
        $user->nisn = $validatedData['nisn'];
        $user->email = $validatedData['email'];
        
        // Cek apakah password diubah, jika iya, update password
        if ($request->filled('password')) {
            $user->password = Hash::make($validatedData['password']);
        }

        $user->tahun_angkatan = $validatedData['tahun_angkatan'];
        $user->nama_usaha = $validatedData['nama_usaha'] ?? $user->nama_usaha;
        $user->nomor_telepon = $validatedData['nomor_telepon'] ?? $user->nomor_telepon;
        $user->link_web_usaha = $validatedData['link_web_usaha'] ?? $user->link_web_usaha;
        $user->kategori = $validatedData['kategori'] ?? $user->kategori;

        $user->save();

        return response()->json(['message' => 'Data berhasil diperbarui'], 200);
    }
    public function delete($id)
    {
        // Find user by ID
        $user = User::find($id);

        // If user not found, return 404
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        // Delete the user
        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus'], 200);
    }
}
