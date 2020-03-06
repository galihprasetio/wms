<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Material extends Model
{
    //
    use SoftDeletes;
    protected $table = 'material';
    protected $fillable = [
        'item_code',
        'name',
        'spec',
        'unit',
        'remark',
        'created_by',
        'updated_by',
    ];
    protected $dates = [
        'created_at',
        'updated_at',
        'deleted_at',
    ];
    
    
}
