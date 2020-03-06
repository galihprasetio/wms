@extends('admin.admin_template')
@section('tittle','List Permission')
@section('content')
<div class="box">
    <div class="box-header">
        <h3 class="box-tittle">Permission Management</h3>
        <div class="pull-right">
            <a class="btn btn-success" href="{{ route('permission.create') }}"> Create New Permission</a>
        </div>

        <div class="box-tools pull-right">

            <!-- Collapse Button -->
            <button type="button" class="btn btn-box-tool" data-widget="collapse">
                <i class="fa fa-minus"></i>
            </button>
        </div>
    </div>
    <div class="box-body">
        @if ($message = Session::get('success'))
        <div class="alert alert-success">
            <p>{{ $message }}</p>
        </div>
        @endif
        <table class="table table-bordered">
            <tr>
                <th>No</th>
                <th>Name</th>
                <th>Guard</th>
                <th width="280px">Action</th>
            </tr>
            @foreach ($permission as $key => $permission)
            <tr>
                <td>{{ ++$i }}</td>
                <td>{{ $permission->name }}</td>
                <td>{{ $permission->guard_name}}</td>
                <td>
                    {{-- <a class="btn btn-info" href="{{ route('roles.show',$role->id) }}">Show</a>
                    @can('role-edit')
                    <a class="btn btn-primary" href="{{ route('roles.edit',$role->id) }}">Edit</a>
                    @endcan
                    @can('role-delete')
                    {!! Form::open(['method' => 'DELETE','route' => ['roles.destroy',
                    $role->id],'style'=>'display:inline']) !!}
                    {!! Form::submit('Delete', ['class' => 'btn btn-danger']) !!}
                    {!! Form::close() !!}
                    @endcan --}}
                </td>
            </tr>
            @endforeach
        </table>
    </div>
    <div class="box-footer">

    </div>
</div>

@endsection
