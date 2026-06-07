<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ReportDamageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'damage_description' => ['required', 'string', 'max:2000'],
            'damage_photos'      => ['required', 'array', 'min:1', 'max:10'],
            'damage_photos.*'    => ['required', 'url', 'max:255'],
        ];
    }
}
