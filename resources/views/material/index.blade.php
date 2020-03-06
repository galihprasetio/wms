@extends('admin.admin_template')
@section('tittle','List Material')
@push('header-name')
<h1>
    Material Management
    <small><a class="btn btn-success" href="{{ route('material.create') }}"> Create New Material</a></small>

</h1>

<ol class="breadcrumb">
    <li><a href="{{url('admin')}}"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Material</li>
</ol>
@endpush


@section('content')
<div class="box">
    <div class="box-header">


        <div class="box-tools pull-right">

            <!-- Collapse Button -->
            <button type="button" class="btn btn-box-tool" data-widget="collapse">
                <i class="fa fa-minus"></i>
            </button>
        </div>
        <!-- /.box-tools -->
    </div>
    <!-- /.box-header -->
    <div class="box-body">
        {{-- @if ($message = Session::get('success'))
        <div class="alert alert-success">
            <p>{{ $message }}</p>
    </div>
    @endif --}}


    <table id="material-table" class="table table-striped table-bordered" style="width:100%">
        <thead>
            <tr>
                <th>Material Code</th>
                <th>Description</th>
                <th>Spec</th>
                <th>Unit</th>
                <th>Remark</th>
                <th>Created at</th>
                <th>Updated at</th>
                <th>Action</th>
            </tr>
        </thead>
    </table>



    {{-- {!! $data->render() !!} --}}

</div>
<!-- /.box-body -->
</div>
@push('script')

<script>
    $('#material-table').on('click', '.btn-delete[data-remote]', function (e) { 
    e.preventDefault();
     $.ajaxSetup({
        headers: {
            'XSRF-TOKEN': $('meta[name="xsrf-token"]').attr('content')
        }
    });
    var url = $(this).data('remote');
    // confirm then
    if (confirm('Are you sure you want to delete this?')) {
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            data: {method: '_GET', submit: true}
        }).always(function (data) {
            $('#material-table').DataTable().draw(false);
        });
    }
    
    });
     
    $('#material-table').DataTable({
        scrollX:true,
        processing: true,
        serverSide: true,
        responsive: true,
        select: true,
        ajax: "{{ route('material.datamaterial') }}",
        columns: [
            {
                data: 'item_code',
                name: 'item_code'
            },
            {
                data: 'name',
                name: 'name'
            },
            {
                data: "spec",
                name: "spec"                
            },
            {
                data: 'unit',
                name: 'unit'
            },
            {
                data: 'remark',
                name: 'remark'
            },
            {
                data: 'created_at',
                name: 'created_at'
            },
            {
                data: 'updated_at',
                name: 'created_at'
            },
            {
                data: 'action',
                name: 'action',
                orderable: false,
                searchable: false
            }
        ],
        "bStateSave": true,
        "fnStateSave": function (oSettings, oData) {
        localStorage.setItem('offersDataTables', JSON.stringify(oData));
        },
        "fnStateLoad": function (oSettings) {
        return JSON.parse(localStorage.getItem('offersDataTables'));
        }
    });

</script>
@endpush
@endsection



