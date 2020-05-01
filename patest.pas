unit patest;

var out_buff: List<string>;


function _get_fail_msg(msg: string): string;
begin
  var stackTrace := new System.Diagnostics.StackTrace;
  result := format('FAIL: {0} ({1}) '#10'    AssertionError: {2}', 
                   stackTrace.GetFrame(2).GetMethod.Name, 
                   stackTrace.GetFrame(2).GetMethod.DeclaringType, 
                   msg);
end;


type TestCase = class
  procedure assertEqual<T>(a, b: T);
  where T: System.IEquatable<T>;
  begin
    if a = b then
      begin
      write('.');
      end
    else
      begin
      write('F');
      var msg := format('{0} <> {1}' , a, b);
      out_buff.Add(_get_fail_msg(msg));
      end;
  end;
    
  procedure assertNotEqual<T>(a, b: T);
  begin
    if a <> b then
      begin
      write('.');
      end
    else
      begin
      write('F');
      var msg := format('{0} = {1}', a, b);
      out_buff.Add(_get_fail_msg(msg));
      end;
  end;

  procedure assertTrue<T>(a: T);
  begin
    try 
      begin
      var bool_a := System.Convert.ToBoolean(a);
      if Bool_a then
        begin
        write('.');
        end
      else
        begin
        write('F');
        var msg := 'Condition is not true';
        out_buff.Add(_get_fail_msg(msg));
        end;
      end;
    except
      on Exception do
        begin
        write('F');
        var msg := format('Параметр ({0}) не распознан как логическое значение', a);
        out_buff.Add(_get_fail_msg(msg));
        end;
    end;    
  end;

  procedure assertFalse<T>(a: T);
  begin
    try 
      begin
      var bool_a := System.Convert.ToBoolean(a);
      if Bool_a then
        begin
        write('.');
        end
      else
        begin
        write('F');
        var msg := 'Condition is not false';
        out_buff.Add(_get_fail_msg(msg));
        end;
      end;
    except
      on Exception do
        begin
        write('F');
        var msg := format('Параметр ({0}) не распознан как логическое значение', a);
        out_buff.Add(_get_fail_msg(msg));
        end;
    end;
  end;
    
  procedure assertRaises<TException>(func: System.Action);
  where TException: System.Exception;
  begin
    try 
      begin
      func();
      write('F');
      var msg := format('Исключение {0} не было вызвано', typeof(TException));
      out_buff.Add(_get_fail_msg(msg));
      end;
    except
      on e: TException do
        write('.');
      on e: System.Exception do
        begin
        write('F');
        var msg := format('Было вызвано стороннее исключение {0} (не {1})', e.GetType, typeof(TException));
        out_buff.Add(_get_fail_msg(msg));
        end
    end;
  end;
end;


procedure main();
begin
  var subClassList := typeof(TestCase).Assembly.GetTypes().Where(t -> t.isSubClassof(typeof(TestCase)));
            
  foreach var subClass in subClassList do
    begin
    var subClassObj := System.Activator.CreateInstance(subClass);
    
    var time := Milliseconds;
    
    var setUp := subClass.GetMethods.Find(x -> x.Name.ToLower = 'setup'); 
    if setUp <> nil then setUp.Invoke(subClassObj, nil);
    
    var methods := subClass.GetMethods.Where(m -> m.Name.StartsWith('test'));
    foreach var method in methods do
      method.Invoke(subClassObj, nil);
      
    var tearDown := subClass.GetMethods.Find(x -> x.Name.ToLower = 'teardown');
    if tearDown <> nil then tearDown.Invoke(subClassObj, nil);
    
    writeln;
    writeln('='*80);
    foreach var fail in out_buff do
      writeln(fail);
    writeln('-'*80);
    writeln(format('Ran {0} test in {1}s', methods.ToArray.Length, (Milliseconds-time)/1000));
    end;
  
end;


begin
  out_buff := new List<string>;
end.
