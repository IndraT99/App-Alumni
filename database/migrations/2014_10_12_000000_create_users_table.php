<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->text('alamat');
            $table->string('nis', 20);
            $table->string('nisn', 20);
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->string('role')->default('alumni');
            $table->string('foto', 255)->nullable();
            $table->year('tahun_angkatan')->nullable();
            $table->string('nama_usaha', 255)->nullable();
            $table->string('nomor_telepon', 15)->nullable();
            $table->string('link_web_usaha', 255)->nullable();
            $table->string('kategori', 100)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
