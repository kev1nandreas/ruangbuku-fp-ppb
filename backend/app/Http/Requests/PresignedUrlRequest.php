<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PresignedUrlRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'filename'     => ['required', 'string', 'max:255'],
            'content_type' => ['required', 'string', 'max:255'],
            'folder'       => ['nullable', 'string', 'max:100', 'regex:/^[a-zA-Z0-9_\-\/]+$/'],
        ];
    }

    public function messages(): array
    {
        return [
            'folder.regex' => 'Folder hanya boleh berisi huruf, angka, garis bawah, strip, dan garis miring.',
        ];
    }
}
