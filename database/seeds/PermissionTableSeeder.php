<?php


use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;


class PermissionTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $permissions = [
            // 'role-list',
            // 'role-create',
            // 'role-edit',
            // 'role-delete',
            // 'permission-list',
            // 'permission-create',
            // 'permission-edit',
            // 'permission-delete',
            // 'department-list',
            // 'department-create',
            // 'department-edit',
            // 'document-list',
            // 'document-create',
            // 'document-edit',
            // 'user-list',
            // 'user-create',
            // 'user-edit',
                'user-profile',
            // 'section-list',
            // 'section-edit',
            // 'section-create',
            // 'workflow-list',
            // 'workflow-edit',
            // 'workflow-create',

        ];


        foreach ($permissions as $permission) {
            Permission::create(['name' => $permission]);
        }
    }
}
