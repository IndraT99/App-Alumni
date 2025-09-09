<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAlumniTable extends Migration
{
    public function up()
    {
        Schema::create('alumni', function (Blueprint $table) {
            $table->id('id_alumni');
            $table->string('nama');
            $table->text('alamat');
            $table->string('nis', 20);
            $table->string('nisn', 20);
            $table->string('password');
            $table->string('foto', 255)->nullable();
            $table->year('tahun_angkatan')->nullable();
            $table->string('nama_usaha', 255)->nullable();
            $table->string('nomor_telepon', 15)->nullable();
            $table->string('link_web_usaha', 255)->nullable();
            $table->string('email')->unique();  // Pastikan kolom email unik
            $table->integer('id_kategori')->nullable();
            $table->string('role', 50)->default('alumni');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('alumni');
    }
}
