@extends('admin.admin_template')
@section('tittle','Detail User')

@section('content')

<div class="box">
    <div class="box-header">
        <h3 class="box-tittle"> </h3>
        <div class="box-tools pull-right">

            <!-- Collapse Button -->
            <button type="button" class="btn btn-box-tool" data-widget="collapse">
                <i class="fa fa-minus"></i>
            </button>
        </div>
    </div>
    <div class="box-body">
        <div class="row">
            {!! Form::model($user, ['method' => 'PATCH','route' => ['users.updateProfile',$user->id],'enctype'=>'multipart/form-data']) !!}
                <img class="profile-user-img img-responsive img-circle" src="{{asset((isset($user) && $user->image!='')?'storage/'.$user->image:'storage/noimage.jpg')}}" alt="User profile picture">
  
                <h3 class="profile-username text-center">{{$user->name}}</h3>
  
                <p class="text-muted text-center">{{$user->tittle}}</p>
                <p class="text-muted text-center">{{$departmentName->department}}</p>
                
                
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Name:</strong>
                            {{-- {{ $user->name }} --}}
                            {!! Form::text('name', $user->name, array('class'=>'form-control input-sm')) !!}
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Email:</strong>
                            {{-- {{ $user->email }} --}}
                            {!! Form::text('email', $user->email, array('class'=>'form-control input-sm')) !!}
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Password:</strong>
                            {!! Form::password('password', array('placeholder' => 'Password','class' => 'form-control input-sm')) !!}
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Confirm Password:</strong>
                            {!! Form::password('confirm-password', array('placeholder' => 'Confirm Password','class' =>'form-control input-sm')) !!}
                        </div>
                    </div>
                    {{-- <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Department:</strong>
                            {!! Form::select('id_department', $department, null, ['placeholder'=>'Select Department','class'=>'form-control input-sm','name'=>'id_department','id'=>'id_department']) !!}
                        </div>
                    </div> 
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Section:</strong>
                            <select id='id_section' name='id_section' class="form-control input-sm">
                                <option value='0'>Select Section</option>
                                @foreach ($section as $item)
                                    <option value="{{$item->id}}" data-chained="{{$item->id_department}}" {{$user->id_section == $item->id ? 'selected':''}}>{{$item->section}}</option>
                                @endforeach
                             </select>
                        </div>
        
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Tittle:</strong>
                            {!! Form::text('tittle', $user->tittle, ['placeholder'=>'Tittle','class'=>'form-control input-sm']) !!}
                        </div>
        
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Position:</strong>
                            {!! Form::text('position', $user->position, ['placeholder'=>'Position','class'=>'form-control input-sm']) !!}
                        </div>
        
                    </div> --}}
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Date of Birth:</strong>
                            {!! Form::date('dateofbirth', $user->dateofbirth, ['class'=>'form-control input-sm']) !!}
                        </div>
        
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Office Phone:</strong>
                            {!! Form::number('office_phone', $user->office_phone, ['placeholder'=>'Office Phone','class'=>'form-control input-sm']) !!}
                        </div>
        
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Celluler Phone:</strong>
                            {!! Form::number('cell_phone', $user->cell_phone, ['plaecholder'=>'Celluler Phone','class'=>'form-control input-sm']) !!}
                        </div>
        
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <div class="form-group">
                            <strong>Region</strong>
                            {!! Form::text('region', $user->region, ['placeholder'=>'Region','class'=>'form-control input-sm']) !!}
                        </div>
                        <div class="col-xs-13 col-sm-13 col-md-13">
                            <div class="form-group">
                                <strong>Job Description:</strong>
                                {!! Form::textarea('job_description', $user->job_description, ['placeholder'=>'Job Description','class'=>'form-control input-sm']) !!}
                            </div>
        
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <strong>Profile Picture:</strong>
                        <div class="form-group">
                            <img id="preview"
                                src="{{asset((isset($user) && $user->image!='')?'storage/'.$user->image:'storage/noimage.jpg')}}"
                                height="200px" width="200px" />
                            {!! Form::file("image",["class"=>"form-control input-sm","style"=>"display:none"]) !!}
                            
                            <br />
                            <input id="image" type="file" class="form-control input-sm" name="image" >
                            
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                            <div class="form-group">
                                
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4>E-Signature</h4>
                                            <p>Sign in the canvas below and save your signature as an image!</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                             <canvas id="sig-canvas" style="height:150px">
                                                 Get a better browser, bro.
                                             </canvas>
                                         </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            
                                            <button class="btn btn-primary" id="sig-submitBtn">Submit Signature</button>
                                            <button class="btn btn-default" id="sig-clearBtn">Clear Signature</button>
            
                                        </div>
                                    </div>
                                    
                                    {{-- <div class="row">
                                        <div class="col-md-12">
                                            <textarea id="sig-dataUrl" class="form-control input-sm" rows="5">Data URL for your signature will go here!</textarea>
                                        </div>
                                    </div>
                                    <br/>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <img id="sig-image" src="" alt="Your signature will go here!"/>
                                        </div>
                                    </div> --}}
                                
                            </div>
                        </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                        <strong>Signature:</strong>
                        <div class="form-group">
                            <img id="preview" src="{{$user->sign}}" height="200px" width="200px" />
                            <textarea style="display:none;" name="sign" id="sign" cols="30" rows="10"></textarea>
                        </div>
                    </div>
                  
        </div>   
    </div>
    <div class="box-footer">
        
        <button type="submit" class="btn btn-primary pull-right">Submit</button>
    </div>
</div>
{!! Form::close() !!}
@push('script')
<script type="text/javascript">
    $(document).ready(function () {
        $("#id_section").chained("#id_department");
        // select2
        //$('#region').select2("val", null);
        $('#region').select2({
        allowClear: true,
        placeholder: 'Search...',
        ajax: {
        url: '{{url('userss/getRegion')}}',
        dataType: 'json',
        delay: 250,
        processResults: function (data) {
        return {
          results:  $.map(data, function (item) {
            return {
              text: item.province,
                id: item.province
            }
          })
        };
        },
        cache: true
         }
        });

    });

</script>
<!-- Include the Quill library -->
<script src="{{ asset('js/e-signature.js')}}"></script>
<!-- Include stylesheet -->
<link rel="stylesheet" href="{{ asset('css/e-signature.css')}}">    
@endpush
@endsection
