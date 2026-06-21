<?php

namespace App\Http\Controllers;

use App\Http\Requests\PresignedUrlRequest;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class StorageController extends Controller
{
    /**
     * Generate a presigned URL the client can use to upload a file directly
     * to MinIO. The client uploads with a PUT request to `upload_url`, then
     * sends the returned `url` (or `key`) back to the backend as a string
     * when saving the related record (e.g. a Buku coverImageUrl).
     */
    public function presignedUrl(PresignedUrlRequest $request)
    {
        $validated = $request->validated();

        $folder    = trim($validated['folder'] ?? 'uploads', '/');
        $extension = pathinfo($validated['filename'], PATHINFO_EXTENSION);
        $key       = $folder . '/' . Str::uuid()->toString() . ($extension ? '.' . $extension : '');

        /** @var \Illuminate\Filesystem\AwsS3V3Adapter $disk */
        $disk   = Storage::disk('minio');
        $client = $disk->getClient();
        $bucket = config('filesystems.disks.minio.bucket');

        $expiresIn = (int) config('filesystems.disks.minio.presign_ttl', 300);

        $command = $client->getCommand('PutObject', [
            'Bucket'      => $bucket,
            'Key'         => $key,
            'ContentType' => $validated['content_type'],
        ]);

        $presignedRequest = $client->createPresignedRequest($command, "+{$expiresIn} seconds");

        return $this->success('Presigned URL berhasil dibuat', [
            'upload_url'   => (string) $presignedRequest->getUri(),
            'method'       => 'PUT',
            'key'          => $key,
            'url'          => $disk->url($key),
            'content_type' => $validated['content_type'],
            'expires_in'   => $expiresIn,
        ]);
    }
}
