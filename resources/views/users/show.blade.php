@extends('admin.admin_template')
@section('tittle','Detail User')

@section('content')

<div class="box">
    <div class="box-header">
        <h3 class="box-tittle"> Show User</h3>
        <div class="box-tools pull-right">

            <!-- Collapse Button -->
            <button type="button" class="btn btn-box-tool" data-widget="collapse">
                <i class="fa fa-minus"></i>
            </button>
        </div>
    </div>
    <div class="box-body">
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Name:</strong>
                    {{-- {{ $user->name }} --}}
                    {!! Form::text('name', $user->name, array('class'=>'form-control','readonly')) !!}
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Email:</strong>
                    {{-- {{ $user->email }} --}}
                    {!! Form::text('email', $user->email, array('class'=>'form-control','readonly')) !!}
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Department:</strong>
                    {!! Form::select('id_department', $department, $user->id_department, ['placeholder'=>'Select Department','class'=>'form-control','name'=>'id_department','id'=>'id_department','disabled'=>'true']) !!}
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Section:</strong>
                    {{-- {!! Form::hidden('id_section_old', $user->id_section, null) !!} --}}
                     {!! Form::select('id_section',$section,$user->id_section,['class'=>'form-control','name'=>'id_section','id'=>'id_section','disabled'=>'true']) !!} 
                   
                    {{-- <select id='id_section' name='id_section' class="form-control">
                        <option value='0'>Select Section</option>
                     </select> --}}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Tittle:</strong>
                    {!! Form::text('tittle', $user->tittle, ['placeholder'=>'Tittle','class'=>'form-control','readonly']) !!}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Position:</strong>
                    {!! Form::text('position', $user->position, ['placeholder'=>'Position','class'=>'form-control','readonly']) !!}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Date of Birth:</strong>
                    {!! Form::date('dateofbirth', $user->dateofbirth, ['class'=>'form-control','readonly']) !!}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Office Phone:</strong>
                    {!! Form::number('office_phone', $user->office_phone, ['placeholder'=>'Office Phone','class'=>'form-control','readonly']) !!}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Celluler Phone:</strong>
                    {!! Form::number('cell_phone', $user->cell_phone, ['plaecholder'=>'Celluler Phone','class'=>'form-control','readonly']) !!}
                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Region</strong>
                    {!! Form::text('region', $user->region, ['placeholder'=>'Region','class'=>'form-control','readonly']) !!}
                </div>
                <div class="col-xs-13 col-sm-13 col-md-13">
                    <div class="form-group">
                        <strong>Job Description:</strong>
                        {!! Form::textarea('job_description', $user->job_description, ['placeholder'=>'Job Description','class'=>'form-control','readonly']) !!}
                    </div>

                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                    <strong>Profile Picture:</strong>
                    <div class="form-group">
                        <img id="preview"
                            src="{{asset((isset($user) && $user->image!='')?'storage/'.$user->image:'storage/noimage.jpg')}}"
                            height="200px" width="200px" />
                        {!! Form::file("image",["class"=>"form-control","style"=>"display:none"]) !!}
                        
                        <br />
                        
                        {{-- <input type="file" class="custom-file-input form-control" id="image" aria-describedby="inputGroupFileAddon01" src="{{$user->image}}"> --}}
                         {{-- {!! Form::text("image", $user->image, ["class"=>"form-control"]) !!} --}}
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12">
                    <strong>Signature:</strong>
                    <div class="form-group">
                        <img id="preview"
                            src="{{$user->sign}}" height="200px" width="200px" />
                        {{-- {!! Form::file("sign",["class"=>"form-control","style"=>"display:none"]) !!} --}}
                        
                       
                         {{-- <input type="file" class="custom-file-input form-control" id="image" aria-describedby="inputGroupFileAddon01" src="{{$user->image}}"> --}}
                         {{-- {!! Form::text("image", $user->image, ["class"=>"form-control"]) !!} --}}
                    </div>
                </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Roles:</strong>
                    @if(!empty($user->getRoleNames()))
                    @foreach($user->getRoleNames() as $v)
                    <label class="badge badge-success">{{ $v }}</label>
                    @endforeach
                    @endif
                </div>
            </div>
        </div>
    </div>
    <div class="box-footer">
        <a class="btn btn-default" href="{{ route('users.index') }}"> Back</a>
    </div>
</div>




@endsection
