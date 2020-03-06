<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    //
    protected $table = 'department';
    protected $fillable = ['department'];
    /**
 * Get the value of the model's route key.
 *
 * @return mixed
 */
    public function getRouteKey()
    {
        $hashids = new \Hashids\Hashids('MySecretSalt');

        return $hashids->encode($this->getKey());
    }
}
