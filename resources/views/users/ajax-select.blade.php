<option>--- Select Section ---</option>
@if(!empty($section))
  @foreach($section as $key => $value)
    <option value="{{ $key }}">{{ $value }}</option>
  @endforeach
@endif