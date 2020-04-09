unit neo;

interface
        
//    type
//        float_func = System.Func<real, real>;
//        int_func = System.Func<real, integer>;
//        
    type
        field = class
      
        private
            value: array of integer;      
            iter_array: array of integer;
            
            constructor Create(new_field: field; value: array of integer);

        public
            length: integer;
            rank: integer;
            shape: array of integer;
            
            constructor Create(array_ptr: pointer; rank: integer);
            
            constructor (shape: array of integer);
            
            /// konvertiert Matriz zu String
            function ToString: string; override;
    
            /// Matrizenaddition:
            /// field_sum := self_field + b;
            class function operator + (self_field: field; number: integer): field;
           
            /// Matrizenaddition:
            /// field_sum := a + other_field;
            class function operator + (number: integer; other_field: field): field;
           
            /// Matrizenaddition:
            /// field_sum := self_field + other_field;
            class function operator + (self_field, other_field:field): field;
           
            /// Matrizenaddition:
            /// field_sum += other_field; 
            class procedure operator += (var self_field, other_field: field);
            
            /// Matrizenaddition:
            /// field_sum += b; 
            class procedure operator += (var self_field: field; number: integer);
                        
//            /// Matrizensubtraktion:
//            /// field_sum := self_field - b;
//            class function operator - (self_field:field; b:Real): field;
//                
//            /// Matrizensubtraktion:
//            /// field_difference := self_field - other_field;
//            class function operator - (self_field, other_field:field): field;
//            
//            /// Matrizensubtraktion:
//            /// field_difference -= other_field;    
//            class procedure operator -= (var self_field:field; const other_field:field);
//            
//            /// Matrizensubtraktion:
//            /// field_sum -= b; 
//            class procedure operator -= (var self_field:field; const b:Real);
                
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
            class procedure operator/=(var self_field:field; number: integer);

//            /// Exponentiation vom jeden Matrizenelements:
//            /// field_exp := self_field ** b
//            class function operator ** (var self_field:field; const b:real): field;
//                
//            /// Summe aller Elemente der Matrize
//            function sum(): real;
//            
//            /// wenn axis = 0, Summe aller Spalten; wenn axis = 1, Summe aller Zeilen
//            function sum(axis:integer): field;
//                
//            /// Dimensionen der Matrize
//            function shape(): array of integer;
              
            /// das Werte der Matrize
            function get(params index: array of integer): integer;
            
//            /// kehrt den groeßten Wert der Matrize zurueck
//            function get_max(): real;
//                
//            /// kehrt den laengsten Wert der Matrize zurueck
//            function get_longest(): real;
//            
//            /// Wenn axis = 0 laengster Wert in der Spaltennummer num,
//            /// wenn axis = 1 laengster Wert in der Zeile
//            function get_longest(axis, num:integer): real;
//                     
            /// Erstellt eine Kopie der Matrize
            function copy(): field;
    end;

//    /// Vergleich von zwei arrays of integer
////    function compare(a,b:array of integer): boolean;
//    
//    /// Anwendung einer Funktion an alle Elemente einer Neo
//    function map(func: float_func; self_field: field): field;
//    /// Anwendung einer Funktion an alle Elemente einer Neo
//    function map(func: int_func; self_field: field): field;
//    
//        
//    /// Matrizengenerator mit rows*colums, (0, 1)
//    function random_field(rows, columns:integer): field;
//    /// Matrizengenerator mit rows*colums, (0, max)
//    function random_field(rows, columns, max:integer): field;
//    /// Matrizengenerator mit rows*colums, (min, max)
//    function random_field(rows, columns, min, max:integer): field;
//
//    
//    /// Umformung der Matrize in einen eindemensionalen Vektor mit Laenge size
//    function reshape(a:field; size:integer): field;
//    /// Umformung der Matrize in eine andere Matrize mit Groeße size
//    function reshape(a:field; size:array of integer): field;
//    
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
    constructor field.Create(new_field: field; value: array of integer);
    begin
      self.value := value;
      self.shape := new_field.shape;
      self.rank := new_field.rank;
      self.length := new_field.length;
      self.iter_array := new_field.iter_array;
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
      
      self.iter_array := new integer[rank];
      for var i := 1 to rank-1 do
        self.iter_array[rank-i-1] := self.iter_array[rank-i] * self.shape[rank-i];
      
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
              begin
              if arr[i] = self.shape[i] then
                begin
                arr[i-1] += 1;
                arr[i] := 0;
                write('], ');
                cnt += 1;
                end
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
        result := new field(self_field, tmp_result);    
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
        Result := new field(self_field, tmp_result);    
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
        
        
//    // field.operator - () and field.operator -= () - Implementierung        
//    class function field.operator - (self_field:field; b:Real): field;
//        begin
//         var tmp_result := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to tmp_result.RowCount-1 do
//             for var j:= 0 to tmp_result.ColCount-1 do
//                 tmp_result[i, j] := self_field.values[i, j] - b;
//         Result := new field(tmp_result);    
//        end;
//        
//
//    class function field.operator - (self_field, other_field:field): field;
//        begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new System.ArithmeticException('Wrong array sizes');
//         var tmp_result := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to tmp_result.RowCount-1 do
//             for var j:= 0 to tmp_result.ColCount-1 do
//                 tmp_result[i, j] := self_field.values[i, j] - other_field.values[i, j];
//         Result := new field(tmp_result);
//        end;       
//
//    
//    class procedure field.operator -= (var self_field:field; const other_field:field);
//        begin
//         if not compare(self_field.shape, other_field.shape) then
//                raise new Exception('Wrong array sizes');
//         self_field := self_field - other_field;
//        end;
//
//    
//    class procedure field.operator -= (var self_field:field; const b:Real);
//        begin
//         self_field := self_field - b;
//        end;

        
    // field.operator * () and field.operator *= () - Implementierung
    class function field.operator*(self_field: field; number: integer): field;
      begin
        var tmp_result := new integer[self_field.length];
        for var index := 0 to self_field.length-1 do
          tmp_result[index] := self_field.value[index] * number; 
        Result := new field(self_field, tmp_result);
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
        Result := new field(self_field, tmp_result);
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
        Result := new field(self_field, tmp_result);
        end;
    

    class procedure field.operator/=(var self_field: field; number: integer);
        begin
         self_field := self_field / number;
        end;
    

//    // field.operator ** () - Implementierung
//    class function field.operator ** (var self_field:field; const b:real): field;
//        begin
//         var tmp_result := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to self_field.row_number - 1 do
//             for var j:= 0 to self_field.column_number - 1 do
//                 tmp_result[i, j] :=  self_field.values[i, j] ** b;
//         Result := new field(tmp_result);
//        end;
//        
//
//    // field.sum() - Implementierung
//    function field.sum(): real;
//        begin
//         var s := 0.0;
//         for var i:= 0 to row_number - 1 do
//             for var j:= 0 to column_number - 1 do
//                 begin
//                  s += values[i,j];
//                 end;
//         Result := s;
//        end;
//    
//
//    function field.sum(axis:integer): field;
//        begin
//         var return_array := new Real[1];
//         if axis = 0 then
//             begin
//              setlength(return_array, column_number);
//              for var column:= 0 to column_number-1 do
//                  for var row:= 0 to row_number-1 do
//                      return_array[column] += values[row,column];
//             end
//         else if axis = 1 then
//             begin
//              setlength(return_array, row_number);
//              for var row:= 0 to row_number-1 do
//                  for var column:= 0 to column_number-1 do
//                      return_array[row] += values[row,column];
//             end
//         else
//             raise new Exception('No third dimension');
//         Result := new field(return_array);
//        end;
//        
//
//    // field.shape() - Implementierung
//    function field.shape(): array of integer;
//        begin
//         Result := Arr(row_number, column_number);
//        end;
      
      
    // field.get() - Implementierung
    function field.get(params index: array of integer): integer;
      begin
        var acc := 0;
        for var i := 0 to self.rank-1 do
          acc += self.iter_array[i] * index[i];
        Result := self.value[acc];
      end;
    
    
//    // field.get_max() - Implementierung
//    function field.get_max(): real;
//        begin
//         var max := values[0,0];
//         for var row:= 0 to row_number-1 do
//             for var column:= 0 to column_number-1 do
//                 if values[row, column] >  max then
//                     max := values[row, column];
//         Result := max;
//        end;
//        
//
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
        Result := new field(self, self.value);
      end;
      
      
//    // sum() - Implementierung
//    function sum(a:field): real;
//        begin
//         Result := a.sum();
//        end;
//    
//    function sum(a:field; axis:integer): field;
//        begin
//         Result := a.sum(axis);
//        end;
//      
//      
//    // shape() - Implementierung
//    function shape(a:field): array of integer;
//        begin
//         Result := a.shape();
//        end;
//      
//      
//    // get_value() - Implementierung
//    function get_value(a:field): array[,] of real;
//        begin
//         Result := a.get_value();
//        end;
//    
//    
//    // get_max() - Implementierung
//    function get_max(a:field): real;
//        begin
//         Result := a.get_max();
//        end;
//    
//    
//    // get_longest() - Implementierung
//    function get_longest(a:field): real;
//        begin
//         Result := a.get_longest();
//        end;
//    
//    function get_longest(a:field; axis, num:integer): real;
//        begin
//         Result := a.get_longest(axis, num);
//        end;
//   
//   
//    // copy() - Implementierung
//    function copy(a: field): field;
//        begin
//         Result := a.copy();
//        end;
// 
//        
//    // map() - Implementierung
//    function map(func: float_func; self_field: field): field;
//        begin
//         var return_array := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to self_field.row_number - 1 do
//            for var j:= 0 to self_field.column_number - 1 do
//                return_array[i,j] := func(self_field.values[i,j]);
//         Result := new field(return_array);
//        end;
//    
//
//    function map(func: int_func; self_field: field): field;
//        begin
//         var return_array := new Real[self_field.row_number, self_field.column_number];
//         for var i:= 0 to self_field.row_number - 1 do
//            for var j:= 0 to self_field.column_number - 1 do
//                return_array[i,j] := func(self_field.values[i,j]);
//         Result := new field(return_array);
//        end;
//        
//        
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
//    // reshape() - Implementierung
//    function reshape(a:field; size:integer): field;
//        begin
//         if a.column_number * a.row_number <> size then
//            raise new Exception('Wrong size');
//         var counter := 0;
//         var return_array := new Real[size];
//         foreach var element in a.get_value do
//                begin
//                 return_array[counter] := element;
//                 counter += 1;
//                end;
//         Result := new field(return_array);
//        end;
//        
//
//    function reshape(a:field; size:array of integer): field;
//        begin
//         var rows := 0;
//         var columns := 0;
//         var elements_needed := 1;
//         if size.Length < 1 then
//             raise new Exception('Size must contain at least 1 argument');
//         foreach x: integer in size do
//              elements_needed *= x;
//         if size.Length = 1 then
//            (rows, columns) := (size[0], 1)
//         else if size.Length = 2 then
//            (rows, columns) := (size[0], size[1]);
//         var elements_given := a.column_number * a.row_number;
//         if elements_given <> elements_needed then
//             raise new Exception('Wrong size');
//         var return_array := new Real[rows, columns];
//         var tmp := reshape(a, elements_given).values;
//         var counter := 0;
//         for var i:= 0 to rows-1 do
//            for var j:= 0 to columns-1 do
//                begin
//                 return_array[i,j] := tmp[0, counter];
//                 counter += 1;
//                end;
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