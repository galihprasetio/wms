@extends('admin.admin_template')
@section('tittle','Detail Section')
@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle"> Detail Section</h3>
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
                    <strong>Deparment:</strong>
                    {!! Form::select('id_department',$departments,$section->id_department, ['class'=>'form-control','disabled'=>'true']) !!}

                </div>

            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Section:</strong>
                    {!! Form::text('section', $section->section, ['placeholder' =>'section','class'=>'form-control','disabled' => 'true']) !!}
                </div>
            </div>
        </div>
    </div>

    <div class="box-footer">
        <a href="{{route('section.index')}}" class="btn btn-default"> Back</a>

    </div>
</div>

@endsection
