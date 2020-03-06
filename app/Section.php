<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Section extends Model
{
    //
    protected $table = 'section';
    protected $fillable = [
        'id_department',
        'section'
    ];
    protected $dates = [
        'updated_at',
        'created_at',
        'deleted_at',
    ];

}
