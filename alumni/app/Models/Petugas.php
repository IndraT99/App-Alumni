<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Petugas extends Model
{
public function up()
{
    Schema::create('petugas', function (Blueprint $table) {
        $table->id('id_petugas');
        $table->string('nama');
        $table->string('password');
        $table->string('role', 50)->default('petugas');
        $table->timestamps();
    });
}

}
