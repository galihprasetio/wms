<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Yajra\Datatables\Datatables;
use App\Http\Controllers\Controller;
use DB;
use App\Section;
use App\Department;

class SectionController extends Controller
{
    function __construct()
    {
        $this->middleware('permission:section-list');
        $this->middleware('permission:section-create', ['only' => ['create', 'store']]);
        $this->middleware('permission:section-edit', ['only' => ['edit', 'update']]);
        $this->middleware('permission:section-delete', ['only' => ['destroy']]);
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        return view('section.index');
    }
    public function getData(){
       
        $section = DB::table('section')
        ->join('department','section.id_department','=','department.id')
        ->select('section.*','department.department')->get();
        
        return Datatables::of($section)->addColumn('action', function($section){
            return '
            <a href="'.route('section.show',$section->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-eye-open"></i> Detail</a>
            <a href="'.route('section.edit',$section->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-edit"></i> Edit</a>';
        })
         
            ->make(true);

        // $section = Section::select('id','id_department','section','updated_at','created_at');
        // return Datatables::of($section)->addColumn('action', function($section){
        //         return '
        //         <a href="'.route('department.show',$section->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-eye-open"></i> Detail</a>
        //         <a href="'.route('department.edit',$section->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-edit"></i> Edit</a>';
        //     })
        //     ->editColumn('updated_at', function ($section) {
        //         return $section->updated_at->diffForHumans();
        //         })->filterColumn('updated_at', function ($query, $keyword) {
        //                  $query->whereRaw("DATE_FORMAT(updated_at,'%Y/% m/%d') like ?", ["%$keyword%"]);
        //                 })   
        //         ->make(true);

    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        $department_list = Department::pluck('department','id');
        return view('section.create',compact('department_list'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
        $this->validate($request,[
            'id_department' => 'required',
            'section' => 'required'
        ]);
        $section = new \App\Section();
        $section->id_department = $request->input('id_department') ;
        $section->section = $request->input('section');
        $section->save();
        return redirect()->route('section.index')->with('success','data has been created');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
        // $department_list = Department::pluck('department','id');
        // $section = Section::find($id);
        // return view('section.show',compact('section','department_list'));
        $departments = Department::all()->pluck('department','id')->toArray();
        $section = Section::find($id);
        // return view('section.show')->withPost($section)->withCategories($departments);
        return view('section.show',compact('section','departments'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
        $departments = Department::all()->pluck('department','id')->toArray();
        $section = Section::find($id);
        return view('section.edit',compact('section','departments'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
        $this->validate($request,[
            'id_department'=> 'required',
            'section' => 'required'
        ]);
        $section = Section::find($id);
        $section->id_department = $request->input('id_department');
        $section->section = $request->input('section');
        $section->save();
        return redirect()->route('section.index')->with('success','Data has been updated');

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
