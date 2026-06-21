<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreBukuRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'isbn'            => ['required', 'string', 'max:30'],
            'title'           => ['required', 'string', 'max:255'],
            'author'          => ['required', 'string', 'max:255'],
            'description'     => ['nullable', 'string', 'max:2000'],
            'isPublic'        => ['boolean'],
            'coverImageUrl'   => ['nullable', 'string', 'max:255'],
            'genre_ids'       => ['nullable', 'array'],
            'genre_ids.*'     => ['string', 'exists:genres,id'],
        ];
    }
}
