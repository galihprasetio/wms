<?php

use Illuminate\Database\Seeder;
use App\ButtonType;

class ButtonTypeTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        $buttonTypes = [
            // 'Approve',
            // 'Sent Back',
            // 'Reject'
        ];
        foreach ($buttonTypes as $buttonType) {
            ButtonType::create(['button_name' => $buttonType]);
        }
    }
}
