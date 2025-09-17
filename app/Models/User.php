<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nama',
        'email',
        'password',
        'alamat',
        'nis',
        'nisn',
        'role',
        'foto',
        'tahun_angkatan',
        'nama_usaha',
        'nomor_telepon',
        'link_web_usaha',
        'kategori',  // Make sure this field is added as well
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    /**
     * Return the user's profile picture.
     * Add a method for convenience if needed.
     */
    public function getProfilePictureUrlAttribute()
    {
        return $this->foto ? url('storage/'.$this->foto) : url('assets/default-avatar.jpg');  // Adjust path if necessary
    }
}
