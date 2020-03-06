<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        return view('admin.dashboard');
    }
    public function dashboard(){
        // $totalDocument = collect(DB::select('select count(*)as total from documents'))->first()->total;
        // $totalUser = collect(DB::select('select count(*) as total from users'))->first()->total;
        // $totalCompleted = collect(DB::select('select count(*) as total from documents where doc_status ="Completed"'))->first()->total;
        //return view('admin.dashboard',compact('totalDocument','totalUser','totalCompleted'));
        return view('admin.dashboard');
    }
}
