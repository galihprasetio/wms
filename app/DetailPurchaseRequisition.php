<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class DetailPurchaseRequisition extends Model
{
    //
    protected $table = 'detail_purchase_requisition';
    protected $fillable = [
        'id_pr',
        'id_material',
        'qty',
        'price',
        'remark',
        'created_by',
        'updated_by'
    ];
    protected $dates = [
        'created_at',
        'updated_at',
        'deleted_at',
    ];
}
