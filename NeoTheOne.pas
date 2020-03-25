unit NeoTheOne;

interface

    uses 
        System;
  
    type
        Matrix = class
    
  
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
        
        
        class function operator + (matrix_a, matrix_b:Matrix): Matrix;
        // Matrizenaddition:
        // matrix_sum := matrix_a + matrix_b;
            begin
             Assert((matrix_a.row_number, matrix_a.column_number)=
                        (matrix_b.row_number, matrix_b.column_number),
                    'MatrixOperationError: Different matrix sizes');
             var return_matrix := new Real[matrix_a.row_number, matrix_a.column_number];
             for var i:= 0 to return_matrix.RowCount-1 do
                 for var j:= 0 to return_matrix.ColCount-1 do
                     return_matrix[i, j] := matrix_a.value[i, j] + matrix_b.value[i, j];
             Result := new Matrix(return_matrix);    
            end;
        
        
        class function operator - (matrix_a, matrix_b:Matrix): Matrix;
        // Matrizensubtraktion:
        // matrix_difference := matrix_a - matrix_b;
            begin
             Assert((matrix_a.row_number, matrix_a.column_number)=
                        (matrix_b.row_number, matrix_b.column_number),
                    'MatrixOperationError: Different matrix sizes');
             var return_matrix := new Real[matrix_a.row_number, matrix_a.column_number];
             for var i:= 0 to return_matrix.RowCount-1 do
                 for var j:= 0 to return_matrix.ColCount-1 do
                     return_matrix[i, j] := matrix_a.value[i, j] - matrix_b.value[i, j];
             Result := new Matrix(return_matrix);
            end;
        
        
        class function operator * (matrix_a:Matrix; b:Real): Matrix;
        // Matrizenmultiplikation mit Zahlen:
        // matrix_mult := matrix_a * b;
            begin
             var return_matrix := new Real[matrix_a.row_number, matrix_a.column_number];
             for var i:= 0 to matrix_a.value.RowCount - 1 do
                 for var j:= 0 to matrix_a.value.ColCount - 1 do
                     return_matrix[i, j] :=  matrix_a.value[i, j] * b;
             Result := new Matrix(return_matrix);
            end;
        
        
        class function operator * (a:Real; matrix_b:Matrix): Matrix;
        // Matrizenmultiplikation mit Zahlen:
        // matrix_mult := a * matrix_b;
            begin
             Result := matrix_b * a;
            end;
        
        
        class function operator / (matrix_a:Matrix; b:Real): Matrix;
        // Matrizendivision mit Zahlen:
        // matrix_mult := matrix_a / b;
            begin
             Result := matrix_a * (1/b);
            end;
        
        
        class function operator * (matrix_a, matrix_b:Matrix): Matrix;
        // Matrizenmultiplikation:
        // matrix_mult := matrix_a * matrix_b;
            begin
             Assert(matrix_a.column_number = matrix_b.row_number, 
                   'MatrixOperationError: Different matrix sizes');
             var return_matrix := new Matrix(matrix_a.row_number, matrix_b.column_number);
             for var i:= 0 to return_matrix.row_number - 1 do
                 for var j:= 0 to return_matrix.column_number - 1 do
                     for var k:= 0 to matrix_a.column_number - 1 do
                         return_matrix.value[i,j]+= matrix_a.value[i, k] * matrix_b.value[k, j];
             Result:= return_matrix;
            end;
    end;


implementation

end.
