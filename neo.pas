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
            property element[row, column: integer]: real
                read values[row, column]
                write values[row, column] := value;
                default;
                
            constructor (existing_arr:array[,] of real);
            // Deklaration einer Matrize durch Massiv:  
            // m := new Matrix(arr[,]);
                begin
                 (row_number, column_number) := 
                  (existing_arr.RowCount, existing_arr.ColCount);
                 values := new Real[row_number, column_number];
                 for var i:= 0 to row_number - 1 do
                     for var j:= 0 to column_number - 1 do 
                         values[i, j] := existing_arr[i, j];
                end;
                      
            constructor (existing_arr:array of real);
            // Deklaration einer Matrize durch Massiv:  
            // m := new Matrix(arr[]);
                begin
                 (row_number, column_number) := (1, existing_arr.Length);
                 values := new Real[row_number, column_number];
                 for var i:= 0 to column_number - 1 do
                         values[0, i] := existing_arr[i];
                end;
              
            constructor (rows, columns:integer);
            // Deklaration einer Nullmatrize durch Zeilen- & Spaltenanzahl:  
            // m := new Matrix(7, 31);
                begin
                 (row_number, column_number) := (rows, columns);
                 values := new Real[row_number, column_number];
                end;  
            
            class function operator + (field_a, field_b:field): field;
            // Matrizenaddition:
            // field_sum := field_a + field_b;
                begin
                 if (field_a.row_number, field_a.column_number) <> (field_b.row_number, field_b.column_number) then
                        raise new Exception('Wrong array sizes');
                 var return_field := new Real[field_a.row_number, field_a.column_number];
                 for var i:= 0 to return_field.RowCount-1 do
                     for var j:= 0 to return_field.ColCount-1 do
                         return_field[i, j] := field_a.values[i, j] + field_b.values[i, j];
                 Result := new field(return_field);    
                end;
            
            class function operator - (field_a, field_b:field): field;
            // Matrizensubtraktion:
            // field_difference := field_a - field_b;
                begin
                 if (field_a.row_number, field_a.column_number) <> (field_b.row_number, field_b.column_number) then
                        raise new Exception('Wrong array sizes');
                 var return_field := new Real[field_a.row_number, field_a.column_number];
                 for var i:= 0 to return_field.RowCount-1 do
                     for var j:= 0 to return_field.ColCount-1 do
                         return_field[i, j] := field_a.values[i, j] - field_b.values[i, j];
                 Result := new field(return_field);
                end;       
            
            class function operator * (field_a:field; b:Real): field;
            // Matrizenmultiplikation mit Zahlen:
            // field_mult := field_a * b;
                begin
                 var return_field := new Real[field_a.row_number, field_a.column_number];
                 for var i:= 0 to field_a.values.RowCount - 1 do
                     for var j:= 0 to field_a.values.ColCount - 1 do
                         return_field[i, j] :=  field_a.values[i, j] * b;
                 Result := new field(return_field);
                end;
            
            class function operator * (a:Real; field_b:field): field;
            // Matrizenmultiplikation mit Zahlen:
            // field_mult := a * field_b;
                begin
                 Result := field_b * a;
                end;
            
            class function operator / (field_a:field; b:Real): field;
            // Matrizendivision mit Zahlen:
            // field_mult := field_a / b;
                begin
                 Result := field_a * (1/b);
                end;
                  
            class function operator * (field_a, field_b:field): field;
            // Matrizenmultiplikation:
            // field_mult := field_a * field_b;
                begin
                 if field_a.column_number = field_b.row_number then
                        raise new Exception('Wrong array sizes');
                 var return_field := new field(field_a.row_number, field_b.column_number);
                 for var i:= 0 to return_field.row_number - 1 do
                     for var j:= 0 to return_field.column_number - 1 do
                         for var k:= 0 to field_a.column_number - 1 do
                             return_field.values[i,j]+= field_a.values[i, k] * field_b.values[k, j];
                 Result := return_field;
                end;
                
            function sum(): real;
            // Summe aller Elemente der Matrize
                begin
                 var s := 0.0;
                 for var i:= 0 to row_number - 1 do
                    for var j:= 0 to column_number - 1 do
                        begin
                         s += values[i,j];
                        end;
                 Result := s;
                end;
                
            function shapes(): array of integer;
            // Dimensionen der Matrize
                begin
                 Result := Arr(row_number, column_number);
                end;
              
            function get_value(): array[,] of real;
            // das Werte der Matrize
                begin
                 Result := values;
                end;
    end;
    
    
    function map(func: float_func; field_a: field): field;
    // Anwendung einer Funktion an alle Elemente einer Neo
    function map(func: int_func; field_a: field): field;
    // Anwendung einer Funktion an alle Elemente einer Neo
    
        
    function random_field(rows, columns:integer): field;
    // Matrizengenerator mit rows*colums, (0, 1)
    function random_field(rows, columns, max:integer): field;
    // Matrizengenerator mit rows*colums, (0, max)
    function random_field(rows, columns, min, max:integer): field;
    // Matrizengenerator mit rows*colums, (min, max)

    
    function reshape(a:field; size:integer): field;
    // Umformung der Matrize in einen eindemensionalen Vektor mit Laenge size
    function reshape(a:field; size:array of integer): field;
    // Umformung der Matrize in eine andere Matrize mit Groeße size
    
    
    function concatenate(a,b:field): field;
    // Erweiterung der Matrize a mit b, zeilenweise
    function concatenate(a,b:field; axis:integer): field;
    // Erweiterung der Matrize a mit b, axis == 0 - zeilenweise, axis == 1 - spaltenweise
    
    
    function multiply(a,b:real): real;
    // Multiplikation von zwei Skalaren
    function multiply(a:real; b:field): field;
    // Multiplikation von Skalar und Matrize
    function multiply(a:field; b:real): field;
    // Multiplikation von Matrize Skalar
    function multiply(a,b:field): field;
    // Multiplikation von zwei Matrizen
    
    
implementation
    
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

//    function multiply(a,b:field): field;
//        begin
//         if a.shapes = b.shapes then
//            begin
//             var return_array := new Real[a.row_number, a.column_number];
//             for var i:= 0 to a.row_number-1 do
//                 for var j:= 0 to a.column_number-1 do
//                    return_array[i,j] := a.values[i,j] * b.values[i,j];
//             Result := new field(return_array);
//            end
//         else if a.row_number = b.row_number then
//            begin
//             var tmp := new field(1,1);
//             var counter := 0;
//             if a.column_number mod b.column_number = 0 then
//                (tmp, counter) := (a, a.column_number div b.column_number)
//             else if b.column_number mod a.column_number = 0 then
//                (tmp, counter) := (b, b.column_number div a.column_number)
//             else
//                raise new Exception('Fields couldn not be broadcast together');
//             var return_array := new Real[tmp.row_number, tmp.column_number];
//             println(tmp.values, counter);
//             for var i:= 1 to counter do
//                begin
//                 
//                end;
//            end
//         else if a.column_number = b.column_number then
//            begin
//            
//            end
//         else
//            raise new Exception('Fields couldn not be broadcast together');
//        end;
//    function multiply(a,b:field): field;
//        begin
//         var (big_field, small_field) := a.shapes.Product > b.shapes.Product?
//                                            (a, b) : (b, a);
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
////                        big_field[
//                        begin end;
//                    
//         Result := big_field;
        end;
end.
