<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePurchaseRequisitionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('purchase_requisition', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('pr_number');
            $table->dateTime('reqeust_date');
            $table->string('requestor');
            $table->string('department');
            $table->string('tittle');
            $table->string('currency');
            $table->float('total_ammount');
            $table->text('purpose');
            $table->text('updated_by');
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
        Schema::dropIfExists('purchase_requisition');
    }
}
