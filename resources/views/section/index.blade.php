@extends('admin.admin_template')
@section('tittle','List Section')
@push('header-name')
<h1>
        Section Management
        <small><a class="btn btn-success" href="{{ route('section.create') }}"> Create New Section</a></small>
        
    </h1>
    
    <ol class="breadcrumb">
    <li><a href="{{url('admin')}}"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Section</li>
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
    <div class="box-body">
            <table class="table table-bordered" id="section-table" style="width:100%">
                    <thead>
                        {{-- <th>No</th> --}}
                        <th>Department</th>
                        <th>Section</th>
                        <th>Created at</th>
                        <th>Updated at</th>
                        
                        <th width="280px">Action</th>
                    </thead>
                   
                </table>
    </div>
</div>
@push('script')
<script>
$('#section-table').DataTable({
       scrollX:true,
       processing: true,
       serverSide: true,
       ajax: '{{route('section.datasection')}}',
       columns: [
           
           {data: 'department', name: 'department'},
           {data: 'section', name: 'section'},
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