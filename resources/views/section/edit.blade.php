@extends('admin.admin_template')
@section('tittle','Edit Section')

@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle"> Edit Section</h3>
        <div class="box-tools pull-right">

                <!-- Collapse Button -->
                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                    <i class="fa fa-minus"></i>
                </button>
            </div>
    </div>
    @if (count($errors) > 0)
    <div class="alert alert-danger">
        <strong>Whoops!</strong> There were some problems with your input.<br><br>
        <ul>
        @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
        @endforeach
        </ul>
    </div>
@endif
    <div class="box-body">
       {!! Form::model($section, ['method'=>'PATCH','route'=> ['section.update',$section->id]]) !!}
       <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Deparment:</strong>
                    {!! Form::select('id_department',$departments,$section->id_department, ['class'=>'form-control input-sm']) !!}

                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Section:</strong>
                    {!! Form::text('section', null, ['placeholder' =>'section','class'=>'form-control input-sm']) !!}
                </div>
            </div>
        </div>
    </div>
    <div class="box-footer">
        <a href="{{route('section.index')}}" class="btn btn-default"> Back</a>
        <button type="submit" class="btn btn-primary pull-right"> Submit</button>
    </div>
</div>
    {!! Form::close() !!}
@endsection