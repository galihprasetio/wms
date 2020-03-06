<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMaterialTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('material', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('item_code')->nullable()->default('NULL');
            $table->string('name')->nullable()->default('NULL');
            $table->string('spec')->nullable()->default('NULL');
            $table->string('unit')->nullable()->default('NULL');
            $table->string('remark')->nullable()->default('NULL');
            $table->string('created_by')->nullable()->default('NULL');
            $table->string('updated_by')->nullable()->default('NULL');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('material');
    }
}
