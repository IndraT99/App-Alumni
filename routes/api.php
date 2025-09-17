<?php

use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::prefix('user')->group(function () {
    // Route untuk registrasi user
    Route::post('register', [UserController::class, 'register']);
    
    // Route untuk login user
    Route::post('login', [UserController::class, 'login']);
    
    // Route untuk mengambil daftar alumni
    Route::get('users', [UserController::class, 'index']);
    
    // Route untuk mengambil detail alumni berdasarkan ID
    Route::get('users/{id}', [UserController::class, 'show']);  // Add this route for getting a single user by ID
    Route::put('update/{id}', [UserController::class, 'update']);
    Route::middleware('auth:sanctum')->delete('delete/{id}', [UserController::class, 'delete']);

    
    // Routes di bawah ini memerlukan autentikasi dengan token (auth:sanctum)
    Route::middleware('auth:sanctum')->group(function () {
        // Route untuk mengambil profil user
        Route::get('profile', [UserController::class, 'profile']);
        
        // Route untuk update user berdasarkan ID
        Route::put('edit/{id}', [UserController::class, 'update']);
        
        // Route untuk delete user berdasarkan ID
        Route::delete('delete/{id}', [UserController::class, 'delete']);
    });
});

