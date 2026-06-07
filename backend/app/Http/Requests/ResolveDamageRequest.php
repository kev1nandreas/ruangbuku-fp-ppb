<?php

namespace App\Http\Requests;

use App\Models\Peminjaman;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ResolveDamageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'resolution'        => ['required', Rule::in([
                Peminjaman::DEPOSIT_TO_BORROWER,
                Peminjaman::DEPOSIT_TO_OWNER,
            ])],
            'resolution_note'   => ['required', 'string', 'max:2000'],
            'deposit_proof_url' => ['nullable', 'url', 'max:255'],
        ];
    }
}
