@extends('admin.admin_template')
@section('tittle','List User')
@push('header-name')
<h1>
    User Management
    <small><a class="btn btn-success" href="{{ route('users.create') }}"> Create New User</a></small>

</h1>

<ol class="breadcrumb">
    <li><a href="{{url('admin')}}"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Users</li>
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


    <table id="users-table" class="table table-striped table-bordered" style="width:100%">
        <thead>
            <tr>
                {{-- <th>Id</th> --}}
                <th>Name</th>
                <th>Email</th>
                <th>Image</th>
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
    $('#users-table').on('click', '.btn-delete[data-remote]', function (e) { 
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
            $('#users-table').DataTable().draw(false);
        });
    }
    
    });
     
    $('#users-table').DataTable({
        scrollX:true,
        processing: true,
        serverSide: true,
        responsive: true,
        select: true,
        ajax: "{{ route('users.datauser') }}",
        columns: [
            {
                data: 'name',
                name: 'name'
            },
            {
                data: 'email',
                name: 'email'
            },
            {
                data: "image",
                name: "image",
                type: "image",
                render: function (data, type, full, meta) {
                return "<img src=\"storage/"+data+"\" height=\"50\"/>";
            }
            },
            {
                data: 'created_at',
                name: 'created_at'
            },
            {
                data: 'updated_at',
                name: 'updated_at'
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


{{-- @extends('admin.admin_template')
+'/'+


@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle">Users Management
            <div class="pull-right">
                <a class="btn btn-success" href="{{ route('users.create') }}"> Create New User</a>
</div>
</h3>

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
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ $message }}</p>
    </div>
    @endif


    <table class="table table-bordered" id="table-data">
        <tr>
            <th>No</th>
            <th>Name</th>
            <th>Email</th>
            <th>Roles</th>
            <th width="280px">Action</th>
        </tr>
        @foreach ($data as $key => $user)
        <tr>
            <td>{{ ++$i }}</td>
            <td>{{ $user->name }}</td>
            <td>{{ $user->email }}</td>
            <td>
                @if(!empty($user->getRoleNames()))
                @foreach($user->getRoleNames() as $v)
                <label class="badge badge-success">{{ $v }}</label>
                @endforeach
                @endif
            </td>
            <td>
                <a class="btn btn-info" href="{{ route('users.show',$user->id) }}">Show</a>
                <a class="btn btn-primary" href="{{ route('users.edit',$user->id) }}">Edit</a>
                {!! Form::open(['method' => 'DELETE','route' => ['users.destroy',
                $user->id],'style'=>'display:inline']) !!}
                {!! Form::submit('Delete', ['class' => 'btn btn-danger']) !!}
                {!! Form::close() !!}
            </td>
        </tr>
        @endforeach
    </table>


    {!! $data->render() !!}

</div>
<!-- /.box-body -->
</div>

@endsection
<script>
    $('#table-data').DataTable({
        'paging': true,
        'lengthChange': false,
        'searching': false,
        'ordering': true,
        'info': true,
        'autoWidth': false
    })

</script> --}}
