uses neo;
uses patest;


type 
  p = procedure();

  TestArithmeticOperators = class(patest.TestCase)
    public
      procedure test_add_0;
      begin      
        var ndarray_0_shape: array of integer := (1, 1, 1, 1, 1, 1, 1, 1, 1, 32);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (1, 1, 1, 1, 1, 1, 1, 1, 1, 32);
        var ndarray_1 := neo.arange(32).reshape(ndarray_1_shape);
        
        var res := ndarray_0 + ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_add_0.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close();
        
        self.assertEqual(res, true_res);
      end;
      
      procedure test_add_1;
      begin      
        var ndarray_0_shape: array of integer := (32);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (32);
        var ndarray_1 := neo.arange(32).reshape(ndarray_1_shape);
        
        var res := ndarray_0 + ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_add_1.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close;
        
        self.assertEqual(res, true_res);
      end;

      procedure test_add_2;
      begin      
        var ndarray_0_shape: array of integer := (32, 32);
        var ndarray_0 := neo.arange(1024).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (32, 32);
        var ndarray_1 := neo.arange(1024).reshape(ndarray_1_shape);
        
        var res := ndarray_0 + ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_add_2.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close;

        self.assertEqual(res, true_res);
      end;
                
      procedure _test_add_3_helper;
      begin
        var ndarray_0_shape: array of integer := (8, 4);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (8);
        var ndarray_1 := neo.arange(8).reshape(ndarray_1_shape);
        var r := ndarray_0 + ndarray_1;
      end;
                
      procedure test_add_3;
      begin
        self.assertRaises&<System.ArithmeticException>(_test_add_3_helper);
      end;

      procedure test_sub_0;
      begin      
        var ndarray_0_shape: array of integer := (1, 1, 1, 1, 1, 1, 1, 1, 1, 32);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (1, 1, 1, 1, 1, 1, 1, 1, 1, 32);
        var ndarray_1 := neo.arange(32).reshape(ndarray_1_shape);
        
        var res := ndarray_0 - ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_sub_0.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close;
        
        self.assertEqual(res, true_res);
      end;
      
      procedure test_sub_1;
      begin      
        var ndarray_0_shape: array of integer := (32);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (32);
        var ndarray_1 := neo.arange(32).reshape(ndarray_1_shape);
        
        var res := ndarray_0 - ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_sub_1.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close;
        
        self.assertEqual(res, true_res);
      end;

      procedure test_sub_2;
      begin      
        var ndarray_0_shape: array of integer := (32, 32);
        var ndarray_0 := neo.arange(1024).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (32, 32);
        var ndarray_1 := neo.arange(1024).reshape(ndarray_1_shape);
        
        var res := ndarray_0 - ndarray_1;
        var f := System.IO.File.Open('./neo.Test/test_sub_2.neo', System.IO.FileMode.Open);
        var true_res := neo.ndarray.load(new System.IO.BinaryReader(f));
        f.Close;
        
        self.assertEqual(res, true_res);
      end;
                
      procedure _test_sub_3_helper;
      begin
        var ndarray_0_shape: array of integer := (8, 4);
        var ndarray_0 := neo.arange(32).reshape(ndarray_0_shape);
        var ndarray_1_shape: array of integer := (8);
        var ndarray_1 := neo.arange(8).reshape(ndarray_1_shape);
        var r := ndarray_0 - ndarray_1;
      end;
                
      procedure test_sub_3;
      begin
        self.assertRaises&<System.ArithmeticException>(_test_sub_3_helper);
      end;
end;
  

begin
  patest.main();
end.