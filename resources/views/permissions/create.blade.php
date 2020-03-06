@extends('admin.admin_template')
@section('tittle','Create Permission')

@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle">Show Permission</h3>
        <a href="{{route('permission.create')}}">Create New</a>

    </div>
    <div class="box-body">
        <div class="form-group">
            {!! Form::label('name', 'name') !!}
            {!! Form::text('name', '', ['class'=>'form-control input-sm']) !!}
        </div>
    </div>
    <div class="box-footer">
        <a href="{{route('permission.index')}}" class="btn btn-default">Back</a>
    </div>
</div>
    
@endsection