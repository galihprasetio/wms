@extends('admin.admin_template')
@section('tittle','Edit Material')

@section('content')
<div class="box">
    <div class="box-header">
    <h3 class="box-tittle"> Edit Material</h3>
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
        {!! Form::model($material,['method' => 'PATCH','route' =>['material.update',$material->id]]) !!}
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Item Code:</strong>
                    {!! Form::text('item_code', null, array('Placeholder' => 'Item Code','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                    <strong>Item Name:</strong>
                    {!! Form::text('name', null, array('Placeholder' => 'Item Name','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                    <strong>Spesification:</strong>
                    {!! Form::text('spec', null, array('Placeholder' => 'Spesification','class'=>'form-control input-sm')) !!}
                </div>
                <div class="form-group">
                    <strong>Remark:</strong>
                    {!! Form::text('remark', null, array('Placeholder' => 'Remark','class'=>'form-control input-sm')) !!}
                </div>
                
            </div>
        </div>
    </div>
    <div class="box-footer">
        <a href="{{route('material.index')}}" class="btn btn-default"> Back</a>
        <button type="submit" class="btn btn-primary pull-right"> Submit</button>
    </div>
</div>
{!! Form::close() !!}
@endsection
