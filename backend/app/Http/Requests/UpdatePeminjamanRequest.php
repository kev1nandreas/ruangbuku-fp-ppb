<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePeminjamanRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'status'       => ['sometimes', 'string', 'in:pending,approved,rejected,returned', 'max:20'],
            'verified_at'  => ['nullable', 'date'],
            'returned_at'  => ['nullable', 'date'],
            'buktiDeposit' => ['sometimes', 'integer'],
        ];
    }
}
