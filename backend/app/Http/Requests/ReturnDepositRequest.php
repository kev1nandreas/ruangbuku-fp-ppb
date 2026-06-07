<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ReturnDepositRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'deposit_proof_url' => ['nullable', 'url', 'max:255'],
            'resolution_note'   => ['nullable', 'string', 'max:2000'],
        ];
    }
}
