<?php

namespace App\Http\Controllers;

use App\Models\DeviceToken;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DeviceTokenController extends Controller
{
    /**
     * Register (or refresh) the FCM token for the current user's device.
     *
     * A token belongs to exactly one user at a time: if the same device was
     * previously signed in as someone else, re-registering moves it to the
     * caller so notifications stop following the old account.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'token'    => ['required', 'string', 'max:512'],
            'platform' => ['nullable', 'string', 'max:20'],
        ]);

        $deviceToken = DeviceToken::updateOrCreate(
            ['token' => $validated['token']],
            [
                'user_id'  => Auth::id(),
                'platform' => $validated['platform'] ?? null,
            ],
        );

        return $this->success('Device token terdaftar', $deviceToken);
    }

    /**
     * Unregister the device token (called on logout) so a shared device stops
     * receiving notifications for the signed-out user.
     */
    public function destroy(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'token' => ['required', 'string', 'max:512'],
        ]);

        DeviceToken::query()
            ->where('user_id', Auth::id())
            ->where('token', $validated['token'])
            ->delete();

        return $this->success('Device token dihapus');
    }
}
