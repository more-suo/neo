unit neo;

interface

        
    type
        float_func = System.Func<real, real>;
        int_func = System.Func<real, integer>;
        
    type
        field = class
      
        private
            row_number: integer;
            column_number: integer;
            values: array[,] of real;

        public
        
            /// Zugriff auf Elemente einer Matrize
            property element[row, column: integer]: real
                read values[row, column]
                write values[row, column] := value;
                default;
            
            /// Deklaration einer Matrize durch Massiv:  
            /// m := new Matrix(arr[,]);    
            constructor (existing_arr:array[,] of real);
                
            /// Deklaration einer Matrize durch Massiv:  
            /// m := new Matrix(arr[]);          
            constructor (existing_arr:array of real);
                
            /// Deklaration einer Nullmatrize durch Zeilen- & Spaltenanzahl:  
            /// m := new Matrix(7, 31);  
            constructor (rows, columns:integer);
            
            /// konvertiert Matriz zu String
            function ToString: string; override;
    
            /// Matrizenaddition:
            /// field_sum := field_a + b;
            class function operator + (field_a:field; b:Real): field;
           
            /// Matrizenaddition:
            /// field_sum := a + field_b;
            class function operator + (a:Real; field_b:field): field;
           
            /// Matrizenaddition:
            /// field_sum := field_a + field_b;
            class function operator + (field_a, field_b:field): field;
           
            /// Matrizenaddition:
            /// field_sum += field_b; 
            class procedure operator += (var field_a:field; const field_b:field);
            
            /// Matrizenaddition:
            /// field_sum += b; 
            class procedure operator += (var field_a:field; const b:Real);
                        
            /// Matrizensubtraktion:
            /// field_sum := field_a - b;
            class function operator - (field_a:field; b:Real): field;
                
            /// Matrizensubtraktion:
            /// field_difference := field_a - field_b;
            class function operator - (field_a, field_b:field): field;
            
            /// Matrizensubtraktion:
            /// field_difference -= field_b;    
            class procedure operator -= (var field_a:field; const field_b:field);
            
            /// Matrizensubtraktion:
            /// field_sum -= b; 
            class procedure operator -= (var field_a:field; const b:Real);
                
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := field_a * b;
            class function operator * (field_a:field; b:Real): field;
            
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult *= b;
            class procedure operator *= (var field_a:field; const b:Real);
            
            /// Matrizenmultiplikation mit Zahlen:
            /// field_mult := a * field_b;
            class function operator * (a:Real; field_b:field): field;
                
            /// Matrizendivision mit Zahlen:
            /// field_div := field_a / b;
            class function operator / (field_a:field; b:Real): field;
            
            /// Matrizendivision mit Zahlen:
            /// field_div /= b;
            class procedure operator /= (var field_a:field; const b:Real);
            
            /// Matrizenmultiplikation:
            /// field_mult := field_a * field_b;                  
            class function operator * (field_a, field_b:field): field;
                
            /// Matrizenmultiplikation:
            /// field_mult *= field_b;                  
            class procedure operator *= (var field_a:field; const field_b:field);
                
            /// Exponentiation vom jeden Matrizenelements:
            /// field_exp := field_a ** b
            class function operator ** (var field_a:field; const b:real): field;
                
            /// Summe aller Elemente der Matrize
            function sum(): real;
            
            /// wenn axis = 0, Summe aller Spalten; wenn axis = 1, Summe aller Zeilen
            function sum(axis:integer): field;
                
            /// Dimensionen der Matrize
            function shape(): array of integer;
              
            /// das Werte der Matrize
            function get_value(): array[,] of real;
            
            /// kehrt den groeßten Wert der Matrize zurueck
            function get_max(): real;
                
            /// kehrt den laengsten Wert der Matrize zurueck
            function get_longest(): real;
            
            /// Wenn axis = 0 laengster Wert in der Spaltennummer num,
            /// wenn axis = 1 laengster Wert in der Zeile
            function get_longest(axis, num:integer): real;
                     
            /// Erstellt eine Kopie der Matrize
            function copy(): field;
    end;
    
    
    /// Summe aller Elemente der Matrize
    function sum(a:field): real;
    
    /// wenn axis = 0, Summe aller Spalten; wenn axis = 1, Summe aller Zeilen
    function sum(a:field; axis:integer): field;
        
    
    /// Dimensionen der Matrize
    function shape(a:field): array of integer;
      
      
    /// das Werte der Matrize
    function get_value(a:field): array[,] of real;
    
    
    /// kehrt den groeßten Wert der Matrize zurueck
    function get_max(a:field): real;
      
      
    /// kehrt den laengsten Wert der Matrize zurueck
    function get_longest(a:field): real;
    
    /// Wenn axis = 0 laengster Wert in der Spaltennummer num,
    /// wenn axis = 1 laengster Wert in der Zeile
    function get_longest(a:field; axis, num:integer): real;
      
      
    /// Erstellt eine Kopie der Matrize
    function copy(a:field): field;
    
    
    /// Vergleich von zwei arrays of integer
//    function compare(a,b:array of integer): boolean;
    
    /// Anwendung einer Funktion an alle Elemente einer Neo
    function map(func: float_func; field_a: field): field;
    /// Anwendung einer Funktion an alle Elemente einer Neo
    function map(func: int_func; field_a: field): field;
    
        
    /// Matrizengenerator mit rows*colums, (0, 1)
    function random_field(rows, columns:integer): field;
    /// Matrizengenerator mit rows*colums, (0, max)
    function random_field(rows, columns, max:integer): field;
    /// Matrizengenerator mit rows*colums, (min, max)
    function random_field(rows, columns, min, max:integer): field;

    
    /// Umformung der Matrize in einen eindemensionalen Vektor mit Laenge size
    function reshape(a:field; size:integer): field;
    /// Umformung der Matrize in eine andere Matrize mit Groeße size
    function reshape(a:field; size:array of integer): field;
    
    
    /// Erweiterung der Matrize a mit b, zeilenweise
    function concatenate(a,b:field): field;
    /// Erweiterung der Matrize a mit b, axis == 0 - zeilenweise, axis == 1 - spaltenweise
    function concatenate(a,b:field; axis:integer): field;
    
    
    /// Multiplikation von zwei Skalaren
    function multiply(a,b:real): real;
    /// Multiplikation von Skalar und Matrize
    function multiply(a:real; b:field): field;
    /// Multiplikation von Matrize und Skalar
    function multiply(a:field; b:real): field;
    /// Multiplikation von zwei Matrizen
    function multiply(a,b:field): field;
    
    
    /// Transponierung der Matrize
    function transpose(field_a:field): field;
    
    
    /// Summe des Skalarproduktes von zwei Vektoren
    function dot(field_a, field_b: field): field;
        
        
implementation
    
   function compare(a, b:array of integer): boolean;
        begin 
         Result := False;
         if a.Length <> b.Length then
             exit;
         for var i:= 0 to a.Length-1 do
             if a[i] <> b[i] then
                  exit;
         Result := True;
        end;
        
        
    // field.Create() - Implementierung
    constructor field.Create(existing_arr:array[,] of real);
        begin
         (row_number, column_number) := 
          (existing_arr.RowCount, existing_arr.ColCount);
         values := new Real[row_number, column_number];
         for var i:= 0 to row_number - 1 do
             for var j:= 0 to column_number - 1 do 
                 values[i, j] := existing_arr[i, j];
        end;
    
    constructor field.Create(existing_arr:array of real);
        begin
         (row_number, column_number) := (1, existing_arr.Length);
         values := new Real[row_number, column_number];
         for var i:= 0 to column_number - 1 do
                 values[0, i] := existing_arr[i];
        end;
    
    constructor field.Create(rows, columns:integer);
        begin
         (row_number, column_number) := (rows, columns);
         values := new Real[row_number, column_number];
        end;  
    
    // field.ToString() - Implementierung
    function field.ToString: string;
        begin
         var head := row_number = 1? 'Array(': 'Array([';
         var foot := '])';
         var return_string := '';
         var newline := chr(13) + chr(10);
         var spaces := '';
         
         if column_number <> 1 then
             begin
              for var row:= 0 to row_number-1 do
                   for var column := 0 to column_number-1 do
                       begin
                        spaces := ' ' * (self.get_longest(0, column).ToString.Length - values[row,column].ToString.Length);
                        if (column, row) = (0, 0) then
                            return_string += '[' + spaces + values[row,column].ToString + ', '
                        else if (column = 0) then
                            return_string += ' ' * head.Length + '[' + spaces + values[row,column].ToString + ', '
                        else if (row, column) = (row_number-1, column_number-1) then
                            return_string += spaces + values[row,column].ToString + ']'
                        else if column = column_number-1 then
                            return_string += spaces + values[row,column].ToString + '], ' + newline
                        else
                            return_string += spaces + values[row,column].ToString + ', ';
                       end;
              Result := head + return_string + foot;
             end
         else
             begin
              for var row:= 0 to row_number-1 do
                  begin
                   spaces := ' ' * (self.get_longest().ToString.Length - values[row,0].ToString.Length);
                   if row = 0 then
                       return_string += '[' +  spaces + values[row, 0].ToString +'],' + newline
                   else if row = row_number - 1 then
                       return_string += head.Length * ' ' + '[' +  spaces + values[row, 0].ToString + ']'
                   else
                       return_string += head.Length * ' ' + '[' +  spaces + values[row, 0].ToString +'],' + newline;
                  end;
              Result := head + return_string + foot; 
             end;
        end;
        
    // field.operator + () and field.operator += () - Implementierung
    class function field.operator + (field_a:field; b:Real): field;
        begin
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to return_field.RowCount-1 do
             for var j:= 0 to return_field.ColCount-1 do
                 return_field[i, j] := field_a.values[i, j] + b;
         Result := new field(return_field);    
        end;
        
    class function field.operator + (a:Real; field_b:field): field;
        begin
         Result := field_b + a;    
        end;
        
    class function field.operator + (field_a, field_b:field): field;
        begin
         if not compare(field_a.shape, field_b.shape) then
                raise new System.ArithmeticException('Wrong array sizes');
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to return_field.RowCount-1 do
             for var j:= 0 to return_field.ColCount-1 do
                 return_field[i, j] := field_a.values[i, j] + field_b.values[i, j];
         Result := new field(return_field);    
        end;
        
    class procedure field.operator += (var field_a:field; const field_b:field);
        begin
         if not compare(field_a.shape, field_b.shape) then
                raise new Exception('Wrong array sizes');
         field_a := field_a + field_b;
        end;
    
    class procedure field.operator += (var field_a:field; const b:Real);
        begin
         field_a := field_a + b;
        end;
        
    // field.operator - () and field.operator -= () - Implementierung        
    class function field.operator - (field_a:field; b:Real): field;
        begin
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to return_field.RowCount-1 do
             for var j:= 0 to return_field.ColCount-1 do
                 return_field[i, j] := field_a.values[i, j] - b;
         Result := new field(return_field);    
        end;
        
    class function field.operator - (field_a, field_b:field): field;
        begin
         if not compare(field_a.shape, field_b.shape) then
                raise new System.ArithmeticException('Wrong array sizes');
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to return_field.RowCount-1 do
             for var j:= 0 to return_field.ColCount-1 do
                 return_field[i, j] := field_a.values[i, j] - field_b.values[i, j];
         Result := new field(return_field);
        end;       
    
    class procedure field.operator -= (var field_a:field; const field_b:field);
        begin
         if not compare(field_a.shape, field_b.shape) then
                raise new Exception('Wrong array sizes');
         field_a := field_a - field_b;
        end;
    
    class procedure field.operator -= (var field_a:field; const b:Real);
        begin
         field_a := field_a - b;
        end;
        
    // field.operator * () and field.operator *= () - Implementierung
    class function field.operator * (field_a:field; b:Real): field;
        begin
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.values.RowCount - 1 do
             for var j:= 0 to field_a.values.ColCount - 1 do
                 return_field[i, j] :=  field_a.values[i, j] * b;
         Result := new field(return_field);
        end;
    
    class procedure field.operator *= (var field_a:field; const b:Real);
        begin
         field_a := field_a * b;
        end;
    
    class function field.operator * (a:Real; field_b:field): field;
        begin
         Result := field_b * a;
        end;
                          
    class function field.operator * (field_a, field_b:field): field;
        begin
         if not compare(field_a.shape, field_b.shape) then
                raise new System.ArithmeticException('Wrong array sizes');
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to return_field.RowCount-1 do
             for var j:= 0 to return_field.ColCount-1 do
                 return_field[i, j] := field_a.values[i, j] * field_b.values[i, j];
         Result := new field(return_field);
        end;
                
    class procedure field.operator *= (var field_a:field; const field_b:field);
        begin
         field_a := field_a * field_b;
        end;
        
    // field.operator / () and field.operator /= () - Implementierung
    class function field.operator / (field_a:field; b:Real): field;
        begin
         if b = 0 then
             raise new System.ArithmeticException('ZeroDivisionError');
         Result := field_a * (1/b);
        end;
    
    class procedure field.operator /= (var field_a:field; const b:Real);
        begin
         field_a := field_a / b;
        end;
    
    // field.operator ** () - Implementierung
    class function field.operator ** (var field_a:field; const b:real): field;
        begin
         var return_field := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.row_number - 1 do
             for var j:= 0 to field_a.column_number - 1 do
                 return_field[i, j] :=  field_a.values[i, j] ** b;
         Result := new field(return_field);
        end;
        
    // field.sum() - Implementierung
    function field.sum(): real;
        begin
         var s := 0.0;
         for var i:= 0 to row_number - 1 do
             for var j:= 0 to column_number - 1 do
                 begin
                  s += values[i,j];
                 end;
         Result := s;
        end;
    
    function field.sum(axis:integer): field;
        begin
         var return_array := new Real[1];
         if axis = 0 then
             begin
              setlength(return_array, column_number);
              for var column:= 0 to column_number-1 do
                  for var row:= 0 to row_number-1 do
                      return_array[column] += values[row,column];
             end
         else if axis = 1 then
             begin
              setlength(return_array, row_number);
              for var row:= 0 to row_number-1 do
                  for var column:= 0 to column_number-1 do
                      return_array[row] += values[row,column];
             end
         else
             raise new Exception('No third dimension');
         Result := new field(return_array);
        end;
        
    // field.shape() - Implementierung
    function field.shape(): array of integer;
        begin
         Result := Arr(row_number, column_number);
        end;
      
    // field.get_value() - Implementierung
    function field.get_value(): array[,] of real;
        begin
         Result := values;
        end;
    
    // field.get_max() - Implementierung
    function field.get_max(): real;
        begin
         var max := values[0,0];
         for var row:= 0 to row_number-1 do
             for var column:= 0 to column_number-1 do
                 if values[row, column] >  max then
                     max := values[row, column];
         Result := max;
        end;
        
    // field.get_longest() - Implementierung
    function field.get_longest(): real;
        begin
         var max := values[0,0];
         for var row:= 0 to row_number-1 do
             for var column:= 0 to column_number-1 do
                 if values[row, column].ToString.Length >  max.ToString.Length then
                     max := values[row, column];
         Result := max;
        end;
    
    function field.get_longest(axis, num:integer): real;
        begin
         if axis = 0 then
             begin
              var max := values[0, num];
              for var row:= 0 to row_number-1 do
                      if values[row, num].ToString.Length >  max.ToString.Length then
                          max := values[row, num];
              Result := max;
             end
         else if axis = 1 then
            begin
             var max := values[num,0];
             for var column:= 0 to column_number-1 do
                     if values[num, column].ToString.Length >  max.ToString.Length then
                         max := values[num, column];
             Result := max;
            end
        end;
    
    // field.copy() - Implementierung
    function field.copy(): field;
        begin
         Result := new field(values);
        end;
    
      
    // sum() - Implementierung
    function sum(a:field): real;
        begin
         Result := a.sum();
        end;
    
    function sum(a:field; axis:integer): field;
        begin
         Result := a.sum(axis);
        end;
      
      
    // shape() - Implementierung
    function shape(a:field): array of integer;
        begin
         Result := a.shape();
        end;
      
      
    // get_value() - Implementierung
    function get_value(a:field): array[,] of real;
        begin
         Result := a.get_value();
        end;
    
    
    // get_max() - Implementierung
    function get_max(a:field): real;
        begin
         Result := a.get_max();
        end;
    
    
    // get_longest() - Implementierung
    function get_longest(a:field): real;
        begin
         Result := a.get_longest();
        end;
    
    function get_longest(a:field; axis, num:integer): real;
        begin
         Result := a.get_longest(axis, num);
        end;
   
   
    // copy() - Implementierung
    function copy(a: field): field;
        begin
         Result := a.copy();
        end;
 
        
    // map() - Implementierung
    function map(func: float_func; field_a: field): field;
        begin
         var return_array := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.row_number - 1 do
            for var j:= 0 to field_a.column_number - 1 do
                return_array[i,j] := func(field_a.values[i,j]);
         Result := new field(return_array);
        end;
    
    function map(func: int_func; field_a: field): field;
        begin
         var return_array := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.row_number - 1 do
            for var j:= 0 to field_a.column_number - 1 do
                return_array[i,j] := func(field_a.values[i,j]);
         Result := new field(return_array);
        end;
        
        
    // random_field() - Implementierung
    function random_field(rows, columns:integer): field;
        begin
         var return_array := new Real[rows, columns];
         for var i:= 0 to rows - 1 do
             for var j:= 0 to columns - 1 do
                return_array[i,j] := Random;
         Result := new field(return_array);   
        end;
 
    function random_field(rows, columns, max:integer): field;
        begin
         var return_array := new Real[rows, columns];
         for var i:= 0 to rows - 1 do
             for var j:= 0 to columns - 1 do
                return_array[i,j] := Random + Random(max);
         Result := new field(return_array);
        end;
    
    function random_field(rows, columns, min, max:integer): field;
        begin
         var return_array := new Real[rows, columns];
         for var i:= 0 to rows - 1 do
             for var j:= 0 to columns - 1 do
                return_array[i,j] := Random + Random(min, max);
         Result := new field(return_array);
        end;    
    
    
    // reshape() - Implementierung
    function reshape(a:field; size:integer): field;
        begin
         if a.column_number * a.row_number <> size then
            raise new Exception('Wrong size');
         var counter := 0;
         var return_array := new Real[size];
         foreach var element in a.get_value do
                begin
                 return_array[counter] := element;
                 counter += 1;
                end;
         Result := new field(return_array);
        end;
        
    function reshape(a:field; size:array of integer): field;
        begin
         var rows := 0;
         var columns := 0;
         var elements_needed := 1;
         if size.Length < 1 then
             raise new Exception('Size must contain at least 1 argument');
         foreach x: integer in size do
              elements_needed *= x;
         if size.Length = 1 then
            (rows, columns) := (size[0], 1)
         else if size.Length = 2 then
            (rows, columns) := (size[0], size[1]);
         var elements_given := a.column_number * a.row_number;
         if elements_given <> elements_needed then
             raise new Exception('Wrong size');
         var return_array := new Real[rows, columns];
         var tmp := reshape(a, elements_given).values;
         var counter := 0;
         for var i:= 0 to rows-1 do
            for var j:= 0 to columns-1 do
                begin
                 return_array[i,j] := tmp[0, counter];
                 counter += 1;
                end;
         Result := new field(return_array);
        end;
    
    
    // concatenate() - Implementierung
    function concatenate(a,b:field): field;
        begin
         if a.column_number <> b.column_number then
            raise new Exception('Fields couldn not be broadcast together');
         var return_array := new Real[1,1];
         SetLength(return_array, a.row_number+b.row_number, a.column_number);
         for var column:= 0 to a.column_number-1 do
             begin
              for var row:= 0 to a.row_number-1 do
                  return_array[row,column] := a.values[row,column];
              for var row:= 0 to b.row_number-1 do
                  return_array[row+a.row_number,column] := b.values[row, column];
             end;
         Result := new field(return_array); 
        end;
    
    function concatenate(a,b:field; axis:integer): field;
        begin
         if axis = 0 then
             Result:= concatenate(a,b)
         else if axis = 1 then
             begin
              if a.row_number <> b.row_number then
                  raise new Exception('Fields couldn not be broadcast together');
              var return_array := new Real[1,1];
              SetLength(return_array, a.column_number+b.column_number, a.row_number);
              for var row:= 0 to a.row_number-1 do
                  begin
                   for var column:= 0 to a.column_number-1 do
                       return_array[row,column] := a.values[row,column];
                   for var column:= 0 to b.column_number-1 do
                       return_array[row,column+a.column_number] := b.values[row, column];
                  end;
              Result := new field(return_array);
             end;
        end;
        
        
    // multiply() - Implementierung
    function multiply(a,b:real): real;
        begin
         Result := a * b;
        end;
    
    function multiply(a:real; b:field): field;
        begin
         Result := a * b;
        end;
        
    function multiply(a:field; b:real): field;
        begin
         Result := a * b;
        end;

    function multiply(a,b:field): field;
        begin
         var (big_field, small_field) := a.shape.Product > b.shape.Product?
                                            (a.copy, b.copy) : (b.copy, a.copy);
         var row_mod := big_field.row_number mod small_field.row_number;
         var column_mod := big_field.column_number mod small_field.column_number;
         if (row_mod <> 0) or (column_mod <> 0) then
             raise new Exception('Fields could not be broadcast together');
         var row_div := big_field.row_number div small_field.row_number;
         var column_div := big_field.column_number div small_field.column_number;
         for var row_block:= 0 to row_div-1 do
             for var column_block:= 0 to column_div-1 do
                 for var row:= 0 to small_field.row_number-1 do
                    for var column:= 0 to small_field.column_number-1 do
                        big_field[row+row_block*small_field.row_number,column+column_block*small_field.column_number] *= 
                            small_field[row,column];
         Result := big_field;
        end;
        
        
    // transpose() - Implementierung    
    function transpose(field_a:field): field;
        begin
         var return_array := new Real[field_a.column_number, field_a.row_number];
         for var i:= 0 to field_a.row_number-1 do
             for var j:= 0 to field_a.column_number-1 do
                 return_array[j,i] := field_a[i,j];
         Result := new field(return_array);
        end;
        
    
    // dot() - Implementierung
    function dot(field_a, field_b: field): field;
        begin
         if ((field_a.row_number, field_b.row_number) = (1, 1)) and
            (field_a.column_number = field_b.column_number) then
             Result := field_a * field_b
         else if (field_a.column_number = field_b.row_number) then
            begin
            var return_field := new field(field_a.row_number, field_b.column_number);
             for var i:= 0 to return_field.row_number - 1 do
                 for var j:= 0 to return_field.column_number - 1 do
                     for var k:= 0 to field_a.column_number - 1 do
                         return_field.values[i,j]+= field_a.values[i, k] * field_b.values[k, j];
             Result := return_field;
            end
         else
            raise new Exception('Wrong array sizes');
        end;
end.