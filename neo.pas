unit Neo;

interface
        
    type
        float_func = System.Func<real, real>;
        int_func = System.Func<real, integer>;
  
    type
        field = class
      
        private
            row_number: integer;
            column_number: integer;
            value: array[,] of real;

        public      
            constructor (existing_arr:array[,] of real);
            // Deklaration einer Matrize durch Massiv:  
            // m := new Matrix(arr[,]);
                begin
                 (row_number, column_number) := 
                  (existing_arr.RowCount, existing_arr.ColCount);
                 value := new Real[row_number, column_number];
                 for var i:= 0 to row_number - 1 do
                     for var j:= 0 to column_number - 1 do 
                         value[i, j] := existing_arr[i, j];
                end;
                      
            constructor (existing_arr:array of real);
            // Deklaration einer Matrize durch Massiv:  
            // m := new Matrix(arr[]);
                begin
                 (row_number, column_number) := (1, existing_arr.Length);
                 value := new Real[row_number, column_number];
                 for var i:= 0 to column_number - 1 do
                         value[0, i] := existing_arr[i];
                end;
              
            constructor (rows, columns:integer);
            // Deklaration einer Nullmatrize durch Zeilen- & Spaltenanzahl:  
            // m := new Matrix(7, 31);
                begin
                 (row_number, column_number) := (rows, columns);
                 value := new Real[row_number, column_number];
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
                         return_field[i, j] := field_a.value[i, j] + field_b.value[i, j];
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
                         return_field[i, j] := field_a.value[i, j] - field_b.value[i, j];
                 Result := new field(return_field);
                end;       
            
            class function operator * (field_a:field; b:Real): field;
            // Matrizenmultiplikation mit Zahlen:
            // field_mult := field_a * b;
                begin
                 var return_field := new Real[field_a.row_number, field_a.column_number];
                 for var i:= 0 to field_a.value.RowCount - 1 do
                     for var j:= 0 to field_a.value.ColCount - 1 do
                         return_field[i, j] :=  field_a.value[i, j] * b;
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
                             return_field.value[i,j]+= field_a.value[i, k] * field_b.value[k, j];
                 Result := return_field;
                end;
                
            function sum(): real;
                begin
                 var s := 0.0;
                 for var i:= 0 to row_number - 1 do
                    for var j:= 0 to column_number - 1 do
                        begin
                         s += value[i,j];
                        end;
                 Result := s;
                end;
                
            function shapes(): array of integer;
                begin
                 Result := Arr(row_number, column_number);
                end;
              
            function get_value(): array[,] of real;
                begin
                 Result := value;
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
    
    
implementation

    function map(func: float_func; field_a: field): field;
        begin
         var return_array := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.row_number - 1 do
            for var j:= 0 to field_a.column_number - 1 do
                return_array[i,j] := func(field_a.value[i,j]);
         Result := new field(return_array);
        end;
    
    function map(func: int_func; field_a: field): field;
        begin
         var return_array := new Real[field_a.row_number, field_a.column_number];
         for var i:= 0 to field_a.row_number - 1 do
            for var j:= 0 to field_a.column_number - 1 do
                return_array[i,j] := func(field_a.value[i,j]);
         Result := new field(return_array);
        end;
        
        
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
         var elements_needed := 1;
         var length := 0; 
         if size.Length < 1 then
             raise new Exception('Size must contain at least 1 argument')
         else
             length := size.Length;
         foreach x: integer in size do
              elements_needed *= x;
         var elements_given := a.column_number * a.row_number;
         if elements_given <> elements_needed then
             raise new Exception('Wrong size');
                      
        end;
end.
