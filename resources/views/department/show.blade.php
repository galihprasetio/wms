@extends('admin.admin_template')
@section('tittle','Detail Department')
@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle">Show Department</h3>
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
                    <strong>Department:</strong>
                    {{-- {{$department->department}} --}}
                    {!! Form::text('department', $department->department, array('class'=>'form-control','readonly')) !!}
                </div>
            </div>
        </div>
    </div>
    <div class="box-footer">
        <a href="{{route('department.index')}}" class="btn btn-default"> Back</a>
        
    </div>
</div>
    
@endsection