<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Auth::routes();

Route::group(['middleware' => ['auth']], function () {
    route::get('/','HomeController@dashboard')->name('/');
    route::get('admin','HomeController@dashboard')->name('admin');
    Route::resource('roles', 'RoleController');
    Route::resource('users', 'UserController');
    Route::resource('department', 'DepartmentController');
    Route::resource('section', 'SectionController');
    Route::resource('material','MaterialController');
    
    Route::get('users.datauser', 'UserController@getData')->name('users.datauser');
    Route::get('usersd/{id}', 'UserController@destroy')->name('users.destroyd');
    Route::get('userss/getRegion','UserController@getRegion');
    Route::get('users.showProfile.{id}','UserController@showProfile')->name('users.showProfile');
    Route::patch('users.updateProfile.{id}','UserController@updateProfile')->name('users.updateProfile');

    Route::get('rolesd/{id}','RoleController@destroy')->name('roles.destroyd');
    Route::get('roles.dataroles', 'RoleController@getData')->name('roles.dataroles');
    
    Route::get('department.datadepartment','DepartmentController@getData')->name('department.datadepartment');
    
    Route::get('section.datasection','SectionController@getData')->name('section.datasection');

    Route::get('material.datamaterial','MaterialController@getMaterial')->name('material.datamaterial');
    Route::get('material.{id}','MaterialController@destroy')->name('material.destroy');
});
