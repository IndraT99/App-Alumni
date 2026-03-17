<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UserProfileTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test user can view their profile when authenticated.
     */
    public function test_user_can_view_their_profile(): void
    {
        $user = User::factory()->create([
            'nama' => 'John Doe',
            'email' => 'john@example.com',
            'alamat' => '123 Street',
            'nis' => '12345678',
            'nisn' => '87654321',
            'tahun_angkatan' => 2020,
            'role' => 'alumni',
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/user/profile');

        $response->assertStatus(200)
            ->assertJson([
                'id' => $user->id,
                'nama' => 'John Doe',
                'email' => 'john@example.com',
                'alamat' => '123 Street',
                'nis' => '12345678',
                'nisn' => '87654321',
                'tahun_angkatan' => 2020,
                'role' => 'alumni',
            ]);
    }

    /**
     * Test unauthenticated user cannot view profile.
     */
    public function test_unauthenticated_user_cannot_view_profile(): void
    {
        $response = $this->getJson('/api/user/profile');

        $response->assertStatus(401);
    }
}
