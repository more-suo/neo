unit neo;

interface
        
    type
        ndarray = class
      
        private
            value: array of real;      
            iter_array: array of integer;
            shape: array of integer;
            length: integer;
            rank: integer;
            
            constructor Create(value: array of real; shape: array of integer);
            
            function __get_index_generator(): function(): array of integer;
            
            function __get_item_generator(): function(): real;
            
            function __get_item(index: array of integer): real;
            
            procedure __set_item(val: real; index: array of integer);
            
            static function __get_iter_array(shape: array of integer): array of integer;
            
        public            
            constructor Create(array_ptr: pointer; rank: integer);
            
            constructor Create(shape: array of integer);
            
            function ToString: string; override;
    
            class function operator+(self_ndarray: ndarray; number: real): ndarray;
           
            class function operator+(number: real; other_ndarray: ndarray): ndarray;
           
            class function operator+(self_ndarray, other_ndarray:ndarray): ndarray;
           
            class procedure operator+=(var self_ndarray, other_ndarray: ndarray);
            
            class procedure operator+=(var self_ndarray: ndarray; number: real);
            
            class function operator-(self_ndarray: ndarray): ndarray;
                        
            class function operator-(self_ndarray: ndarray; number: real): ndarray;
            
            class function operator-(number: real; self_ndarray: ndarray): ndarray;
                
            class function operator-(self_ndarray, other_ndarray: ndarray): ndarray;
            
            class procedure operator-=(var self_ndarray: ndarray; other_ndarray: ndarray);
            
            class procedure operator-=(var self_ndarray: ndarray; number: real);
                
            class function operator*(self_ndarray: ndarray; number: real): ndarray;

            class function operator*(number: real; other_ndarray: ndarray): ndarray;
            
            class function operator*(self_ndarray, other_ndarray: ndarray): ndarray;
            
            class procedure operator*=(var self_ndarray: ndarray; const number: real);

            class procedure operator*=(var self_ndarray: ndarray; const other_ndarray: ndarray);
                
            class function operator/(self_ndarray: ndarray; number: real): ndarray;
            
            class function operator/(number: real; self_ndarray: ndarray): ndarray;
            
            class function operator/(self_ndarray: ndarray; other_ndarray: ndarray): ndarray;
            
            class procedure operator/=(var self_ndarray: ndarray; number: real);
            
            class procedure operator/=(var self_ndarray: ndarray; other_ndarray: ndarray);

            class function operator**(self_ndarray: ndarray; number: real): ndarray;
                
            class function operator**(number: real; self_ndarray: ndarray): ndarray;
                
            class function operator**(self_ndarray: ndarray; other_ndarray: ndarray): ndarray;
                
            function get(params index: array of integer): real;
   
            procedure assign(val: real; params index: array of integer);
            
            function get_shape(): array of integer;
            
            function copy(): ndarray;
            
            function dot(other_ndarray: ndarray; axis: integer := 0): ndarray;
            
            procedure map(func: System.Func<real, real>);
            
            function max(): real;
            
            function reshape(shape: array of integer): ndarray;
            
            function sum(axis: integer := -1): ndarray;

            function transpose(axes: array of integer := nil): ndarray;
    end;
   
    function arange(stop: integer): ndarray;
    
    function arange(start, stop: integer): ndarray;
    
    function arange(start, stop, step: integer): ndarray;
   
    function concatenate(a,b:ndarray; axis: integer := -1): ndarray;
   
    function copy(self: ndarray): ndarray;
   
    function dot(self_ndarray: ndarray; other_ndarray: ndarray; axis: integer := 0): ndarray;
   
    procedure map(self: ndarray; func: System.Func<real, real>);
    
    function max(self: ndarray): real;
    
    function multiply(a, b: real): real;
    function multiply(a:real; b:ndarray): ndarray;
    function multiply(a:ndarray; b:real): ndarray;
    function multiply(a,b:ndarray): ndarray;
    
    function random_ndarray(shape: array of integer): ndarray;
         
    function reshape(self: ndarray; shape: array of integer): ndarray;
         
    function sum(self: ndarray; axis: integer := -1): ndarray;
         
    function transpose(self: ndarray; axes: array of integer := nil): ndarray;
         
        
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


    function ndarray.__get_index_generator(): function(): array of integer;
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
    

    function ndarray.__get_item_generator(): function(): real;
    begin
      var obj := new itemGenerator;
      obj.index := -1;
      obj.value := self.value;
      result := obj.next;
    end;
    
    
    function ndarray.__get_item(index: array of integer): real;
    begin
      var acc := 0;
      for var i := 0 to index.Length-1 do
        acc += self.iter_array[i] * index[i];
      Result := self.value[acc];
    end;
    
    
    procedure ndarray.__set_item(val: real; index: array of integer);
    begin
      var acc := 0;
      for var i := 0 to index.Length-1 do
        acc += self.iter_array[i] * index[i];
      self.value[acc] := val;
    end;


    static function ndarray.__get_iter_array(shape: array of integer): array of integer;
    begin
      var rank := shape.Length;
      var iter_array := new integer[rank];
      iter_array[rank-1] := 1;
      for var index := 1 to rank-1 do
        iter_array[rank-index-1] := iter_array[rank-index] * shape[rank-index];
      result := iter_array;
    end;
    
        
    {$region Конструкторы}
    constructor ndarray.Create(value: array of real; shape: array of integer);
    begin
      self.value := value;
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := ndarray.__get_iter_array(shape);
    end;
    
    
    constructor ndarray.Create(array_ptr: pointer; rank: integer);
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
      self.iter_array := ndarray.__get_iter_array(self.shape);

      self.value := new real[size^];
      for var i := 0 to size^-1 do
        begin
        element_ptr := pointer(integer(array_ptr) + 16 + 2*4*(rank-(rank=1?1:0)) + i*sizeof(real));
        self.value[i] := element_ptr^;
        end;
    end;
    
    
    constructor ndarray.Create(shape: array of integer);
    begin
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := ndarray.__get_iter_array(shape);
      self.value := new real[self.length]; 
    end;  
    
    
    // ndarray.ToString() - Implementierung
    function ndarray.ToString: string;
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
    class function ndarray.operator+(self_ndarray: ndarray; number: real): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() + number;
      result := new ndarray(tmp_result, self_ndarray.shape);    
    end;
        
        
    class function ndarray.operator+(number: real; other_ndarray: ndarray): ndarray;
    begin
      Result := other_ndarray + number;    
    end;
        
        
    class function ndarray.operator+(self_ndarray, other_ndarray: ndarray): ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      var item_gen_b := other_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() + item_gen_b(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);    
    end;
        
        
    class procedure ndarray.operator+=(var self_ndarray, other_ndarray: ndarray);
    begin
      self_ndarray := self_ndarray + other_ndarray;
    end;
    
    
    class procedure ndarray.operator+=(var self_ndarray:ndarray; number: real);
    begin
      self_ndarray := self_ndarray + number;
    end;
    
    
    class function ndarray.operator-(self_ndarray: ndarray): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := -item_gen_a(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);        
    end;
    
    
    class function ndarray.operator-(self_ndarray: ndarray; number: real): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() - number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);        
    end;
        
            
    class function ndarray.operator-(number: real; self_ndarray: ndarray): ndarray;
    begin
      result := -self_ndarray + number;
    end;    


    class function ndarray.operator-(self_ndarray, other_ndarray: ndarray): ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      var item_gen_b := other_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() - item_gen_b(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);    
    end;       

    
    class procedure ndarray.operator-=(var self_ndarray:ndarray; other_ndarray: ndarray);
    begin
      self_ndarray := self_ndarray - other_ndarray;
    end;

    
    class procedure ndarray.operator-=(var self_ndarray: ndarray; number: real);
    begin
      self_ndarray := self_ndarray - number;
    end;

        
    class function ndarray.operator*(self_ndarray: ndarray; number: real): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() * number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;


    class function ndarray.operator*(number: real; other_ndarray: ndarray): ndarray;
    begin
      Result := other_ndarray * number;
    end;
                  
                  
    class function ndarray.operator*(self_ndarray, other_ndarray:ndarray): ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      var item_gen_b := other_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() * item_gen_b(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;
            
            
    class procedure ndarray.operator*=(var self_ndarray: ndarray; number: real);
    begin
      self_ndarray := self_ndarray * number;
    end;
          
      
    class procedure ndarray.operator*=(var self_ndarray: ndarray; other_ndarray: ndarray);
    begin
      self_ndarray := self_ndarray * other_ndarray;
    end;


    class function ndarray.operator/(self_ndarray: ndarray; number: real): ndarray;
    begin
      if number = 0 then
        raise new System.ArithmeticException('ZeroDivisionError');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() / number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;

    
    class function ndarray.operator/(number: real; self_ndarray: ndarray): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := number / item_gen_a(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;


    class function ndarray.operator/(self_ndarray: ndarray; other_ndarray: ndarray): ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      var item_gen_b := other_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() / item_gen_b(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);  
    end;


    class procedure ndarray.operator/=(var self_ndarray: ndarray; number: real);
    begin
      self_ndarray := self_ndarray / number;
    end;
    

    class procedure ndarray.operator/=(var self_ndarray: ndarray; other_ndarray: ndarray);
    begin
      self_ndarray := self_ndarray / other_ndarray;      
    end;


    class function ndarray.operator**(self_ndarray: ndarray; number: real): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() ** number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;
    
            
    class function ndarray.operator**(number: real; self_ndarray: ndarray): ndarray;
    begin
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := number ** item_gen_a(); 
      Result := new ndarray(tmp_result, self_ndarray.shape); 
    end;
    
    
    class function ndarray.operator**(self_ndarray: ndarray; other_ndarray: ndarray): ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_ndarray.length];
      var item_gen_a := self_ndarray.__get_item_generator();
      var item_gen_b := other_ndarray.__get_item_generator();
      for var index := 0 to self_ndarray.length-1 do
        tmp_result[index] := item_gen_a() ** item_gen_b(); 
      Result := new ndarray(tmp_result, self_ndarray.shape);   
    end;
    {$endregion}
        

    function ndarray.sum(axis: integer): ndarray;
    begin
      result := neo.sum(self, axis);
    end;

      
    function ndarray.get(params index: array of integer): real;
    begin
      result := self.__get_item(index);
    end;
    
    
    procedure ndarray.assign(val: real; params index: array of integer);
    begin
      self.__set_item(val, index);
    end;
    
    
    function ndarray.get_shape(): array of integer;
    begin
      result := self.shape;  
    end;
    
    
    procedure ndarray.map(func: System.Func<real, real>);
    begin
      neo.map(self, func);
    end;
    
    
    function ndarray.max(): real;
    begin
      result := neo.max(self);
    end;

    
    function ndarray.copy(): ndarray;
    begin
      result := neo.copy(self);
    end;


    function ndarray.reshape(shape: array of integer): ndarray;
    begin
      result := neo.reshape(self, shape);
    end;
   
   
    function ndarray.transpose(axes: array of integer): ndarray;
    begin
      result := neo.transpose(self, axes);
    end;  
   
   
    function ndarray.dot(other_ndarray: ndarray; axis: integer): ndarray;
    begin
      result := neo.dot(self, other_ndarray, axis);
    end;
 
     
    function random_ndarray(shape: array of integer): ndarray;
    begin
      var tmp_result := new real[shape.Product];
      for var index := 0 to shape.Product-1 do
        tmp_result[index] := random;
      Result := new ndarray(tmp_result, shape);   
    end;
 
 
    function arange(stop: integer): ndarray;
    begin
      var tmp_result := new real[stop];
      var tmp_shape: array of integer := (stop);
      for var i := 0 to stop-1 do
        tmp_result[i] := i;
      result := new ndarray(tmp_result, tmp_shape);
    end;
    
    
    function arange(start, stop: integer): ndarray;
    begin
      var tmp_result := new real[stop-start];
      var tmp_shape: array of integer := (stop-start);
      for var i := start to stop-1 do
        tmp_result[i-start] := i;
      result := new ndarray(tmp_result, tmp_shape);  
    end;
    
    
    function arange(start, stop, step: integer): ndarray;
    begin
      var tmp_result := new real[(stop-start) div step];
      var tmp_shape: array of integer := ((stop-start) div step);
      var i := start-1; var cnt := 0; 
      if step < 0 then
        while i > stop do
          begin
          tmp_result[cnt] := i;
          cnt += 1;
          i += step;
          end
      else
        while i < stop do
          begin
          tmp_result[cnt] := i;
          cnt += 1;
          i += step;
          end;
      result := new ndarray(tmp_result, tmp_shape);  
    end;


    function concatenate(a, b: ndarray; axis: integer): ndarray;
    begin
      if axis = -1 then
      begin
        var tmp_shape: array of integer := (a.length+b.length-1); 
        var tmp_ndarray := new real[a.length+b.length-1];
        var item_gen_a := a.__get_item_generator();
        var item_gen_b := b.__get_item_generator();
        
        for var index := 0 to a.length-1 do
          tmp_ndarray[index] := item_gen_a();
        for var index := a.length to a.length+b.length-1 do
          tmp_ndarray[index] := item_gen_b();
        
        Result := new ndarray(tmp_ndarray, tmp_shape);
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
          
        var tmp_ndarray := new ndarray(tmp_shape);
        var item_gen_a := a.__get_item_generator();
        var item_gen_b := b.__get_item_generator();
        var index_gen_c := tmp_ndarray.__get_index_generator();
        
        for var index := 0 to a.length+b.length-2 do
          begin
          var arr := index_gen_c();
          
          while arr[axis] > a.shape[axis]-1 do
            begin
            tmp_ndarray.assign(item_gen_b(), arr);  
            arr := index_gen_c();
            end;
          
          tmp_ndarray.assign(item_gen_a(), arr);
          end;
        Result := tmp_ndarray;
        end;
    end;
        
        
    function copy(self: ndarray): ndarray;
    begin
      Result := new ndarray(self.value, self.shape);
    end;    
        
        
    function dot(self_ndarray: ndarray; other_ndarray: ndarray; axis: integer): ndarray;
    begin
      if (self_ndarray.rank = 1) and (other_ndarray.rank = 1) then
        begin
        var sum: array of real := (0);
        for var index := 0 to self_ndarray.length-1 do
          sum[0] += self_ndarray.get(index) * other_ndarray.get(index);
        result := new ndarray(sum, ArrFill(1, 1));
        end
      else if (self_ndarray.rank = 1) or (other_ndarray.rank = 1) then
      begin
        if self_ndarray.shape[0] <> other_ndarray.shape[0] then
          raise new Exception('Fields couldn not be broadcast together');
        
        var max_ndarray: ndarray;
        var min_ndarray: ndarray;
        if self_ndarray.rank > other_ndarray.rank then
          begin
          max_ndarray := self_ndarray;
          min_ndarray := other_ndarray;
          end
        else
          begin
          max_ndarray := other_ndarray;
          min_ndarray := self_ndarray;
          end;
        
        var tmp_shape := new integer[max_ndarray.rank-1];
        for var i := 1 to max_ndarray.rank-1 do
          tmp_shape[i-1] := max_ndarray.shape[i]; 
        
        var tmp_arr := new real[tmp_shape.Product];

        var max_index_gen := max_ndarray.__get_index_generator();
        var max_item_gen := max_ndarray.__get_item_generator();
        
        var cnt_limit := max_ndarray.length div max_ndarray.shape[0]; var cnt := 0;
        for var i := 0 to max_ndarray.length-1 do
        begin
          tmp_arr[cnt] += max_item_gen() * min_ndarray.value[max_index_gen()[0]];
          cnt += 1;
          if cnt = cnt_limit then
            cnt := 0;
        end;
        result := new ndarray(tmp_arr, tmp_shape);
        end
      else if (self_ndarray.rank = 2) and (other_ndarray.rank = 2) then
        begin
          var other_ndarray_T := other_ndarray.transpose();
          var tmp_result := new real[self_ndarray.shape[0]*other_ndarray.shape[1]];
          var new_shape: array of integer := (self_ndarray.shape[0], other_ndarray.shape[1]);
          for var i:=0 to self_ndarray.shape[0]-1 do
            for var j:=0 to other_ndarray.shape[1]-1 do
            begin  
              var cc := 0.0;
              for var l:=0 to self_ndarray.shape[1]-1 do
                 cc += self_ndarray.get(i, l)*other_ndarray_T.get(j, l);
              tmp_result[i*self_ndarray.shape[0]+j] := cc;   
            end;
          result := new ndarray(tmp_result, new_shape);
        end
      else
        begin
        var tmp_shape := new integer[self_ndarray.rank+other_ndarray.rank-2];
        for var i := 0 to self_ndarray.rank-2 do
          tmp_shape[i] := self_ndarray.shape[i];
        for var i := 0 to other_ndarray.rank-3 do
          tmp_shape[self_ndarray.rank+i-1] := other_ndarray.shape[i];
        tmp_shape[self_ndarray.rank+other_ndarray.rank-3] := other_ndarray.shape[other_ndarray.rank-1];
        
        var tmp_ndarray := new ndarray(tmp_shape);
        var index_gen := tmp_ndarray.__get_index_generator();
        
        for var i := 0 to tmp_shape.Product-1 do
          begin
            var arr := index_gen();
            var arr_a := new integer[self_ndarray.rank-1];
            for var j := 0 to self_ndarray.rank-2 do
              arr_a[j] := arr[j];
            
            var a_matrix := new real[self_ndarray.shape[self_ndarray.rank-1]];
            var cnt_a := 0;
            for var j := 0 to self_ndarray.shape[self_ndarray.rank-1]-1 do
            begin
              var tmp_arr := new integer[arr_a.length+1];
              for var k := 0 to arr_a.Length-1 do
                tmp_arr[k] := arr_a[k];
              tmp_arr[arr_a.length] := j;
              a_matrix[j] := self_ndarray.get(tmp_arr);
              end;
              
            var arr_b := new integer[other_ndarray.rank-1];
            for var j := 0 to other_ndarray.rank-2 do
              arr_b[j] := arr[self_ndarray.rank+j-1];
                        
            var b_matrix := new real[other_ndarray.shape[other_ndarray.rank-2]];
            var cnt_b := 0;
            for var j := 0 to other_ndarray.shape[other_ndarray.rank-2]-1 do
            begin
              var tmp_arr := new integer[arr_b.length+1];
              for var k := 0 to arr_b.Length-2 do
                tmp_arr[k] := arr_b[k];
              tmp_arr[arr_b.length-1] := j;
              tmp_arr[arr_b.length] := arr_b[arr_b.Length-1];
              b_matrix[j] := other_ndarray.get(tmp_arr);
              end;
              
            var acc := 0.0;
            for var j := 0 to a_matrix.Length-1 do
              acc += a_matrix[j] * b_matrix[j];
            tmp_ndarray.assign(acc, arr);
          end;
        result := tmp_ndarray; 
        end;
    end;    
        
        
    procedure map(self: ndarray; func: System.Func<real, real>);
    begin
      var item_gen := self.__get_item_generator();
      for var i := 0 to self.length-1 do
        self.value[i] := func(item_gen()); 
    end;
    
    
    // TODO: Нахождение максимальных элементов по осям
    function max(self: ndarray): real;
    begin
      var item_gen := self.__get_item_generator();
      var tmp_result := item_gen();
      for var i := 0 to self.length-2 do
        tmp_result := System.Math.Max(item_gen(), tmp_result);  
      result := tmp_result;
    end;
        
        
    function multiply(a, b: real): real;
    begin
      Result := a * b;
    end;
    

    function multiply(a: real; b: ndarray): ndarray;
    begin
      Result := b * a;
    end;
        

    function multiply(a: ndarray; b: real): ndarray;
    begin
      Result := a * b;
    end;


    function multiply(a, b: ndarray): ndarray; 
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
      result := new ndarray(tmp_result, max_shape);
    end;


    function reshape(self: ndarray; shape: array of integer): ndarray;
    begin
      Result := new ndarray(self.value, shape);
    end;


    function sum(self: ndarray; axis: integer): ndarray;
    begin
      if (self.rank = 1) or (axis = -1) then
        begin
        var tmp_result: array of real := (self.value.Sum);
        var tmp_result_shape: array of integer := (1);
        result := new ndarray(tmp_result, tmp_result_shape);
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
        var sum_iter_array := ndarray.__get_iter_array(sum_array_shape);

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
      result := new ndarray(sum_arr, sum_array_shape);
      end;
    end;


    function transpose(self: ndarray; axes: array of integer): ndarray;
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
      
      var tmp_iter_array := ndarray.__get_iter_array(tmp_shape);
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
      result := new ndarray(tmp_value, tmp_shape);
    end;
end.