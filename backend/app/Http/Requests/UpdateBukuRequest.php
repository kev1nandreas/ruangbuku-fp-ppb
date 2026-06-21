<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateBukuRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'isbn'             => ['sometimes', 'string', 'max:30'],
            'title'            => ['sometimes', 'string', 'max:255'],
            'author'           => ['sometimes', 'string', 'max:255'],
            'description'      => ['nullable', 'string', 'max:2000'],
            'isPublic'         => ['boolean'],
            'statusVerifikasi' => ['string', 'in:pending,approved,rejected', 'max:20'],
            'genre_ids'        => ['nullable', 'array'],
            'genre_ids.*'      => ['string', 'exists:genres,id'],
        ];
    }
}
