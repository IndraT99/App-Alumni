<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class RenameAlumnisToUsersAndChangeKategoriColumn extends Migration
{
    public function up()
    {
        // Mengubah nama tabel alumnis menjadi users
        Schema::rename('alumnis', 'users');

        // Mengubah kolom id_kategori menjadi kategori dengan tipe string
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('id_kategori');  // Menghapus kolom id_kategori
            $table->string('kategori')->nullable();  // Menambahkan kolom kategori bertipe string
        });
    }

    public function down()
    {
        // Rollback untuk mengganti nama tabel dan kolom ke kondisi semula
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('kategori');  // Menghapus kolom kategori
            $table->integer('id_kategori')->nullable();  // Menambahkan kolom id_kategori dengan tipe integer
        });

        // Mengubah nama tabel users kembali ke alumnis
        Schema::rename('users', 'alumnis');
    }
}
