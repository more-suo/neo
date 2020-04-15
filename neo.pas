unit neo;

interface
        
    type
        field = class
      
        private
            value: array of real;      
            iter_array: array of integer;
            
            constructor Create(value: array of real; shape: array of integer);
            
            function __get_index_generator(): function(): array of integer;
            
            function __get_item_generator(): function(): real;
            
            function __get_item(index: array of integer): real;
            
            procedure __set_item(val: real; index: array of integer);
            
            static function __get_iter_array(shape: array of integer): array of integer;
            
        public
            length: integer;
            rank: integer;
            shape: array of integer;
            
            constructor Create(array_ptr: pointer; rank: integer);
            
            constructor Create(shape: array of integer);
            
            function ToString: string; override;
    
            class function operator+(self_field: field; number: real): field;
           
            class function operator+(number: real; other_field: field): field;
           
            class function operator+(self_field, other_field:field): field;
           
            class procedure operator+=(var self_field, other_field: field);
            
            class procedure operator+=(var self_field: field; number: real);
            
            class function operator-(self_field: field): field;
                        
            class function operator-(self_field: field; number: real): field;
            
            class function operator-(number: real; self_field: field): field;
                
            class function operator-(self_field, other_field: field): field;
            
            class procedure operator-=(var self_field: field; other_field: field);
            
            class procedure operator-=(var self_field: field; number: real);
                
            class function operator*(self_field: field; number: real): field;

            class function operator*(number: real; other_field: field): field;
            
            class function operator*(self_field, other_field: field): field;
            
            class procedure operator*=(var self_field: field; const number: real);

            class procedure operator*=(var self_field: field; const other_field: field);
                
            class function operator/(self_field: field; number: real): field;
            
            class function operator/(number: real; self_field: field): field;
            
            class function operator/(self_field: field; other_field: field): field;
            
            class procedure operator/=(var self_field: field; number: real);
            
            class procedure operator/=(var self_field: field; other_field: field);

            class function operator**(self_field: field; number: real): field;
                
            class function operator**(number: real; self_field: field): field;
                
            class function operator**(self_field: field; other_field: field): field;
                
            function sum(axis: integer := -1): field;

            function get(params index: array of integer): real;
   
            procedure assign(val: real; params index: array of integer);
            
            procedure map(func: System.Func<real, real>);
            
            function max(): real;
                
            function copy(): field;
            
            function reshape(shape: array of integer): field;

            function transpose(axes: array of integer := nil): field;
            
            function dot(other_field: field; axis: integer := 0): field;
    end;

    function random_field(shape: array of integer): field;
   
    function concatenate(a,b:field; axis: integer := -1): field;
    
    function multiply(a, b: real): real;
    function multiply(a:real; b:field): field;
    function multiply(a:field; b:real): field;
    function multiply(a,b:field): field;
         
        
implementation
    
    function areEqual(a, b: array of integer): boolean;
    begin
      result := true;
      if a.length <> b.length then
        result := false
      else
        for var i := 0 to a.length-1 do
          if a[i] <> b[i] then
            begin
            result := false;
            break;
            end;
    end;
    
    
    type indexGenerator = class
      rank: integer;
      shape: array of integer;
      index: array of integer;

      function next(): array of integer;
      begin
        self.index[self.rank-1] += 1;
        for var i := self.rank-1 downto 0 do
          if self.index[i] = self.shape[i] then
            if i = 0 then
              self.index := ArrFill(self.rank, 0)
            else
              begin
              self.index[i-1] += 1;
              self.index[i] := 0;
              end;
        result := self.index;
      end;
    end;


    function field.__get_index_generator(): function(): array of integer;
    begin
      var obj := new indexGenerator;
      obj.rank := self.rank;
      obj.shape := self.shape;
      obj.index := ArrFill(self.rank, 0);
      obj.index[self.rank-1] := -1;
      result := obj.next;
    end;

    
    type itemGenerator = class
      index: integer;
      value: array of real;

      function next(): real;
      begin
        self.index += 1;
        if self.index = self.value.Length then
          self.index := 0;
        result := self.value[self.index];
      end;
    end;
    

    function field.__get_item_generator(): function(): real;
    begin
      var obj := new itemGenerator;
      obj.index := -1;
      obj.value := self.value;
      result := obj.next;
    end;
    
    
    function field.__get_item(index: array of integer): real;
    begin
      var acc := 0;
      for var i := 0 to index.Length-1 do
        acc += self.iter_array[i] * index[i];
      Result := self.value[acc];
    end;
    
    
    procedure field.__set_item(val: real; index: array of integer);
    begin
      var acc := 0;
      for var i := 0 to index.Length-1 do
        acc += self.iter_array[i] * index[i];
      self.value[acc] := val;
    end;


    static function field.__get_iter_array(shape: array of integer): array of integer;
    begin
      var rank := shape.Length;
      var iter_array := new integer[rank];
      iter_array[rank-1] := 1;
      for var index := 1 to rank-1 do
        iter_array[rank-index-1] := iter_array[rank-index] * shape[rank-index];
      result := iter_array;
    end;
    
        
    {$region Конструкторы}
    constructor field.Create(value: array of real; shape: array of integer);
    begin
      self.value := value;
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := field.__get_iter_array(shape);
    end;
    
    
    constructor field.Create(array_ptr: pointer; rank: integer);
    var tmp_ptr : ^^integer;
        shape_ptr : ^integer;
        element_ptr : ^real;
        size : ^integer;
    begin
      tmp_ptr := array_ptr;
      array_ptr := tmp_ptr^;
      
      size := pointer(integer(array_ptr)+8);

      self.length := size^;
      self.rank := rank;
      self.shape := new integer[rank];
      if rank = 1 then
        self.shape[0] := self.length
      else
        for var i := 0 to rank-1 do
          begin
          shape_ptr := pointer(integer(array_ptr) + 16 + i*4);
          self.shape[i] := shape_ptr^;
          end;
      self.iter_array := field.__get_iter_array(self.shape);

      self.value := new real[size^];
      for var i := 0 to size^-1 do
        begin
        element_ptr := pointer(integer(array_ptr) + 16 + 2*4*(rank-(rank=1?1:0)) + i*sizeof(real));
        self.value[i] := element_ptr^;
        end;
    end;
    
    
    constructor field.Create(shape: array of integer);
    begin
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := field.__get_iter_array(shape);
      self.value := new real[self.length]; 
    end;  
    
    
    // field.ToString() - Implementierung
    function field.ToString: string;
    begin
      var cnt := 0;
      result += '['*self.rank;
      var arr := new integer[self.rank];
      for var index := 0 to self.length-1 do
        begin
        if arr.Length > 1 then 
          for var i := self.rank-1 downto 0 do
            if arr[i] = self.shape[i] then
              begin
              arr[i-1] += 1;
              arr[i] := 0;
              result := result.Remove(result.Length-2, 2);
              result += '], ';
              cnt += 1;
              end;
        result += '['*cnt; cnt := 0;
        arr[self.rank-1] += 1;
        result += self.value[index]+', ';
        end;
      result := result.Remove(result.Length-2, 2);
      result += ']'*self.rank;
    end;
    {$endregion}
    
        
    {$region Арифметические операции}    
    class function field.operator+(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() + number;
      result := new field(tmp_result, self_field.shape);    
    end;
        
        
    class function field.operator+(number: real; other_field: field): field;
    begin
      Result := other_field + number;    
    end;
        
        
    class function field.operator+(self_field, other_field: field): field;
    begin
      if not areEqual(self_field.shape, other_field.shape) and (self_field.rank <> 1) and (other_field.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      var item_gen_b := other_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() + item_gen_b(); 
      Result := new field(tmp_result, self_field.shape);    
    end;
        
        
    class procedure field.operator+=(var self_field, other_field: field);
    begin
      self_field := self_field + other_field;
    end;
    
    
    class procedure field.operator+=(var self_field:field; number: real);
    begin
      self_field := self_field + number;
    end;
    
    
    class function field.operator-(self_field: field): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := -item_gen_a(); 
      Result := new field(tmp_result, self_field.shape);        
    end;
    
    
    class function field.operator-(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() - number; 
      Result := new field(tmp_result, self_field.shape);        
    end;
        
            
    class function field.operator-(number: real; self_field: field): field;
    begin
      result := -self_field + number;
    end;    


    class function field.operator-(self_field, other_field: field): field;
    begin
      if not areEqual(self_field.shape, other_field.shape) and (self_field.rank <> 1) and (other_field.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      var item_gen_b := other_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() - item_gen_b(); 
      Result := new field(tmp_result, self_field.shape);    
    end;       

    
    class procedure field.operator-=(var self_field:field; other_field: field);
    begin
      self_field := self_field - other_field;
    end;

    
    class procedure field.operator-=(var self_field: field; number: real);
    begin
      self_field := self_field - number;
    end;

        
    class function field.operator*(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() * number; 
      Result := new field(tmp_result, self_field.shape);
    end;


    class function field.operator*(number: real; other_field: field): field;
    begin
      Result := other_field * number;
    end;
                  
                  
    class function field.operator*(self_field, other_field:field): field;
    begin
      if not areEqual(self_field.shape, other_field.shape) and (self_field.rank <> 1) and (other_field.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      var item_gen_b := other_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() * item_gen_b(); 
      Result := new field(tmp_result, self_field.shape);
    end;
            
            
    class procedure field.operator*=(var self_field: field; number: real);
    begin
      self_field := self_field * number;
    end;
          
      
    class procedure field.operator*=(var self_field: field; other_field: field);
    begin
      self_field := self_field * other_field;
    end;


    class function field.operator/(self_field: field; number: real): field;
    begin
      if number = 0 then
        raise new System.ArithmeticException('ZeroDivisionError');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() / number; 
      Result := new field(tmp_result, self_field.shape);
    end;

    
    class function field.operator/(number: real; self_field: field): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := number / item_gen_a(); 
      Result := new field(tmp_result, self_field.shape);
    end;


    class function field.operator/(self_field: field; other_field: field): field;
    begin
      if not areEqual(self_field.shape, other_field.shape) and (self_field.rank <> 1) and (other_field.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      var item_gen_b := other_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() / item_gen_b(); 
      Result := new field(tmp_result, self_field.shape);  
    end;


    class procedure field.operator/=(var self_field: field; number: real);
    begin
      self_field := self_field / number;
    end;
    

    class procedure field.operator/=(var self_field: field; other_field: field);
    begin
      self_field := self_field / other_field;      
    end;


    class function field.operator**(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() ** number; 
      Result := new field(tmp_result, self_field.shape);
    end;
    
            
    class function field.operator**(number: real; self_field: field): field;
    begin
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := number ** item_gen_a(); 
      Result := new field(tmp_result, self_field.shape); 
    end;
    
    
    class function field.operator**(self_field: field; other_field: field): field;
    begin
      if not areEqual(self_field.shape, other_field.shape) and (self_field.rank <> 1) and (other_field.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      var item_gen_a := self_field.__get_item_generator();
      var item_gen_b := other_field.__get_item_generator();
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := item_gen_a() ** item_gen_b(); 
      Result := new field(tmp_result, self_field.shape);   
    end;
    {$endregion}
        

    function field.sum(axis: integer): field;
    begin
      if (self.rank = 1) or (axis = -1) then
        begin
        var tmp_result: array of real := (self.value.Sum);
        var tmp_result_shape: array of integer := (1);
        result := new field(tmp_result, tmp_result_shape);
        end
      else
      begin
        var sum_array_shape := new integer[self.rank-1]; var cnt := 0;
        for var index := 0 to self.rank-1 do
          if index <> axis then
            begin
            sum_array_shape[cnt] := self.shape[index];
            cnt += 1;
            end
          else  
            continue;
            
        var sum_arr := new real[sum_array_shape.Product];
        var sum_iter_array := field.__get_iter_array(sum_array_shape);

        var index_gen := self.__get_index_generator();
        var item_gen := self.__get_item_generator();
        for var i := 0 to self.length-1 do
          begin 
          var arr := index_gen();
           
          var new_arr := new integer[self.rank-1]; var sum_cnt := 0;
          for var j := 0 to self.rank-1 do
            if j = axis then
              continue
            else
             begin
              new_arr[sum_cnt] := arr[j];
              sum_cnt += 1;
              end;
              
          var sum_acc := 0;
          for var j := 0 to self.rank-2 do
            sum_acc += sum_iter_array[j] * new_arr[j];
          sum_arr[sum_acc] += item_gen();
          end;
      result := new field(sum_arr, sum_array_shape);
      end;
    end;

      
    function field.get(params index: array of integer): real;
    begin
      result := self.__get_item(index);
    end;
    
    
    procedure field.assign(val: real; params index: array of integer);
    begin
      self.__set_item(val, index);
    end;
    
    
    procedure field.map(func: System.Func<real, real>);
    begin
      var item_gen := self.__get_item_generator();
      for var i := 0 to self.length-1 do
        self.value[i] := func(item_gen()); 
    end;
    
    
    // TODO: Нахождение максимальных элементов по осям
    function field.max(): real;
    begin
      var tmp_result := 0.0;
      var item_gen := self.__get_item_generator();
      for var i := 0 to self.length-1 do
        tmp_result += item_gen();  
      result := tmp_result;
    end;

    
    function field.copy(): field;
    begin
      Result := new field(self.value, self.shape);
    end;


    function field.reshape(shape: array of integer): field;
    begin
      Result := new field(self.value, shape);
    end;
   
   
    function field.transpose(axes: array of integer): field;
    begin
      if axes = nil then
        begin
        axes := new integer[self.rank];
        for var index := 0 to self.rank-1 do
          axes[index] := self.rank-index-1;
        end;
      
      var tmp_value := new real[self.length];
      var tmp_shape := new integer[self.rank];
      for var index := 0 to self.rank-1 do
        tmp_shape[index] := self.shape[axes[index]];
      
      var tmp_iter_array := field.__get_iter_array(tmp_shape);
      var index_gen := self.__get_index_generator();
      var item_gen := self.__get_item_generator();
      
      for var i := 0 to self.length-1 do
        begin
        var arr := index_gen();
        
        var new_arr := new integer[self.rank];
        for var j := 0 to self.rank-1 do
          new_arr[j] := arr[axes[j]];
        
        var acc := 0;
        for var j := 0 to self.rank-1 do
          acc += tmp_iter_array[j] * new_arr[j];
        tmp_value[acc] := item_gen();
        end;
      result := new field(tmp_value, tmp_shape);
    end;  
   
   
    function field.dot(other_field: field; axis: integer): field;
    begin
      if (self.rank = 1) and (other_field.rank = 1) then
        begin
        var sum: array of real := (0);
        for var index := 0 to self.length-1 do
          sum[0] += self.get(index) * other_field.get(index);
        result := new field(sum, ArrFill(1, 1));
        end
      else if (self.rank = 1) or (other_field.rank = 1) then
      begin
        if self.shape[0] <> other_field.shape[0] then
          raise new Exception('Fields couldn not be broadcast together');
        
        var max_field: field;
        var min_field: field;
        if self.rank > other_field.rank then
          begin
          max_field := self;
          min_field := other_field;
          end
        else
          begin
          max_field := other_field;
          min_field := self;
          end;
        
        var tmp_shape := new integer[max_field.rank-1];
        for var i := 1 to max_field.rank-1 do
          tmp_shape[i-1] := max_field.shape[i]; 
        
        var tmp_arr := new real[tmp_shape.Product];

        var max_index_gen := max_field.__get_index_generator();
        var max_item_gen := max_field.__get_item_generator();
        
        var cnt_limit := max_field.length div max_field.shape[0]; var cnt := 0;
        for var i := 0 to max_field.length-1 do
        begin
          tmp_arr[cnt] += max_item_gen() * min_field.value[max_index_gen()[0]];
          cnt += 1;
          if cnt = cnt_limit then
            cnt := 0;
        end;
        result := new field(tmp_arr, tmp_shape);
        end
      else if (self.rank = 2) and (other_field.rank = 2) then
        begin
          var other_field_T := other_field.transpose();
          var tmp_result := new real[self.shape[0]*other_field.shape[1]];
          var new_shape: array of integer := (self.shape[0], other_field.shape[1]);
          for var i:=0 to self.shape[0]-1 do
            for var j:=0 to other_field.shape[1]-1 do
            begin  
              var cc := 0.0;
              for var l:=0 to self.shape[1]-1 do
                 cc += self.get(i, l)*other_field_T.get(j, l);
              tmp_result[i*self.shape[0]+j] := cc;   
            end;
          result := new field(tmp_result, new_shape);
        end;
    end;
 
   
    function random_field(shape: array of integer): field;
    begin
      var tmp_result := new real[shape.Product];
      for var index := 0 to shape.Product-1 do
        tmp_result[index] := random;
      Result := new field(tmp_result, shape);   
    end;
 

    function concatenate(a, b: field; axis: integer): field;
    begin
      if axis = -1 then
      begin
        var tmp_shape: array of integer := (a.length+b.length-1); 
        var tmp_field := new real[a.length+b.length-1];
        var item_gen_a := a.__get_item_generator();
        var item_gen_b := b.__get_item_generator();
        
        for var index := 0 to a.length-1 do
          tmp_field[index] := item_gen_a();
        for var index := a.length to a.length+b.length-1 do
          tmp_field[index] := item_gen_b();
        
        Result := new field(tmp_field, tmp_shape);
        end
      else
        begin
        if a.shape[axis] <> b.shape[axis] then
          raise new Exception('Fields couldn not be broadcast together');
        
        var tmp_shape := new integer[a.rank];
        for var index := 0 to a.rank-1 do
          begin
          tmp_shape[index] := a.shape[index];
          if index = axis then
            tmp_shape[index] += b.shape[axis];
          end;
          
        var tmp_field := new field(tmp_shape);
        var item_gen_a := a.__get_item_generator();
        var item_gen_b := b.__get_item_generator();
        var index_gen_c := tmp_field.__get_index_generator();
        
        for var index := 0 to a.length+b.length-2 do
          begin
          var arr := index_gen_c();
          
          while arr[axis] > a.shape[axis]-1 do
            begin
            tmp_field.assign(item_gen_b(), arr);  
            arr := index_gen_c();
            end;
          
          tmp_field.assign(item_gen_a(), arr);
          end;
        Result := tmp_field;
        end;
    end;
        
        
    function multiply(a, b: real): real;
    begin
      Result := a * b;
    end;
    

    function multiply(a: real; b: field): field;
    begin
      Result := b * a;
    end;
        

    function multiply(a: field; b: real): field;
    begin
      Result := a * b;
    end;


    function multiply(a, b: field): field;
    var 
      max_len: integer;
      max_shape: array of integer;
    begin
      if a.length > b.length then
        begin
        max_len := a.length;
        max_shape := a.shape;
        end
      else
        begin
        max_len := b.length;
        max_shape := b.shape;  
        end;
      
      var item_gen_a := a.__get_item_generator();
      var item_gen_b := b.__get_item_generator();
        
      var tmp_result := new real[max_len];  
      for var index := 0 to max_len-1 do
        tmp_result[index] := item_gen_a() * item_gen_b();
      result := new field(tmp_result, max_shape);
    end;
end.