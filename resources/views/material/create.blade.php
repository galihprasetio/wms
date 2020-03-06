@extends('admin.admin_template')
@section('tittle','Create Material')
@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle">Create New Material</h3>
        <div class="box-tools pull-right">

                <!-- Collapse Button -->
                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                    <i class="fa fa-minus"></i>
                </button>
            </div>
    </div>
    {{-- @if (count($errors) > 0)
    <div class="alert alert-danger">
        <strong>Whoops!</strong> There were some problems with your input.<br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
    @endif --}}
    <div class="box-body">
        {!! Form::open(array('route'=>'material.store','method'=>'POST')) !!}
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Item Code:</strong>
                    {!! Form::text('item_code', null, array('placeholder'=>'Item Code','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                    <strong>Item Name:</strong>
                    {!! Form::text('item_name', null, array('placeholder'=>'Item Name','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                    <strong>Spesification:</strong>
                    {!! Form::text('spec', null, array('placeholder'=>'Spesification','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                   <strong>Unit:</strong>
                    {!! Form::text('unit', null, array('placeholder'=>'Unit','class'=>'form-control input-sm')) !!}
                    <span class="form-group">
                      <button type="button" class="btn btn-success btn-sm" style="margin-top:5px;">Add Unit</button>
                    </span>
                </div>
                {{-- <strong>Unit</strong>
                <div class="input-group margin">
                <input type="text" class="form-control">
                    <span class="input-group-btn">
                      <button type="button" class="btn btn-info btn-flat" style="margin-left:-5px;">Add Unit</button>
                    </span>
              </div> --}}
                <div class="form-group">
                    <strong>Remark:</strong>
                    {!! Form::text('remark', null, array('placeholder'=>'Remark','class'=>'form-control input-sm')) !!}
                </div>
            </div>
        </div>
    </div>
    <div class="box-footer">
        <a href="{{ route('department.index')}}" class="btn btn-default"> Back</a>
        <button type="submit" class="btn btn-primary pull-right"> Submit</button>
    </div>
</div>
{!! Form::close() !!}
@endsection