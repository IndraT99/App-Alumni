<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UpdateRoleColumnInUsersTable extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            // Mengubah kolom role menjadi enum dengan dua pilihan 'petugas' dan 'alumni'
            $table->enum('role', ['petugas', 'alumni'])->default('alumni')->change();
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            // Mengembalikan kolom role menjadi tipe string tanpa enum
            $table->string('role')->default('alumni')->change();
        });
    }
}
