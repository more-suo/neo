unit neo;

interface
    type       
        &Type = abstract class
          protected 
            function neg(other: &Type): &Type; abstract;
            function add(other: &Type): &Type; abstract;
            function sub(other: &Type): &Type; abstract;
            function mul(other: &Type): &Type; abstract;
            function &div(other: &Type): &Type; abstract;
            function pow(other: &Type): &Type; abstract;

          public
            class function operator-(x1: &Type): &Type;
            begin
              result := x1.neg();
            end;
            class function operator+(x1, x2: &Type): &Type;
            begin
              result := x1.add(x2);
            end;
            class function operator-(x1, x2: &Type): &Type;
            begin
              result := x1.sub(x2);
            end;
            class function operator*(x1, x2: &Type): &Type;
            begin
              result := x1.mul(x2);
            end;
            class function operator/(x1, x2: &Type): &Type;
            begin
              result := x1.div(x2);
            end;
            class function operator**(x1, x2: &Type): &Type;
            begin
              result := x1.pow(x2);
            end;
        end;
          
        Int = class(neo.&Type)
          private
            value: integer;
          public
            constructor Create (x: integer);
            begin
              self.value := x;
            end;
            class function operator explicit(x: Int): integer;
            begin
              Result := x.value;
            end;
            class function operator explicit(x: Int): real;
            begin
              Result := x.value;
            end;
            function neg(): neo.&Type; override;
            begin
              Result := new Int(-Int(self).value)
            end;
            function add(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Int(Int(self).value + Int(other).value);
            end;
            function sub(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Int(Int(self).value - Int(other).value);
            end;
            function mul(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Int(Int(self).value * Int(other).value);
            end;
            function &div(other: neo.&Type): Int;
            begin
              Result := new Float(Int(self).value / Int(other).value);
            end;
            function pow(other: neo.&Type): Int;
            begin
              Result := new Float(Int(self).value ** Int(other).value);
            end;
            function toString: String; override;
            begin
              Result := self.value.ToString;
            end;
        end;
 
        Float = class(neo.&Type)
          private
            value: real;
          public
            constructor Create (x: real);
            begin
              self.value := x;
            end;
            class function operator implicit(x: integer): Float;
            begin
              Result := new Float(x);
            end;
            class function operator explicit(x: Float): real;
            begin
              Result := x.value;
            end;
            class function neg(): neo.&Type; override;
            begin
              Result := new Float(-Float(self).value);
            end;
            function add(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Float(Float(self).value + Float(other).value);
            end;
            function sub(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Float(Float(self).value - Float(other).value);
            end;
            function mul(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Float(Float(self).value * Float(other).value);
            end;
            function &div(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Float(Float(self).value / Float(other).value);
            end;
            function pow(other: neo.&Type): neo.&Type; override;
            begin
              Result := new Float(Float(self).value ** Float(other).value);
            end;
            function toString: String; override;
            begin
              Result := self.value.ToString;
            end;
        end;
 
        
        ndarray = class //(System.IEquatable<ndarray>)
        
        private
            value: array of neo.&Type;      
            iter_array: array of integer;
            shape: array of integer;
            length: integer;
            rank: integer;
            
            constructor Create(const value: array of neo.&Type; const shape: array of integer);
            
//            function __get_index_generator(): function(): array of integer;
//            
//            function __get_item_generator(): System.Func;
//            
//            function __get_item(index: array of integer): neo.&Type;
//            
//            procedure __set_item(val: neo.&Type; index: array of integer);
            
            static function __get_iter_array(const shape: array of integer): array of integer;
            
        public            
            constructor Create(array_ptr: object);
            
//            constructor Create(const shape: array of integer);
            
            function ToString: string; override;
    
            class function operator+(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
           
            class function operator+(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
           
            class function operator+(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
           
            class procedure operator+=(var self_ndarray, other_ndarray: neo.ndarray);
            
            class procedure operator+=(var self_ndarray: neo.ndarray; number: neo.&Type);
            
//            class function operator-(self_ndarray: neo.ndarray): neo.ndarray;
                        
            class function operator-(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
            
            class function operator-(number: neo.&Type; self_ndarray: neo.ndarray): neo.ndarray;
                
            class function operator-(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
            
            class procedure operator-=(var self_ndarray: neo.ndarray; other_ndarray: neo.ndarray);
            
            class procedure operator-=(var self_ndarray: neo.ndarray; number: neo.&Type);
                
            class function operator*(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;

            class function operator*(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
            
            class function operator*(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
            
            class procedure operator*=(var self_ndarray: neo.ndarray; const number: neo.&Type);

            class procedure operator*=(var self_ndarray: neo.ndarray; const other_ndarray: neo.ndarray);
                
//            class function operator/(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
            
//            class function operator/(number: neo.&Type; self_ndarray: neo.ndarray): neo.ndarray;
            
//            class function operator/(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
            
//            class procedure operator/=(var self_ndarray: neo.ndarray; number: neo.&Type);
            
//            class procedure operator/=(var self_ndarray: neo.ndarray; other_ndarray: neo.ndarray);

//            class function operator**(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
                
//            class function operator**(number: neo.&Type; self_ndarray: neo.ndarray): neo.ndarray;
                
//            class function operator**(self_ndarray: neo.ndarray; other_ndarray: neo.ndarray): neo.ndarray;
            
//            class function operator=(self_ndarray: neo.ndarray; other_ndarray: neo.ndarray): boolean;
//                
//            function Equals(other_ndarray: neo.ndarray): boolean;
//            
//            function Equals(obj: object): boolean; override;
//                
//            function get(params index: array of integer): neo.&Type;
//   
//            procedure assign(val: neo.&Type; params index: array of integer);
//            
//            function get_shape(): array of integer;
//            
//            function copy(): neo.ndarray;
//            
//            function dot(other_ndarray: neo.ndarray; axis: integer := 0): neo.ndarray;
//            
//            function map(func: System.Func<neo.&Type, neo.&Type>): neo.ndarray;
//            
//            function max(): neo.&Type;
//            
//            function reshape(shape: array of integer): neo.ndarray;
//            
//            function sum(axis: integer := -1): neo.ndarray;
//            
//            procedure save(bw: System.IO.BinaryWriter);
//    
//            static function load(br: System.IO.BinaryReader): neo.ndarray;
//
//            function transpose(axes: array of integer := nil): neo.ndarray;
    end;
   
//    function arange(stop: integer): neo.ndarray<integer>;
//    
//    function arange(start, stop: integer): neo.ndarray<integer>;
//
//    function arange(start, stop, step: integer): neo.ndarray<integer>;
//   
////    function concatenate(a, b: neo.ndarray; axis: integer := -1): neo.ndarray;
////    where neo.&Type: neo.&Type;
//   
//    function copy(self_ndarray: neo.ndarray): neo.ndarray;
//    where neo.&Type: neo.&Type;
//   
//    function dot(self_ndarray: neo.ndarray; other_ndarray: neo.ndarray; axis: integer := 0): neo.ndarray;
//    where neo.&Type: neo.&Type;
//   
//    function map(func: System.Func<neo.&Type, neo.&Type>; self_ndarray: neo.ndarray): neo.ndarray;
//    where neo.&Type: neo.&Type;
//    
//    function max(self_ndarray: neo.ndarray): neo.&Type;
//    where neo.&Type: neo.&Type;
    
    function multiply(number_a, number_b: neo.&Type): neo.&Type;
    
    function multiply(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
    
    function multiply(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
    
    function multiply(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
    
//    function random_ndarray(shape: array of integer): neo.ndarray;
//         
//    function reshape(self_ndarray: neo.ndarray; shape: array of integer): neo.ndarray;
//    where neo.&Type: neo.&Type;
//         
//    function sum(self_ndarray: neo.ndarray; axis: integer := -1): neo.ndarray;
//    where neo.&Type: neo.&Type;
//         
//    function transpose(self_ndarray: neo.ndarray; axes: array of integer := nil): neo.ndarray;
//    where neo.&Type: neo.&Type;
         
implementation

    function areEqual(a, b: array of integer): boolean;
    begin
      if a.Length <> b.Length then
        begin
        result := false;
        exit;
        end;

      result := true;

      {$omp parallel for}
      for var i := 0 to a.Length-1 do
        if a[i] <> b[i] then
          begin
          result := false;
          exit;
          end;
    end;
    
    
//    type indexGenerator = class
//      rank: integer;
//      shape: array of integer;
//      index: array of integer;
//
//      function next(): array of integer;
//      begin
//        self.index[self.rank-1] += 1;
//        for var i := self.rank-1 downto 0 do
//          if self.index[i] = self.shape[i] then
//            if i = 0 then
//              self.index := ArrFill(self.rank, 0)
//            else
//              begin
//              self.index[i-1] += 1;
//              self.index[i] := 0;
//              end;
//        result := self.index;
//      end;
//    end;
//
//
//    function ndarray.__get_index_generator(): function(): array of integer;
//    begin
//      var obj := new indexGenerator;
//      obj.rank := self.rank;
//      obj.shape := self.shape;
//      obj.index := ArrFill(self.rank, 0);
//      obj.index[self.rank-1] := -1;
//      result := obj.next;
//    end;
//
//    
//    type itemGenerator = class
//      index: integer;
//      value: array of neo.&Type;
//
//      function next(): neo.&Type;
//      begin
//        self.index += 1;
//        if self.index = self.value.Length then
//          self.index := 0;
//        result := self.value[self.index];
//      end;
//    end;
//    
//
//    function ndarray.__get_item_generator(): System.Func;
//    begin
//      var obj := new itemGenerator;
//      obj.index := -1;
//      obj.value := self.value;
//      result := obj.next;
//    end;
//    
//    
//    function ndarray.__get_item(index: array of integer): neo.&Type;
//    begin
//      var acc := 0;
//      for var i := 0 to index.Length-1 do
//        acc += self.iter_array[i] * index[i];
//      Result := self.value[acc];
//    end;
//    
//    
//    procedure ndarray.__set_item(val: neo.&Type; index: array of integer);
//    begin
//      var acc := 0;
//      for var i := 0 to index.Length-1 do
//        acc += self.iter_array[i] * index[i];
//      self.value[acc] := val;
//    end;
//

    static function ndarray.__get_iter_array(const shape: array of integer): array of integer;
    begin
      var rank := shape.Length;
      var iter_array := new integer[rank];
      iter_array[rank-1] := 1;
      for var index := 1 to rank-1 do
        iter_array[rank-index-1] := iter_array[rank-index] * shape[rank-index];
      result := iter_array;
    end;
    
        
    {$region Конструкторы}
    constructor ndarray.Create(const value: array of neo.&Type; const shape: array of integer);
    begin
      self.value := value;
      self.shape := shape;
      self.rank := shape.Length;
      self.length := shape.Product;
      self.iter_array := __get_iter_array(shape);
    end;
    
    function as_1darray(arr: System.Array; shape: List<integer>; counter: integer := 0): System.Tuple<array of neo.&Type, List<integer>>;
    begin
      var darray := new List<neo.&Type>();
      if shape.Count <= counter then
        shape.Add(arr.Length);
      for var i := 0 to arr.Length-1 do
        if arr.GetValue(i) is neo.&Type then
          darray.Add(arr.GetValue(i) as neo.&Type)
        else
          begin
          var (new_arr, new_shape) := as_1darray(arr.GetValue(i) as System.Array, shape, counter+1);  
          darray.AddRange(new_arr.Cast&<neo.&Type>());
          end;
      result := (darray.ToArray, shape);
    end;
    
    constructor ndarray.Create(array_ptr: object);
    var tmp_ptr : ^^integer;
        shape_ptr : ^integer;
        element_ptr : neo.&Type;
        size : ^integer;
    begin
      var (Arr, shape) := as_1darray(array_ptr as System.Array, new List <integer>);
      self.length := Arr.length;
      self.rank := shape.Count;
      self.shape := shape.ToArray();
      self.iter_array := __get_iter_array(self.shape);
      self.value := arr;
    end;
    
    
//    constructor ndarray.Create(const shape: array of integer);
//    begin
//      self.shape := shape;
//      self.rank := shape.Length;
//      self.length := shape.Product;
//      self.iter_array := __get_iter_array(shape);
//      self.value := new neo.&Type[self.length]; 
//    end;  
    
    
    {$endregion}
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
        result += self.value[index].ToString+', ';
        end;
      result := result.Remove(result.Length-2, 2);
      result += ']'*self.rank;
    end;
    
        
    {$region Арифметические операции}    
    class function ndarray.operator+(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
    begin
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := self_ndarray.value[i] + number;
      result := new ndarray(tmp_result, self_ndarray.shape);
    end;
    
    
    class function ndarray.operator+(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
    begin
      Result := other_ndarray + number;    
    end;
        
        
    class function ndarray.operator+(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := self_ndarray.value[i] + other_ndarray.value[i]; 
      Result := new ndarray(tmp_result, self_ndarray.shape);    
    end;
        
        
    class procedure ndarray.operator+=(var self_ndarray, other_ndarray: neo.ndarray);
    begin
      self_ndarray := self_ndarray + other_ndarray;
    end;
    
    
    class procedure ndarray.operator+=(var self_ndarray: neo.ndarray; number: neo.&Type);
    begin
      self_ndarray := self_ndarray + number;
    end;
    
    
//    class function ndarray.operator-(self_ndarray: neo.ndarray): neo.ndarray;
//    begin
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := self_ndarray.value[i].neg(); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);        
//    end;
    
    
    class function ndarray.operator-(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
    begin
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := self_ndarray.value[i] - number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);        
    end;
        
            
    class function ndarray.operator-(number: neo.&Type; self_ndarray: neo.ndarray): neo.ndarray;
    begin
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := number - self_ndarray.value[i]; 
      Result := new ndarray(tmp_result, self_ndarray.shape);        
    end;    


    class function ndarray.operator-(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
    begin
      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
        raise new System.ArithmeticException('Wrong array sizes');
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := self_ndarray.value[i] - other_ndarray.value[i]; 
      Result := new ndarray(tmp_result, self_ndarray.shape);    
    end;       

    
    class procedure ndarray.operator-=(var self_ndarray: neo.ndarray; other_ndarray: neo.ndarray);
    begin
      self_ndarray := self_ndarray - other_ndarray;
    end;

    
    class procedure ndarray.operator-=(var self_ndarray: neo.ndarray; number: neo.&Type);
    begin
      self_ndarray := self_ndarray - number;
    end;

        
    class function ndarray.operator*(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
    begin
      Result := neo.multiply(self_ndarray, number)
    end;


    class function ndarray.operator*(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
    begin
      Result := neo.multiply(other_ndarray, number);
    end;
                  
                  
    class function ndarray.operator*(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray;
    begin
      Result := neo.multiply(self_ndarray, other_ndarray);
    end;
            
            
    class procedure ndarray.operator*=(var self_ndarray: neo.ndarray; number: neo.&Type);
    begin
      self_ndarray := neo.multiply(self_ndarray, number);
    end;
          
      
    class procedure ndarray.operator*=(var self_ndarray: neo.ndarray; other_ndarray: neo.ndarray);
    begin
      self_ndarray := neo.multiply(self_ndarray, other_ndarray);
    end;


//    class function ndarray.operator/(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
//    begin
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := self_ndarray.value[i].div(number); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);
//    end;
//
//    
//    class function ndarray.operator/(number: neo.&Type; self_ndarray: neo.ndarray): neo.ndarray;
//    begin
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := number.div(self_ndarray.value[i]); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);
//    end;
//
//
//    class function ndarray.operator/(self_ndarray: neo.ndarray; other_ndarray: neo.ndarray): neo.ndarray;
//    begin
//      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
//        raise new System.ArithmeticException('Wrong array sizes');
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := self_ndarray.value[i].div(other_ndarray.value[i]); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);  
//    end;
//
//
//    class procedure ndarray.operator/=(var self_ndarray: ndarray; number: neo.&Type);
//    begin
//      self_ndarray := self_ndarray / number;
//    end;
//    
//
//    class procedure ndarray.operator/=(var self_ndarray: ndarray; other_ndarray: ndarray);
//    begin
//      self_ndarray := self_ndarray / other_ndarray;      
//    end;
//
//
//    class function ndarray.operator**(self_ndarray: ndarray; number: neo.&Type): ndarray;
//    begin
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := self_ndarray.value[i].pow(number); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);
//    end;
//    
//            
//    class function ndarray.operator**(number: neo.&Type; self_ndarray: ndarray): ndarray;
//    begin
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := number.pow(self_ndarray.value[i]); 
//      Result := new ndarray(tmp_result, self_ndarray.shape); 
//    end;
//    
//    
//    class function ndarray.operator**(self_ndarray: ndarray; other_ndarray: ndarray): ndarray;
//    begin
//      if not areEqual(self_ndarray.shape, other_ndarray.shape) and (self_ndarray.rank <> 1) and (other_ndarray.rank <> 1) then
//        raise new System.ArithmeticException('Wrong array sizes');
//      var tmp_result := new neo.&Type[self_ndarray.length];
//      for var i := 0 to self_ndarray.length-1 do
//        tmp_result[i] := self_ndarray.value[i].pow(other_ndarray.value[i]); 
//      Result := new ndarray(tmp_result, self_ndarray.shape);   
//    end;
//   {$endregion}
//        
//         
////    class function ndarray.operator=(self_ndarray: neo.ndarray; other_ndarray: neo.ndarray): boolean;
////    begin
////      result := True;
////    end;
//        
//    
//    function ndarray.Equals(other_ndarray: neo.ndarray): boolean;
//    begin
//      result := True;      
//      if self.length <> other_ndarray.length then
//        result := False;
//      for var i := 0 to self.length-1 do
//        if self.value[i] <> other_ndarray.value[i] then
//          begin
//          result := False;
//          break;
//          end;
//    end;    
//
//    function ndarray.Equals(obj: object): boolean;
//    begin
//      if obj = nil then
//        result := False;
//
//      var ndarray_obj := obj as neo.ndarray;
//      if ndarray_obj = nil then
//         result := False
//      else
//         result := self.Equals(ndarray_obj);
//    end;    
//
//    function ndarray.sum(axis: integer): ndarray;
//    begin
//      result := neo.sum(self, axis);
//    end;
//
//      
//    function ndarray.get(params index: array of integer): neo.&Type;
//    begin
//      result := self.__get_item(index);
//    end;
//    
//    
//    procedure ndarray.assign(val: neo.&Type; params index: array of integer);
//    begin
//      self.__set_item(val, index);
//    end;
//    
//    
//    function ndarray.get_shape(): array of integer;
//    begin
//      result := new integer[self.rank];
//      self.shape.CopyTo(result, 0);
//    end;
//    
//    
//    function ndarray.map(func: System.Func<neo.&Type, neo.&Type>): neo.ndarray;
//    begin
//      result := neo.map(func, self);
//    end;
//    
//    
//    function ndarray.max(): neo.&Type;
//    begin
////      result := neo.max(self);
//    end;
//
//    
//    function ndarray.copy(): ndarray;
//    begin
//      result := neo.copy(self);
//    end;
//
//
//    function ndarray.reshape(shape: array of integer): ndarray;
//    begin
//      result := neo.reshape(self, shape);
//    end;
//
//
////    procedure ndarray.save(bw: System.IO.BinaryWriter);
////    begin
////      bw.Write(self.rank);
////      foreach var dim in self.shape do
////        bw.Write(dim);
////      foreach var dim in self.iter_array do
////        bw.Write(dim);
////      bw.Write(self.length);
////      foreach var elem in self.value do
////        bw.Write(elem);
////    end;
//   
//
////    static function ndarray.load(br: System.IO.BinaryReader): neo.ndarray;
////    begin
////      result := new neo.ndarray;
////      result.rank := br.ReadInt32();
////      result.shape := new integer[result.rank];
////      for var i := 0 to result.rank-1 do
////        result.shape[i] := br.ReadInt32();
////      result.iter_array := new integer[result.rank];
////      for var i := 0 to result.rank-1 do
////        result.iter_array[i] := br.ReadInt32();
////      result.length := br.ReadInt32();
////      result.value := new neo.&Type[result.length];
////      for var i := 0 to result.length-1 do
////        result.value[i] := br.ReadSingle();
////    end;
//
//   
//    function ndarray.transpose(axes: array of integer): ndarray;
//    begin
//      result := neo.transpose(self, axes);
//    end;  
//   
//   
//    function ndarray.dot(other_ndarray: ndarray; axis: integer): ndarray;
//    begin
//      result := neo.dot(self, other_ndarray, axis);
//    end;
// 
//     
////    function random_ndarray(shape: array of integer): ndarray;
////    begin
////      var tmp_result := new neo.&Type[shape.Product];
////      for var index := 0 to shape.Product-1 do
////        tmp_result[index] := random;
////      Result := new ndarray(tmp_result, shape);   
////    end;
// 
// 
//    function arange(stop: integer): ndarray;
//    begin
//      var tmp_result := new neo.&Type[stop];
//      var tmp_shape: array of integer := (stop);
//      for var i := 0 to stop-1 do
//        tmp_result[i] := i;
//      result := new ndarray(tmp_result, tmp_shape);
//    end;
//    
//    
//    function arange(start, stop: integer): ndarray;
//    begin
//      var tmp_result := new neo.&Type[stop-start];
//      var tmp_shape: array of integer := (stop-start);
//      for var i := start to stop-1 do
//        tmp_result[i-start] := i;
//      result := new ndarray(tmp_result, tmp_shape);  
//    end;
//    
//    
//    function arange(start, stop, step: integer): ndarray;
//    begin
//      var tmp_result := new neo.&Type[(stop-start) div step];
//      var tmp_shape: array of integer := ((stop-start) div step);
//      var i := start-1; var cnt := 0; 
//      if step < 0 then
//        while i > stop do
//          begin
//          tmp_result[cnt] := i;
//          cnt += 1;
//          i += step;
//          end
//      else
//        while i < stop do
//          begin
//          tmp_result[cnt] := i;
//          cnt += 1;
//          i += step;
//          end;
//      result := new ndarray(tmp_result, tmp_shape);  
//    end;
//
//
//    function concatenate(a, b: ndarray; axis: integer): ndarray;
//    begin
//      if axis = -1 then
//      begin
//        var tmp_shape: array of integer := (a.length+b.length-1); 
//        var tmp_ndarray := new neo.&Type[a.length+b.length-1];
//        var item_gen_a := a.__get_item_generator();
//        var item_gen_b := b.__get_item_generator();
//        
//        for var index := 0 to a.length-1 do
//          tmp_ndarray[index] := item_gen_a();
//        for var index := a.length to a.length+b.length-1 do
//          tmp_ndarray[index] := item_gen_b();
//        
//        Result := new ndarray(tmp_ndarray, tmp_shape);
//        end
//      else
//        begin
//        if a.shape[axis] <> b.shape[axis] then
//          raise new Exception('Fields couldn not be broadcast together');
//        
//        var tmp_shape := new integer[a.rank];
//        for var index := 0 to a.rank-1 do
//          begin
//          tmp_shape[index] := a.shape[index];
//          if index = axis then
//            tmp_shape[index] += b.shape[axis];
//          end;
//          
//        var tmp_ndarray := new ndarray(tmp_shape);
//        var item_gen_a := a.__get_item_generator();
//        var item_gen_b := b.__get_item_generator();
//        var index_gen_c := tmp_ndarray.__get_index_generator();
//        
//        for var index := 0 to a.length+b.length-2 do
//          begin
//          var arr := index_gen_c();
//          
//          while arr[axis] > a.shape[axis]-1 do
//            begin
//            tmp_ndarray.assign(item_gen_b(), arr);  
//            arr := index_gen_c();
//            end;
//          
//          tmp_ndarray.assign(item_gen_a(), arr);
//          end;
//        Result := tmp_ndarray;
//        end;
//    end;
//        
//        
//    function copy(self_ndarray: ndarray): ndarray;
//    begin
//      Result := new ndarray(self_ndarray.value, self_ndarray.shape);
//    end;    
//        
//        
//    function dot(self_ndarray: ndarray; other_ndarray: ndarray; axis: integer): ndarray;
//    begin
//      if (self_ndarray.rank = 1) and (other_ndarray.rank = 1) then
//        begin
//        var sum: array of neo.&Type := (0);
//        for var i := 0 to self_ndarray.length-1 do
//          sum[0] += self_ndarray.value[i] * other_ndarray.value[i];
//        result := new ndarray(sum, ArrFill(1, 1));
//        end
//      else if (self_ndarray.rank = 1) or (other_ndarray.rank = 1) then
//      begin
//        if self_ndarray.shape[0] <> other_ndarray.shape[0] then
//          raise new Exception('Fields couldn not be broadcast together');
//        
//        var max_ndarray: ndarray;
//        var min_ndarray: ndarray;
//        if self_ndarray.rank > other_ndarray.rank then
//          begin
//          max_ndarray := self_ndarray;
//          min_ndarray := other_ndarray;
//          end
//        else
//          begin
//          max_ndarray := other_ndarray;
//          min_ndarray := self_ndarray;
//          end;
//        
//        var tmp_shape := new integer[max_ndarray.rank-1];
//        for var i := 1 to max_ndarray.rank-1 do
//          tmp_shape[i-1] := max_ndarray.shape[i]; 
//        
//        var tmp_arr := new neo.&Type[tmp_shape.Product];
//
//        var max_index_gen := max_ndarray.__get_index_generator();
//        var max_item_gen := max_ndarray.__get_item_generator();
//        
//        var cnt_limit := max_ndarray.length div max_ndarray.shape[0]; var cnt := 0;
//        for var i := max_ndarray.length-min_ndarray.length to max_ndarray.length-1 do
//        begin
//          println(i, i mod min_ndarray.length);
//          tmp_arr[cnt] += max_ndarray.value[i] * min_ndarray.value[i mod min_ndarray.length];
//          cnt += 1;
//          if cnt = cnt_limit then
//            cnt := 0;
//        end;
//        result := new ndarray(tmp_arr, tmp_shape);
//        end
//      else if (self_ndarray.rank = 2) and (other_ndarray.rank = 2) then
//        begin
//          var other_ndarray_T := other_ndarray.transpose();
//          var tmp_result := new neo.&Type[self_ndarray.shape[0]*other_ndarray.shape[1]];
//          var new_shape: array of integer := (self_ndarray.shape[0], other_ndarray.shape[1]);
//          for var i:=0 to self_ndarray.shape[0]-1 do
//            for var j:=0 to other_ndarray.shape[1]-1 do
//            begin  
//              var cc := 0.0;
//              for var l:=0 to self_ndarray.shape[1]-1 do
//                 cc += self_ndarray.get(i, l)*other_ndarray_T.get(j, l);
//              tmp_result[i*self_ndarray.shape[0]+j] := cc;   
//            end;
//          result := new ndarray(tmp_result, new_shape);
//        end
//      else
//        begin
//        var tmp_shape := new integer[self_ndarray.rank+other_ndarray.rank-2];
//        for var i := 0 to self_ndarray.rank-2 do
//          tmp_shape[i] := self_ndarray.shape[i];
//        for var i := 0 to other_ndarray.rank-3 do
//          tmp_shape[self_ndarray.rank+i-1] := other_ndarray.shape[i];
//        tmp_shape[self_ndarray.rank+other_ndarray.rank-3] := other_ndarray.shape[other_ndarray.rank-1];
//        
//        var tmp_ndarray := new ndarray(tmp_shape);
//        var index_gen := tmp_ndarray.__get_index_generator();
//        
//        for var i := 0 to tmp_shape.Product-1 do
//          begin
//            var arr := index_gen();
//            var arr_a := new integer[self_ndarray.rank-1];
//            for var j := 0 to self_ndarray.rank-2 do
//              arr_a[j] := arr[j];
//            
//            var a_matrix := new neo.&Type[self_ndarray.shape[self_ndarray.rank-1]];
//            var cnt_a := 0;
//            for var j := 0 to self_ndarray.shape[self_ndarray.rank-1]-1 do
//            begin
//              var tmp_arr := new integer[arr_a.length+1];
//              for var k := 0 to arr_a.Length-1 do
//                tmp_arr[k] := arr_a[k];
//              tmp_arr[arr_a.length] := j;
//              a_matrix[j] := self_ndarray.get(tmp_arr);
//              end;
//              
//            var arr_b := new integer[other_ndarray.rank-1];
//            for var j := 0 to other_ndarray.rank-2 do
//              arr_b[j] := arr[self_ndarray.rank+j-1];
//                        
//            var b_matrix := new neo.&Type[other_ndarray.shape[other_ndarray.rank-2]];
//            var cnt_b := 0;
//            for var j := 0 to other_ndarray.shape[other_ndarray.rank-2]-1 do
//            begin
//              var tmp_arr := new integer[arr_b.length+1];
//              for var k := 0 to arr_b.Length-2 do
//                tmp_arr[k] := arr_b[k];
//              tmp_arr[arr_b.length-1] := j;
//              tmp_arr[arr_b.length] := arr_b[arr_b.Length-1];
//              b_matrix[j] := other_ndarray.get(tmp_arr);
//              end;
//              
//            var acc := 0.0;
//            for var j := 0 to a_matrix.Length-1 do
//              acc += a_matrix[j] * b_matrix[j];
//            tmp_ndarray.assign(acc, arr);
//          end;
//        result := tmp_ndarray; 
//        end;
//    end;    
//        
//        
//    function map(func: System.Func<neo.&Type, neo.&Type>; self_ndarray: neo.ndarray): neo.ndarray;
//    begin
//      var tmp_ndarray := new neo.ndarray(self_ndarray.shape);
//      for var i := 0 to self_ndarray.length-1 do
//        self_ndarray.value[i] := func(self_ndarray.value[i]); 
//      Result := tmp_ndarray;
//    end;
//    
//    
////    // TODO: Нахождение максимальных элементов по осям
////    function max(self: ndarray): neo.&Type;
////    begin
////      var item_gen := self.__get_item_generator();
////      var tmp_result := item_gen();
////      for var i := 0 to self.length-2 do
////        tmp_result := System.Math.Max(item_gen(), tmp_result);  
////      result := tmp_result;
////    end;
        

    function multiply(number_a, number_b: neo.&Type): neo.&Type;
    begin
      Result :=  number_a * number_b;
    end;
        

    function multiply(self_ndarray: neo.ndarray; number: neo.&Type): neo.ndarray;
    begin
      var tmp_result := new neo.&Type[self_ndarray.length];
      for var i := 0 to self_ndarray.length-1 do
        tmp_result[i] := self_ndarray.value[i] * number; 
      Result := new ndarray(tmp_result, self_ndarray.shape);
    end;
    

    function multiply(number: neo.&Type; other_ndarray: neo.ndarray): neo.ndarray;
    begin
      Result := neo.multiply(other_ndarray, number);
    end;


    function multiply(self_ndarray, other_ndarray: neo.ndarray): neo.ndarray; 
    var 
      max_ndarray: neo.ndarray;
      min_ndarray: neo.ndarray;
    begin
      if self_ndarray.length > other_ndarray.length then
        begin
        max_ndarray := self_ndarray;
        min_ndarray := other_ndarray;
        end
      else
        begin
        max_ndarray := other_ndarray;
        min_ndarray := self_ndarray;
        end;
      
      var tmp_result := new neo.&Type[max_ndarray.length];  
      for var i := 0 to max_ndarray.length-1 do
        tmp_result[i] := max_ndarray.value[i] * min_ndarray.value[i mod min_ndarray.length];
      result := new ndarray(tmp_result, max_ndarray.shape);
    end;


//    function reshape(self_ndarray: ndarray; shape: array of integer): ndarray;
//    begin
//      Result := new ndarray(self_ndarray.value, shape);
//    end;
//
//
//    function sum(self_ndarray: ndarray; axis: integer): ndarray;
//    begin
//      if (self_ndarray.rank = 1) or (axis = -1) then
//        begin
//        var tmp_result: array of neo.&Type := (self_ndarray.value.Sum);
//        var tmp_result_shape: array of integer := (1);
//        result := new ndarray(tmp_result, tmp_result_shape);
//        end
//      else
//        begin
//        var sum_array_shape := new integer[self_ndarray.rank-1]; var cnt := 0;
//        for var index := 0 to self_ndarray.rank-1 do
//          if index = axis then
//            continue
//          else  
//            begin
//            sum_array_shape[cnt] := self_ndarray.shape[index];
//            cnt += 1;
//            end;
//
//        var sum_arr := new neo.&Type[sum_array_shape.Product];
//        var sum_iter_array := ndarray.__get_iter_array(sum_array_shape);
//
//        var arr := new integer[self_ndarray.rank];
//        for var i := 0 to self_ndarray.length-1 do
//          begin 
//          for var j := self_ndarray.rank-1 downto 0 do
//            if arr[j] = self_ndarray.shape[j] then
//              begin
//              arr[j-1] += 1;
//              arr[j] := 0;
//              end;
//          
//          var new_arr := new integer[self_ndarray.rank-1]; var sum_cnt := 0;
//          for var j := 0 to self_ndarray.rank-1 do
//            if j = axis then
//              continue
//            else
//             begin
//              new_arr[sum_cnt] := arr[j];
//              sum_cnt += 1;
//              end;
//
//          var sum_acc := 0;
//          for var j := 0 to self_ndarray.rank-2 do
//            sum_acc += sum_iter_array[j] * new_arr[j];
//          sum_arr[sum_acc] += self_ndarray.value[i];
//          arr[self_ndarray.rank-1] += 1;
//          
//          end;
//      result := new ndarray(sum_arr, sum_array_shape);
//      end;
//    end;
//
//
//    function transpose(self_ndarray: ndarray; axes: array of integer): ndarray;
//    begin
//      if axes = nil then
//        begin
//        axes := new integer[self_ndarray.rank];
//        for var index := 0 to self_ndarray.rank-1 do
//          axes[index] := self_ndarray.rank-index-1;
//        end;
//      
//      var tmp_value := new neo.&Type[self_ndarray.length];
//      var tmp_shape := new integer[self_ndarray.rank];
//      for var index := 0 to self_ndarray.rank-1 do
//        tmp_shape[index] := self_ndarray.shape[axes[index]];
//      
//      var tmp_iter_array := ndarray.__get_iter_array(tmp_shape);
//      var index_gen := self_ndarray.__get_index_generator();
//      
//      var arr := new integer[self_ndarray.rank];
//      for var i := 0 to self_ndarray.length-1 do
//        begin
//        for var j := self_ndarray.rank-1 downto 0 do
//          if arr[j] = self_ndarray.shape[j] then
//            begin
//            arr[j-1] += 1;
//            arr[j] := 0;
//            end;
//        
//        var new_arr := new integer[self_ndarray.rank];
//        for var j := 0 to self_ndarray.rank-1 do
//          new_arr[j] := arr[axes[j]];
//        
//        var acc := 0;
//        for var j := 0 to self_ndarray.rank-1 do
//          acc += tmp_iter_array[j] * new_arr[j];
//        tmp_value[acc] := self_ndarray.value[i];
//        
//        arr[self_ndarray.rank-1] += 1;
//        end;
//      result := new ndarray(tmp_value, tmp_shape);
//    end;
    {$endregion}
end.