unit Neo;

interface
        
    type
        float_func = System.Func<real, real>;
  
    type
        neo = class
      
        private
            row_number: integer;
            column_number: integer;
            
        public
            value: array[,] of real;
      
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
        
        class function operator + (neo_a, neo_b:neo): neo;
        // Matrizenaddition:
        // neo_sum := neo_a + neo_b;
            begin
             if (neo_a.row_number, neo_a.column_number) <> (neo_b.row_number, neo_b.column_number) then
                    raise new Exception('Wrong array sizes');
             var return_neo := new Real[neo_a.row_number, neo_a.column_number];
             for var i:= 0 to return_neo.RowCount-1 do
                 for var j:= 0 to return_neo.ColCount-1 do
                     return_neo[i, j] := neo_a.value[i, j] + neo_b.value[i, j];
             Result := new neo(return_neo);    
            end;
        
        class function operator - (neo_a, neo_b:neo): neo;
        // Matrizensubtraktion:
        // neo_difference := neo_a - neo_b;
            begin
             if (neo_a.row_number, neo_a.column_number) <> (neo_b.row_number, neo_b.column_number) then
                    raise new Exception('Wrong array sizes');
             var return_neo := new Real[neo_a.row_number, neo_a.column_number];
             for var i:= 0 to return_neo.RowCount-1 do
                 for var j:= 0 to return_neo.ColCount-1 do
                     return_neo[i, j] := neo_a.value[i, j] - neo_b.value[i, j];
             Result := new neo(return_neo);
            end;       
        
        class function operator * (neo_a:neo; b:Real): neo;
        // Matrizenmultiplikation mit Zahlen:
        // neo_mult := neo_a * b;
            begin
             var return_neo := new Real[neo_a.row_number, neo_a.column_number];
             for var i:= 0 to neo_a.value.RowCount - 1 do
                 for var j:= 0 to neo_a.value.ColCount - 1 do
                     return_neo[i, j] :=  neo_a.value[i, j] * b;
             Result := new neo(return_neo);
            end;
        
        class function operator * (a:Real; neo_b:neo): neo;
        // Matrizenmultiplikation mit Zahlen:
        // neo_mult := a * neo_b;
            begin
             Result := neo_b * a;
            end;
        
        class function operator / (neo_a:neo; b:Real): neo;
        // Matrizendivision mit Zahlen:
        // neo_mult := neo_a / b;
            begin
             Result := neo_a * (1/b);
            end;
              
        class function operator * (neo_a, neo_b:neo): neo;
        // Matrizenmultiplikation:
        // neo_mult := neo_a * neo_b;
            begin
             if neo_a.column_number = neo_b.row_number then
                    raise new Exception('Wrong array sizes');
             var return_neo := new neo(neo_a.row_number, neo_b.column_number);
             for var i:= 0 to return_neo.row_number - 1 do
                 for var j:= 0 to return_neo.column_number - 1 do
                     for var k:= 0 to neo_a.column_number - 1 do
                         return_neo.value[i,j]+= neo_a.value[i, k] * neo_b.value[k, j];
             Result := return_neo;
            end;
            
        function Sum(): real;
            begin
             var s := 0.0;
             for var i:= 0 to row_number - 1 do
                for var j:= 0 to column_number - 1 do
                    begin
                     s += value[i,j];
                    end;
             Result:= s;
            end;
    end;
    
    
    function map(func: float_func; neo_a: neo): neo;
        
        
    function random_neo(rows, columns:integer): neo;
    function random_neo(rows, columns, max:integer): neo;
    function random_neo(rows, columns, min, max:integer): neo;
    
    
implementation

    function map(func: float_func; neo_a: neo): neo;
        begin
         var return_array := new Real[neo_a.row_number, neo_a.column_number];
         for var i:= 0 to neo_a.row_number - 1 do
            for var j:= 0 to neo_a.column_number - 1 do
                return_array[i,j] := func(neo_a.value[i,j]);
         Result:= new neo(return_array);
        end;
        
        
    function random_neo(rows, columns:integer): neo;
        begin
         var return_array := new Real[rows, columns];
         for var i:= 0 to rows - 1 do
             for var j:= 0 to columns - 1 do
                return_array[i,j] := Random;
         Result := new neo(return_array);   
        end;
    
    function random_neo(rows, columns, max:integer): neo;
        begin
         Result := map(x -> x + Random(max), random_neo(rows, columns));   
        end;
    
    function random_neo(rows, columns, min, max:integer): neo;
        begin
         Result := map(x -> x + Random(min, max), random_neo(rows, columns));   
        end;    
end.
