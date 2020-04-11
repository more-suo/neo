unit neo;

interface
        
    type
        field = class
      
        private
            value: array of integer;      
            iter_array: array of integer;
            
            constructor Create(value: array of integer; shape: array of integer);
            
            function __get_index(self_field: field): function(): array of integer;
            
            function __get_item(index: array of integer): integer;
            
            function __get_iter_array(shape: array of integer): array of integer;
            
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
            class function operator+(self_field: field; number: integer): field;
           
            /// Matrizenaddition:
            /// field_sum := a + other_field;
            class function operator+(number: integer; other_field: field): field;
           
            /// Matrizenaddition:
            /// field_sum := self_field + other_field;
            class function operator+(self_field, other_field:field): field;
           
            /// Matrizenaddition:
            /// field_sum += other_field; 
            class procedure operator+=(var self_field, other_field: field);
            
            /// Matrizenaddition:
            /// field_sum += b; 
            class procedure operator+=(var self_field: field; number: integer);
                        
            /// Matrizensubtraktion:
            /// field_sum := self_field - b;
            class function operator-(self_field: field; number: integer): field;
                
            /// Matrizensubtraktion:
            /// field_difference := self_field - other_field;
            class function operator-(self_field, other_field: field): field;
            
            /// Matrizensubtraktion:
            /// field_difference -= other_field;    
            class procedure operator-=(var self_field: field; other_field: field);
            
            /// Matrizensubtraktion:
            /// field_sum -= b; 
            class procedure operator-=(var self_field: field; number: integer);
                
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := self_field * b;
            class function operator*(self_field: field; number: integer): field;

            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := a * other_field;
            class function operator*(number: integer; other_field: field): field;
            
            /// Matrizenmultiplikation:
            /// field_mult := self_field * other_field;                  
            class function operator*(self_field, other_field: field): field;
            
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult *= b;
            class procedure operator*=(var self_field: field; const number: integer);

            /// Matrizenmultiplikation:
            /// field_mult *= other_field;                  
            class procedure operator*=(var self_field: field; const other_field: field);
                
            /// Matrizendivision mit Zahlen:
            /// field_div := self_field / b;
            class function operator/(self_field: field; number: integer): field;
            
            /// Matrizendivision mit Zahlen:
            /// field_div /= b;
            class procedure operator/=(var self_field: field; number: integer);

//            /// Exponentiation vom jeden Matrizenelements:
//            /// field_exp := self_field ** b
//            class function operator**(var self_field: field; number: real): field;
                
            /// wenn axis = 0, Summe aller Spalten; wenn axis = 1, Summe aller Zeilen
            function sum(axis: integer := -1): field;

            /// das Werte der Matrize
            function get(params index: array of integer): integer;
            
            procedure map(func: System.Func<integer, integer>);
            
            /// kehrt den groeßten Wert der Matrize zurueck
            function max(): integer;
                
            /// Erstellt eine Kopie der Matrize
            function copy(): field;
            
            /// Umformung der Matrize in eine andere Matrize mit Groeße size
            function reshape(shape: array of integer): field;
    end;

//    /// Vergleich von zwei arrays of integer
//    function compare(a,b:array of integer): boolean;
//       
//    /// Matrizengenerator mit rows*colums, (0, 1)
//    function random_field(rows, columns:integer): field;
//    /// Matrizengenerator mit rows*colums, (0, max)
//    function random_field(rows, columns, max:integer): field;
//    /// Matrizengenerator mit rows*colums, (min, max)
//    function random_field(rows, columns, min, max:integer): field;
//   
//    /// Erweiterung der Matrize a mit b, zeilenweise
//    function concatenate(a,b:field): field;
//    /// Erweiterung der Matrize a mit b, axis == 0 - zeilenweise, axis == 1 - spaltenweise
//    function concatenate(a,b:field; axis:integer): field;
//    
//    
//    /// Multiplikation von zwei Skalaren
//    function multiply(a,b:real): real;
//    /// Multiplikation von Skalar und Matrize
//    function multiply(a:real; b:field): field;
//    /// Multiplikation von Matrize und Skalar
//    function multiply(a:field; b:real): field;
//    /// Multiplikation von zwei Matrizen
//    function multiply(a,b:field): field;
//    
//    
//    /// Transponierung der Matrize
//    function transpose(self_field:field): field;
//    
//    
//    /// Summe des Skalarproduktes von zwei Vektoren
//    function dot(self_field, other_field: field): field;
        
        
implementation
    
//   function compare(a, b:array of integer): boolean;
//        begin 
//         Result := False;
//         if a.Length <> b.Length then
//             exit;
//         for var i:= 0 to a.Length-1 do
//             if a[i] <> b[i] then
//                  exit;
//         Result := True;
//        end;  
        
        
    // field.Create() - Implementierung
    constructor field.Create(value: array of integer; shape: array of integer);
    begin
      self.value := value;
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := new integer[self.rank];
      self.iter_array[self.rank-1] := 1;
      for var i := 1 to self.rank-1 do
        self.iter_array[self.rank-i-1] := self.iter_array[self.rank-i] * self.shape[self.rank-i];
    end;
    
    
    type Generator = class
    
      self_field: field;
      index: array of integer;
      index_1: array of integer;
      
      function next_1(): array of integer;
      begin
        if index_1[0] = self.self_field.length-1 then
          index_1[0] := 0
        else
          index_1[0] += 1;
        result := index_1;
      end;
      
      function next(): array of integer;
      begin
        index[index.Length-1] += 1;
        for var i := index.Length-1 downto 0 do
          if index[i] = self_field.shape[i] then
            if i = 0 then
              begin
              index := ArrFill(index.Length, 0);
              end
            else
              begin
              index[i-1] += 1;
              index[i] := 0;
              end;
        result := index;
      end;
    end;
    

    function field.__get_index(self_field: field): function(): array of integer;
    begin
      var obj := new Generator;
      obj.self_field := self_field;
      if self_field.rank <> 1 then
        begin
        obj.index := ArrFill(self_field.rank, 0);
        obj.index[self_field.rank-1] := -1;
        result := obj.next;
        end
      else
        begin
        obj.index_1 := ArrFill(1, -1);
        result := obj.next_1;
        end;
    end;
    
    
    function field.__get_item(index: array of integer): integer;
    begin
      var acc := 0;
      for var i := 0 to index.Length-1 do
        acc += self.iter_array[i] * index[i];
      Result := self.value[acc];
    end;


    function field.__get_iter_array(shape: array of integer): array of integer;
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
      for var index := 0 to rank-1 do
        begin
        element_ptr := pointer(integer(array_ptr) + 16 + index*4);
        self.shape[index] := element_ptr^;
        end;
      
      self.iter_array := self.__get_iter_array(self.shape);
      
      self.value := new integer[size^];
      for var index := 0 to size^-1 do
        begin
        element_ptr := pointer(integer(array_ptr) + 16 + 2*4*(rank-(rank=1?1:0)) + index*sizeof(integer));
        self.value[index] := element_ptr^;
        end;
    end;
    
    
    constructor field.Create(shape: array of integer);
    begin
      self.shape := shape;
      self.value := new integer[shape.Product]; 
    end;  
    
    
    // field.ToString() - Implementierung
    function field.ToString: string;
    begin
      var cnt := 0;
      write('['*self.rank);
      var arr := new integer[self.rank];
      for var index := 0 to self.length-1 do
        begin
        if arr.Length > 1 then 
          for var i := self.rank-1 downto 0 do
            if arr[i] = self.shape[i] then
              begin
              arr[i-1] += 1;
              arr[i] := 0;
              write('], ');
              cnt += 1;
              end;
        write('['*cnt); cnt := 0;
        arr[self.rank-1] += 1;
        write(self.value[index], ', ');
        end;
      write(']'*self.rank);
    end;
        
        
    // field.operator + () and field.operator += () - Implementierung
    class function field.operator+(self_field: field; number: integer): field;
    begin
      var tmp_result := new integer[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] + number;
      result := new field(tmp_result, self_field.shape);    
    end;
        
        
    class function field.operator+(number: integer; other_field: field): field;
    begin
      Result := other_field + number;    
    end;
        
        
    class function field.operator+(self_field, other_field: field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//           raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new integer[self_field.length];
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
    
    
    class procedure field.operator+=(var self_field:field; number: integer);
    begin
      self_field := self_field + number;
    end;
        
        
    // field.operator - () and field.operator -= () - Implementierung        
    class function field.operator-(self_field: field; number: integer): field;
    begin
      var tmp_result := new integer[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] - number; 
      Result := new field(tmp_result, self_field.shape);        
    end;
        

    class function field.operator-(self_field, other_field: field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new integer[self_field.length];
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

    
    class procedure field.operator-=(var self_field: field; number: integer);
    begin
      self_field := self_field - number;
    end;

        
    // field.operator * () and field.operator *= () - Implementierung
    class function field.operator*(self_field: field; number: integer): field;
    begin
      var tmp_result := new integer[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] * number; 
      Result := new field(tmp_result, self_field.shape);
    end;


    class function field.operator*(number: integer; other_field: field): field;
    begin
      Result := other_field * number;
    end;
                  
                  
    class function field.operator*(self_field, other_field:field): field;
    begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new integer[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] * other_field.value[index]; 
      Result := new field(tmp_result, self_field.shape);
    end;
            
            
    class procedure field.operator*=(var self_field: field; number: integer);
    begin
      self_field := self_field * number;
    end;
          
      
    class procedure field.operator*=(var self_field: field; other_field: field);
    begin
      self_field := self_field * other_field;
    end;
        

    // field.operator / () and field.operator /= () - Implementierung
    class function field.operator/(self_field: field; number: integer): field;
    begin
//         if b = 0 then
//             raise new System.ArithmeticException('ZeroDivisionError');
      var tmp_result := new integer[self_field.length];
      for var index := 0 to self_field.length-1 do
        tmp_result[index] := self_field.value[index] div number; 
      Result := new field(tmp_result, self_field.shape);
    end;
    

    class procedure field.operator/=(var self_field: field; number: integer);
    begin
      self_field := self_field / number;
    end;
    

//    // field.operator ** () - Implementierung
//    class function field.operator**(var self_field: field; number: real): field;
//        begin
//         var tmp_result := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to self_field.row_number - 1 do
//             for var j:= 0 to self_field.column_number - 1 do
//                 tmp_result[i, j] :=  self_field.values[i, j] ** b;
//         Result := new field(tmp_result);
//        end;
        

    function field.sum(axis: integer): field;
    begin
      if (self.rank = 1) or (axis = -1) then
        begin
        var tmp_result: array of integer := (self.value.Sum);
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
            
        var sum_arr := new integer[sum_array_shape.Product];
        var sum_iter_array := self.__get_iter_array(sum_array_shape);

        var gen := self.__get_index(self);
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
    function field.get(params index: array of integer): integer;
    begin
      result := self.__get_item(index);
    end;
    
    
    procedure field.map(func: System.Func<integer, integer>);
    begin
      for var index := 0 to self.length-1 do
        self.value[index] := func(self.value[index]); 
    end;
    
    
    // field.max() - Implementierung
    function field.max(): integer;
    begin
      result := self.value.Max;
    end;
        

//    // field.get_longest() - Implementierung
//    function field.get_longest(): real;
//        begin
//         var max := values[0,0];
//         for var row:= 0 to row_number-1 do
//             for var column:= 0 to column_number-1 do
//                 if values[row, column].ToString.Length >  max.ToString.Length then
//                     max := values[row, column];
//         Result := max;
//        end;
//    
//
//    function field.get_longest(axis, num:integer): real;
//        begin
//         if axis = 0 then
//             begin
//              var max := values[0, num];
//              for var row:= 0 to row_number-1 do
//                      if values[row, num].ToString.Length >  max.ToString.Length then
//                          max := values[row, num];
//              Result := max;
//             end
//         else if axis = 1 then
//            begin
//             var max := values[num,0];
//             for var column:= 0 to column_number-1 do
//                     if values[num, column].ToString.Length >  max.ToString.Length then
//                         max := values[num, column];
//             Result := max;
//            end
//        end;
    
    
    // field.copy() - Implementierung
    function field.copy(): field;
    begin
      Result := new field(self.value, self.shape);
    end;


    function field.reshape(shape: array of integer): field;
    begin
      Result := new field(self.value, shape);
    end;
   
//    // random_field() - Implementierung
//    function random_field(rows, columns:integer): field;
//        begin
//         var return_array := new Real[rows, columns];
//         for var i:= 0 to rows - 1 do
//             for var j:= 0 to columns - 1 do
//                return_array[i,j] := Random;
//         Result := new field(return_array);   
//        end;
// 
//
//    function random_field(rows, columns, max:integer): field;
//        begin
//         var return_array := new Real[rows, columns];
//         for var i:= 0 to rows - 1 do
//             for var j:= 0 to columns - 1 do
//                return_array[i,j] := Random + Random(max);
//         Result := new field(return_array);
//        end;
//    
//
//    function random_field(rows, columns, min, max:integer): field;
//        begin
//         var return_array := new Real[rows, columns];
//         for var i:= 0 to rows - 1 do
//             for var j:= 0 to columns - 1 do
//                return_array[i,j] := Random + Random(min, max);
//         Result := new field(return_array);
//        end;    
//
//  
//    // concatenate() - Implementierung
//    function concatenate(a,b:field): field;
//        begin
//         if a.column_number <> b.column_number then
//            raise new Exception('Fields couldn not be broadcast together');
//         var return_array := new Real[1,1];
//         SetLength(return_array, a.row_number+b.row_number, a.column_number);
//         for var column:= 0 to a.column_number-1 do
//             begin
//              for var row:= 0 to a.row_number-1 do
//                  return_array[row,column] := a.values[row,column];
//              for var row:= 0 to b.row_number-1 do
//                  return_array[row+a.row_number,column] := b.values[row, column];
//             end;
//         Result := new field(return_array); 
//        end;
//    
//    function concatenate(a,b:field; axis:integer): field;
//        begin
//         if axis = 0 then
//             Result:= concatenate(a,b)
//         else if axis = 1 then
//             begin
//              if a.row_number <> b.row_number then
//                  raise new Exception('Fields couldn not be broadcast together');
//              var return_array := new Real[1,1];
//              SetLength(return_array, a.column_number+b.column_number, a.row_number);
//              for var row:= 0 to a.row_number-1 do
//                  begin
//                   for var column:= 0 to a.column_number-1 do
//                       return_array[row,column] := a.values[row,column];
//                   for var column:= 0 to b.column_number-1 do
//                       return_array[row,column+a.column_number] := b.values[row, column];
//                  end;
//              Result := new field(return_array);
//             end;
//        end;
//        
//        
//    // multiply() - Implementierung
//    function multiply(a,b:real): real;
//        begin
//         Result := a * b;
//        end;
//    
//
//    function multiply(a:real; b:field): field;
//        begin
//         Result := a * b;
//        end;
//        
//
//    function multiply(a:field; b:real): field;
//        begin
//         Result := a * b;
//        end;
//
//
//    function multiply(a,b:field): field;
//        begin
//         var (big_field, small_field) := a.shape.Product > b.shape.Product?
//                                            (a.copy, b.copy) : (b.copy, a.copy);
//         var row_mod := big_field.row_number mod small_field.row_number;
//         var column_mod := big_field.column_number mod small_field.column_number;
//         if (row_mod <> 0) or (column_mod <> 0) then
//             raise new Exception('Fields could not be broadcast together');
//         var row_div := big_field.row_number div small_field.row_number;
//         var column_div := big_field.column_number div small_field.column_number;
//         for var row_block:= 0 to row_div-1 do
//             for var column_block:= 0 to column_div-1 do
//                 for var row:= 0 to small_field.row_number-1 do
//                    for var column:= 0 to small_field.column_number-1 do
//                        big_field[row+row_block*small_field.row_number,column+column_block*small_field.column_number] *= 
//                            small_field[row,column];
//         Result := big_field;
//        end;
//        
//        
//    // transpose() - Implementierung    
//    function transpose(self_field:field): field;
//        begin
//         var return_array := new Real[self_field.column_number, self_field.row_number];
//         for var i:= 0 to self_field.row_number-1 do
//             for var j:= 0 to self_field.column_number-1 do
//                 return_array[j,i] := self_field[i,j];
//         Result := new field(return_array);
//        end;
//        
//    
//    // dot() - Implementierung
//    function dot(self_field, other_field: field): field;
//        begin
//         if ((self_field.row_number, other_field.row_number) = (1, 1)) and
//            (self_field.column_number = other_field.column_number) then
//             Result := self_field * other_field
//         else if (self_field.column_number = other_field.row_number) then
//            begin
//            var tmp_result := new field(self_field.row_number, other_field.column_number);
//             for var i:= 0 to tmp_result.row_number - 1 do
//                 for var j:= 0 to tmp_result.column_number - 1 do
//                     for var k:= 0 to self_field.column_number - 1 do
//                         tmp_result.values[i,j]+= self_field.values[i, k] * other_field.values[k, j];
//             Result := tmp_result;
//            end
//         else
//            raise new Exception('Wrong array sizes');
//        end;
end.