<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PurchaseRequisition extends Model
{
    //
    protected $table = 'purchase_requisition';
    protected $fillable = [
        'pr_number',
        'request_date',
        'requestor',
        'department',
        'tittle',
        'currency',
        'total_ammount',
        'purpose',
        'updated_by'
    ];
    protected $dates = [
        'updated_at',
        'created_at',
        'deleted_at',
    ];

}
