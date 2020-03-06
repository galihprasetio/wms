@extends('admin.admin_template')
@section('tittle','Dashboard')
@push('header-name')
<h1>
    Dashboard


</h1>

<ol class="breadcrumb">
    <li><a href="{{url('admin')}}"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Dashboard</li>
</ol>
@endpush
@section('content')

@push('script')
<script>
    

</script>
@endpush
@endsection
