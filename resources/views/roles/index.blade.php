@extends('admin.admin_template')
@section('tittle','List Role')
@push('header-name')
<h1>
    Roles Management
    <small><a class="btn btn-success" href="{{ route('roles.create') }}"> Create New Roles</a></small>
    
</h1>

<ol class="breadcrumb">
<li><a href="{{url('admin')}}"><i class="fa fa-dashboard"></i> Home</a></li>
<li class="active">Roles</li>
</ol>
@endpush

@section('content')
<div class="box">
    <div class="box-header">
        {{-- <h3 class="box-tittle">Role Management
        <div class="pull-right">
            @can('role-create')
            <a class="btn btn-success" href="{{ route('roles.create') }}"> Create New Role</a>
            @endcan
        </div>
    </h3> --}}
    <div class="box-tools pull-right">

        <!-- Collapse Button -->
        <button type="button" class="btn btn-box-tool" data-widget="collapse">
            <i class="fa fa-minus"></i>
        </button>
    </div>
    <!-- /.box-tools -->
    </div>
    
    <div class="box-body" >
        <table class="table table-bordered" id="roles-table" style="width:100%">
            <thead>
                {{-- <th>No</th> --}}
                <th>Name</th>
                <th>Created at</th>
                <th>Updated at</th>
                
                <th width="280px">Action</th>
            </thead>
           
        </table>
    </div>
    <div class="box-footer">

    </div>
</div>
@push('script')
<script>
    $('#roles-table').on('click', '.btn-delete[data-remote]', function (e) { 
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
            $('#roles-table').DataTable().draw(false);
        });
    }else
        alert("You have cancelled!");
});
    $('#roles-table').DataTable({
       scrollX:true,
       processing: true,
       serverSide: true,
       ajax: '{{route('roles.dataroles')}}',
       columns: [
           
           {data: 'name', name: 'name'},
           {data: 'created_at', name: 'created_at'},
           {data: 'updated_at', name: 'updated_at'},
           {data: 'action', name: 'action', orderable: true, searchable: true}
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
