<?php


namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\User;
use Spatie\Permission\Models\Role;
use App\Department;
use App\Province;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Yajra\Datatables\Datatables;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Section;
use function GuzzleHttp\json_encode;

class UserController extends Controller
{
    function __construct()
    {
        $this->middleware('permission:user-list');
        $this->middleware('permission:user-create', ['only' => ['create', 'store']]);
        $this->middleware('permission:user-edit', ['only' => ['edit', 'update']]);
        $this->middleware('permission:user-delete', ['only' => ['destroy']]);
        $this->middleware('permission:user-profile',['only' => ['showProfile','updateProfile']]);
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        return view('users.index');
    }
    // public function getData()
    // {
    //     $users = User::select(['id', 'name', 'email', 'password', 'created_at', 'updated_at']);
    //     return Datatables::of($users)->addColumn('action', function ($users) {
    //         return '<a href="users/' . $users->id . '/edit" class="btn btn-xs btn-primary"><i class="glyphicon glyphicon-edit"></i></a>
    //         <a href="javascript:void(0)" class="btn btn-xs btn-danger deleteUser data-id="' . $users->id . '""><i class="glyphicon glyphicon-trash"></i></a>';
    //     })
    //         ->editColumn('id', '{{$id}}')
    //         ->removeColumn('password')
    //         ->make(true);
    // }
    public function getData()
    {
        $user = User::select(['id', 'name', 'email', 'password','image', 'created_at', 'updated_at']);
        return Datatables::of($user)
            ->addColumn('action', function ($user) {
                return '
                <a href="'.route('users.show',$user->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-eye-open"></i> Detail</a>
                <a href="'.route('users.edit',$user->id).'" class="btn btn-xs btn-default"><i class="glyphicon glyphicon-edit"></i> Edit</a>
                <a href="data-remote" data-remote ="'.route('users.destroyd',$user->id).'"class="btn btn-xs btn-delete btn-default"><i class="glyphicon glyphicon-edit"></i> Delete</a>';
                })
                 ->editColumn('updated_at', function ($user) {
                return $user->updated_at->diffForHumans();
                })->filterColumn('updated_at', function ($query, $keyword) {
                         $query->whereRaw("DATE_FORMAT(updated_at,'%Y/% m/%d') like ?", ["%$keyword%"]);
                        })           
                ->make(true);

                
    }
    // /**
    //  * Show the application selectAjax.
    //  *
    //  * @return \Illuminate\Http\Response
    //  */
    // public function selectAjax(Request $request){
    //     if($request->ajax()){
    //         $section = DB::table('section')->where('id_department',$request->id_department)->pluck('section','id')->all();
    //         $data = view('ajax-select',compact('section'))->render();
    //         return response()->json(['options'=>$data]);
    //     }
    // }
    public function getSection($iddepartment=0){
        //$section['data'] = DB::table('section')->where('id_department',$iddepartment)->pluck('section','id')->all();
        //$section['data'] = User::getSectionName($iddepartment);
        $section['data'] = DB::table('section')->where('id_department',$iddepartment)->get();
        echo json_encode($section);
        exit;
    }
    public function getRegion(Request $request){
        $term = trim($request->q);
        if(empty($term)){
           return response()->json([]);
           
        }else {
            $tags = Province::select(['province','province'])->where('province','LIKE','%'.$term.'%')->get();

            $formatted_tags = [];
    
            foreach ($tags as $tag) {
                $formatted_tags[] = ['province' => $tag->province, 'province' => $tag->province];
            }
            return response()->json($formatted_tags);
        }
        
    }
    /**
    * Show the form for creating a new resource.
    *
    * @return \Illuminate\Http\Response
    */
    public function create()
    {
        $department = Department::pluck('department','id')->all();
        $roles = Role::pluck('name', 'name')->all();
        // $province = Province::pluck('province')->all();
        $section = DB::table('section')->get();
        return view('users.create', compact('roles','department','section'));
    }


    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request, [
            'name' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|same:confirm-password',
            'id_department' => 'required',
            'id_section' => 'required',
            'tittle' => 'required',
            'position' => 'required',
            'dateofbirth' => 'required',
            'region' => 'required',
            'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            
            'roles' => 'required'
        ]);

        
        
        $input = $request->all();
        $input['password'] = Hash::make($input['password']);
        

        //Upload image to storage link
        // $imageName = time().'.'.request()->image->getClientOriginalExtension();
        // request()->image->move(public_path('storage'), $imageName);
        // $imagePath = storage_path('storage') .'/'.$imageName;
        // $input['image'] = $imagePath;  
        $input['image'] = time().'.'.$request->image->getClientOriginalExtension();
        $request->image->move(public_path('storage'), $input['image']);
        
        // $input['sign'] = time().'.'.$request->sign->getClientOriginalExtension();
        // $request->sign->move(public_path('storage'), $input['sign']);
        

        $user = User::create($input);
        $user->assignRole($request->input('roles'));


        return redirect()->route('users.index')
            ->with(['success' => 'User created successfully', 'class' => 'close']);
    }


    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $user = User::find($id);
        $department = Department::all()->pluck('department','id')->toArray();
        $section = Section::all()->pluck('section','id')->toArray();
        return view('users.show', compact('user','department','section'));
    }
    public function profile($id){
        $user = User::find($id);
        $department = Department::all()->pluck('department','id')->toArray();
        $section = Section::all()->pluck('section','id')->toArray();
        return view('users.show', compact('user','department','section'));
    }
    public function showProfile($id){
        

        $user = User::find($id);
        $this->authorizeForUser(Auth::user(), 'show', [$user]);
        $department = Department::all()->pluck('department','id');
        //$section = Section::all()->pluck('section','id_department','id')->toArray();
        $section = DB::table('section')->get();
        //$section = Section::all()->pluck('section','id')->toArray();
        $roles = Role::pluck('name', 'name')->all();
        $userRole = $user->roles->pluck('name', 'name')->all();
        $departmentName = DB::Table('department')
        ->join('users','department.id','=','users.id_department')
        ->select('department.department')
        ->where('users.id',$id)
        ->first();
        
        return view('users.profile', compact('user', 'roles', 'userRole','department','section','departmentName'));
        

    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $user = User::find($id);
        $department = Department::all()->pluck('department','id');
        //$section = Section::all()->pluck('section','id_department','id')->toArray();
        $section = DB::table('section')->get();
        //$section = Section::all()->pluck('section','id')->toArray();
        $roles = Role::pluck('name', 'name')->all();
        $userRole = $user->roles->pluck('name', 'name')->all();
        


        return view('users.edit', compact('user', 'roles', 'userRole','department','section'));
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
        $this->validate($request, [
            'name' => 'required',
            'email' => 'required|email|unique:users,email,'. $id,
            'id_department' => 'required',
            'id_section' => 'required',
            'tittle' => 'required',
            'position' => 'required',
            'dateofbirth' => 'required',
            'region' => 'required',
            'image' => 'image|mimes:jpeg,png,jpg|max:500',
            'password' => 'same:confirm-password',
            'roles' => 'required'
        ]);

                
        $user = User::find($id);
        
        $input = $request->all();
        if (!empty($input['password'])) {
            $input['password'] = Hash::make($input['password']);
        } else {
            $input = array_except($input, array('password'));
        }
        
        if(!empty($input['image'])){
        //Upload file image
        Storage::delete(public_path('storage'),$user->image);
        $input['image'] = time().'.'.$request->image->getClientOriginalExtension();
        $request->image->move(public_path('storage'), $input['image']);
        }else {
            $input = array_except($input, array('image'));
        }
        //Upload file sign
        if(empty($input['sign'])){
            $input = array_except($input, array('sign'));
        }
        
        $user->id_section = $request->input('id_section');
        
        
        

        
        $user->update($input);
        DB::table('model_has_roles')->where('model_id', $id)->delete();


        $user->assignRole($request->input('roles'));

       
        
        
        return redirect()->route('users.index')
            ->with('success', 'Data has been updated');
        
    }
    public function updateProfile(Request $request, $id)
    {
        $this->validate($request, [
            'name' => 'required',
            'password' => 'same:confirm-password',
            'email' => 'required|email|unique:users,email,'. $id,
            'dateofbirth' => 'required',
            'region' => 'required',
            'image' => 'image|mimes:jpeg,png,jpg|max:2048'
            ]);

                
        $user = User::find($id);
        
        $input = $request->all();
        if (!empty($input['password'])) {
            $input['password'] = Hash::make($input['password']);
        } else {
            $input = array_except($input, array('password'));
        }

        if(!empty($input['image'])){
        //Upload file image
        Storage::delete(public_path('storage'),$user->image);
        $input['image'] = time().'.'.$request->image->getClientOriginalExtension();
        $request->image->move(public_path('storage'), $input['image']);
        }else {
            $input = array_except($input, array('image'));
        }
        //Upload file sign
        if(empty($input['sign'])){
            $input = array_except($input, array('sign'));
        }
        $user->update($input);
        // DB::table('model_has_roles')->where('model_id', $id)->delete();
        // $user->assignRole($request->input('roles'));
        return redirect()->route('users.index')
            ->with('success', 'Data has been updated');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {   
        $user = User::find($id);
        Storage::delete(public_path('storage'),$user->image);
        $user->delete($id);
        return response()->json()->with('success','Data has been deleted');
      // return redirect()->route('users.index')->with('success','Data has been deleted');
    }
}
