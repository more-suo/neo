unit neo;

interface
        
    type
        field = class
      
        private
            value: array of real;      
            iter_array: array of integer;
            
            constructor Create(value: array of real; shape: array of integer);
            
            function __generate_index(): function(): array of integer;
            
            function __get_item(index: array of integer): real;
            
            procedure __set_item(val: real; index: array of integer);
            
            static function __get_iter_array(shape: array of integer): array of integer;
            
        public
            length: integer;
            rank: integer;
            shape: array of integer;
            
            constructor Create(array_ptr: pointer; rank: integer);
            
            constructor Create(shape: array of integer);
            
            /// konvertiert Matriz zu String
            function ToString: string; override;
    
            /// Matrizenaddition:
            /// field_sum := self_field + b;
            class function operator+(self_field: field; number: real): field;
           
            /// Matrizenaddition:
            /// field_sum := a + other_field;
            class function operator+(number: real; other_field: field): field;
           
            /// Matrizenaddition:
            /// field_sum := self_field + other_field;
            class function operator+(self_field, other_field:field): field;
           
            /// Matrizenaddition:
            /// field_sum += other_field; 
            class procedure operator+=(var self_field, other_field: field);
            
            /// Matrizenaddition:
            /// field_sum += b; 
            class procedure operator+=(var self_field: field; number: real);
                        
            /// Matrizensubtraktion:
            /// field_sum := self_field - b;
            class function operator-(self_field: field; number: real): field;
                
            /// Matrizensubtraktion:
            /// field_difference := self_field - other_field;
            class function operator-(self_field, other_field: field): field;
            
            /// Matrizensubtraktion:
            /// field_difference -= other_field;    
            class procedure operator-=(var self_field: field; other_field: field);
            
            /// Matrizensubtraktion:
            /// field_sum -= b; 
            class procedure operator-=(var self_field: field; number: real);
                
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := self_field * b;
            class function operator*(self_field: field; number: real): field;

            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := a * other_field;
            class function operator*(number: real; other_field: field): field;
            
            /// Matrizenmultiplikation:
            /// field_mult := self_field * other_field;                  
            class function operator*(self_field, other_field: field): field;
            
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult *= b;
            class procedure operator*=(var self_field: field; const number: real);

            /// Matrizenmultiplikation:
            /// field_mult *= other_field;                  
            class procedure operator*=(var self_field: field; const other_field: field);
                
            /// Matrizendivision mit Zahlen:
            /// field_div := self_field / b;
            class function operator/(self_field: field; number: real): field;
            
            /// Matrizendivision mit Zahlen:
            /// field_div /= b;
            class procedure operator/=(var self_field: field; number: real);

            /// Exponentiation vom jeden Matrizenelements:
            /// field_exp := self_field ** b
            class function operator**(var self_field: field; number: real): field;
                
            /// wenn axis = 0, Summe aller Spalten; wenn axis = 1, Summe aller Zeilen
            function sum(axis: integer := -1): field;

            /// das Werte der Matrize
            function get(params index: array of integer): real;
   
            procedure assign(val: real; params index: array of integer);
            
            procedure map(func: System.Func<real, real>);
            
            /// kehrt den groeßten Wert der Matrize zurueck
            function max(): real;
                
            /// Erstellt eine Kopie der Matrize
            function copy(): field;
            
            /// Umformung der Matrize in eine andere Matrize mit Groeße size
            function reshape(shape: array of integer): field;

            /// Transponierung der Matrize
            function transpose(axes: array of integer := nil): field;
            
            /// Summe des Skalarproduktes von zwei Vektoren
            function dot(other_field: field): field;
    end;

    /// Matrizengenerator mit rows*colums, (0, 1)
    function random_field(shape: array of integer): field;
   
    /// Erweiterung der Matrize a mit b, axis == 0 - zeilenweise, axis == 1 - spaltenweise
    function concatenate(a,b:field; axis: integer := -1): field;
    
    
    /// Multiplikation von zwei Skalaren
    function multiply(a, b: real): real;
    /// Multiplikation von Skalar und Matrize
    function multiply(a:real; b:field): field;
    /// Multiplikation von Matrize und Skalar
    function multiply(a:field; b:real): field;
    /// Multiplikation von zwei Matrizen
    function multiply(a,b:field): field;
         
        
implementation
    
    // field.Create() - Implementierung
    constructor field.Create(value: array of real; shape: array of integer);
    begin
      self.value := value;
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := field.__get_iter_array(shape);
      println(shape, rank, length);
    end;
    
    
    type Generator = class
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
    

    function field.__generate_index(): function(): array of integer;
    begin
      var obj := new Generator;
      obj.rank := self.rank;
      obj.shape := self.shape;
      obj.index := ArrFill(self.rank, 0);
      obj.index[self.rank-1] := -1;
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
    
    
    constructor field.Create(array_ptr: pointer; rank: integer);
    var tmp_ptr : ^^integer;
        element_ptr : ^integer;
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
          element_ptr := pointer(integer(array_ptr) + 16 + i*4);
          self.shape[i] := element_ptr^;
          end;
      self.iter_array := field.__get_iter_array(self.shape);

      self.value := new real[size^];
      for var i := 0 to size^-1 do
        begin
        element_ptr := pointer(integer(array_ptr) + 16 + 2*4*(rank-(rank=1?1:0)) + i*sizeof(integer));
        self.value[i] := element_ptr^;
        end;       
    end;
    
    
    constructor field.Create(shape: array of integer);
    begin
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := field.__get_iter_array(shape);
      self.value := new real[shape.Product]; 
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
        
        
    // field.operator + () and field.operator += () - Implementierung
    class function field.operator+(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] + number;
      result := new field(tmp_result, self_field.shape);    
    end;
        
        
    class function field.operator+(number: real; other_field: field): field;
    begin
      Result := other_field + number;    
    end;
        
        
    class function field.operator+(self_field, other_field: field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//           raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] + other_field.value[index]; 
      Result := new field(tmp_result, self_field.shape);    
    end;
        
        
    class procedure field.operator+=(var self_field, other_field: field);
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new Exception('Wrong array sizes');
      self_field := self_field + other_field;
    end;
    
    
    class procedure field.operator+=(var self_field:field; number: real);
    begin
      self_field := self_field + number;
    end;
        
        
    // field.operator - () and field.operator -= () - Implementierung        
    class function field.operator-(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] - number; 
      Result := new field(tmp_result, self_field.shape);        
    end;
        

    class function field.operator-(self_field, other_field: field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] - other_field.value[index]; 
      Result := new field(tmp_result, self_field.shape);    
    end;       

    
    class procedure field.operator-=(var self_field:field; other_field: field);
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new Exception('Wrong array sizes');
      self_field := self_field - other_field;
    end;

    
    class procedure field.operator-=(var self_field: field; number: real);
    begin
      self_field := self_field - number;
    end;

        
    // field.operator * () and field.operator *= () - Implementierung
    class function field.operator*(self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] * number; 
      Result := new field(tmp_result, self_field.shape);
    end;


    class function field.operator*(number: real; other_field: field): field;
    begin
      Result := other_field * number;
    end;
                  
                  
    class function field.operator*(self_field, other_field:field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] * other_field.value[index]; 
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
        

    // field.operator / () and field.operator /= () - Implementierung
    class function field.operator/(self_field: field; number: real): field;
    begin
//         if b = 0 then
//             raise new System.ArithmeticException('ZeroDivisionError');
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] / number; 
      Result := new field(tmp_result, self_field.shape);
    end;
    

    class procedure field.operator/=(var self_field: field; number: real);
    begin
      self_field := self_field / number;
    end;
    

    // field.operator ** () - Implementierung
    class function field.operator**(var self_field: field; number: real): field;
    begin
      var tmp_result := new real[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] ** number; 
      Result := new field(tmp_result, self_field.shape);
    end;
        

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

        var gen := self.__generate_index();
        for var index := 0 to self.length-1 do
          begin 
          var arr := gen();
           
          var new_arr := new integer[self.rank-1]; var sum_cnt := 0;
          for var i := 0 to self.rank-1 do
            if i = axis then
              continue
            else
             begin
              new_arr[sum_cnt] := arr[i];
              sum_cnt += 1;
              end;
              
          var sum_acc := 0;
          for var i := 0 to self.rank-2 do
            sum_acc += sum_iter_array[i] * new_arr[i];
          sum_arr[sum_acc] += self.value[index];
          end;
      result := new field(sum_arr, sum_array_shape);
      end;
    end;

      
    // field.get() - Implementierung
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
      for var index := 0 to self.length-1 do
        self.value[index] := func(self.value[index]); 
    end;
    
    
    // field.max() - Implementierung
    function field.max(): real;
    begin
      result := self.value.Max;
    end;

    
    // field.copy() - Implementierung
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
      var gen := self.__generate_index();
      var tmp_value := new real[self.length];
      var tmp_shape := new integer[self.rank];
      for var index := 0 to self.rank-1 do
        tmp_shape[index] := self.shape[axes[index]];
      var tmp_iter_array := field.__get_iter_array(tmp_shape);
      for var index := 0 to self.length-1 do
        begin
        var arr := gen(); 
        var new_arr := new integer[self.rank];
        for var i := 0 to self.rank-1 do
          new_arr[i] := arr[axes[i]];
        
        var acc := 0;
        for var i := 0 to self.rank-1 do
          acc += tmp_iter_array[i] * new_arr[i];
        tmp_value[acc] := self.value[index];
        end;
      result := new field(tmp_value, tmp_shape);
    end;  
   
   
    // dot() - Implementierung
    function field.dot(other_field: field): field;
    begin
      if (self.rank = 1) and (other_field.rank = 1) then
        begin
        var sum: array of real := (0);
        for var index := 0 to self.length-1 do
          sum[0] += self.get(index) * other_field.get(index);
        result := new field(sum, ArrFill(1, 1));
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
   
   
    // random_field() - Implementierung
    function random_field(shape: array of integer): field;
    begin
      var tmp_result := new real[shape.Product];
      for var index := 0 to shape.Product-1 do
        tmp_result[index] := random(2);
      Result := new field(tmp_result, shape);   
    end;
 

    function concatenate(a, b: field; axis: integer): field;
    begin
      if axis = -1 then
      begin
        var tmp_shape: array of integer := (a.length+b.length-1); 
        var tmp_field := new field(tmp_shape);
        var gen_a := a.__generate_index();
        for var index := 0 to a.length-1 do
          tmp_field.assign(a.get(gen_a()), index);
        var gen_b := b.__generate_index();
        for var index := a.length to a.length+b.length-1 do
          tmp_field.assign(b.get(gen_b()), index);
        Result := tmp_field;
        end
      else
        begin
//        if a.row_number <> b.row_number then
//            raise new Exception('Fields couldn not be broadcast together');
        var gen_a := a.__generate_index();
        var gen_b := b.__generate_index();
        
        var tmp_shape := new integer[a.rank];
        for var index := 0 to a.rank-1 do
          begin
          tmp_shape[index] := a.shape[index];
          if index = axis then
            tmp_shape[index] += b.shape[axis];
          end;
          
        var tmp_field := new field(tmp_shape);
        var gen_c := tmp_field.__generate_index();
        
        for var index := 0 to a.length+b.length-2 do
          begin
          var arr := gen_c();
          
          while arr[axis] > a.shape[axis]-1 do
            begin
            tmp_field.assign(b.get(gen_b()), arr);  
            arr := gen_c();
            end;
          
          tmp_field.assign(a.get(gen_a()), arr);
          end;
        Result := tmp_field;
        end;
    end;
        
        
    // multiply() - Implementierung
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
      
      var gen_a := a.__generate_index();
      var gen_b := b.__generate_index();
        
      var tmp_result := new real[max_len];  
      for var index := 0 to max_len-1 do
        begin
        var arr_a := gen_a();
        var arr_b := gen_b();
        tmp_result[index] := a.get(arr_a)*b.get(arr_b);
        end;
      result := new field(tmp_result, max_shape);
    end;
end.