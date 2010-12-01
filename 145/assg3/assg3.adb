with Ada.Text_IO;	    use Ada.Text_IO;
with Ada.Float_Text_IO;	    use Ada.Float_Text_IO;
with assg3_helper;	    use assg3_helper;
with sorting;
with timing;

procedure assg3 is
    
    procedure timesort is new timing.timesort(Integer, IntArray, int_sort);
    procedure timesort is new timing.timesort(Float, FloatArray, float_sort);
    procedure timesort is new timing.timesort(Obscure, ObscureArray, obscure_sort);

    
    procedure printArray is new printArr(Integer, IntArray, print);
    procedure printArray is new printArr(Float, FloatArray, print);
    procedure printArray is new printArr(Obscure, ObscureArray, print);
    

    ints : IntArray(1..1000000);
    floats : FloatArray(1..100000);
    obscures : ObscureArray(1..100000);

    ms : Float;
    cmd, filename : String(1..256);
    cmdLen, fileLen, size : Natural := 0;
    infile, outfile : File_Type;
begin
    put_line("Enter mode 'input' to specify a file to sort (must be integers)");
    put_line("or 'random' to see a display of all the sorts");
    loop
	put("Which mode? (input, random) ");
	get_line(cmd, cmdLen);
	if( cmd(1..cmdLen) = "random") then
	   put("Enter output filename: ");
	   get_line(filename, fileLen);
	   open_or_create(outfile, Out_File, filename(1..fileLen));
	   put_line(outfile, "Diagnostics for random arrays of length 1000000 of Integers, Floats, and Obscure records");
	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 1000000 random ints with counting sort");
	   put_line(outfile, "*************************************");
	   makeRandom(ints);
	   printArray(outfile, ints);
	   timesort(int_counting_sort'Access, ints, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, ints);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: counting sort on 1000000 ints took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: counting sort on 1000000 ints took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);

	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 1000000 random ints with bucket sort");
	   put_line(outfile, "*************************************");
	   makeRandom(ints);
	   printArray(outfile, ints);
	   timesort(int_bucket_sort'Access, ints, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, ints);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: bucket sort on 1000000 ints took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: bucket sort on 1000000 ints took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);

	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 1000000 random ints with radix_counting sort");
	   put_line(outfile, "*************************************");
	   makeRandom(ints);
	   printArray(outfile, ints);
	   timesort(int_radix_counting_sort'Access, ints, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, ints);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_counting sort on 1000000 ints took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: radix_counting sort on 1000000 ints took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);

	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 100000 random ints with radix_bucket sort");
	   put_line(outfile, "*************************************");
	   makeRandom(ints);
	   printArray(outfile, ints);
	   timesort(int_radix_bucket_sort'Access, ints, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, ints);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_bucket sort on 100000 ints took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: radix_bucket sort on 100000 ints took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);
	   
	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 100000 random floats with radix_counting sort");
	   put_line(outfile, "*************************************");
	   makeRandom(floats);
	   printArray(outfile, floats);
	   timesort(float_radix_counting_sort'Access, floats, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, floats);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_counting sort on 100000 floats took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);


	   put("DIAGNOSTICS: radix_counting sort on 100000 floats took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);


	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 100000 random floats with radix_bucket sort");
	   put_line(outfile, "*************************************");
	   makeRandom(floats);
	   printArray(outfile, floats);
	   timesort(float_radix_bucket_sort'Access, floats, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, floats);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_bucket sort on 100000 floats took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: radix_bucket sort on 100000 floats took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);
	  
	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 100000 random obscure records with radix_counting sort");
	   put_line(outfile, "*************************************");
	   makeRandom(obscures);
	   printArray(outfile, obscures);
	   timesort(obscure_radix_counting_sort'Access, obscures, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, obscures);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_counting sort on 100000 obscure records took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: radix_counting sort on 100000 obscure records took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);

	   put_line(outfile, "*************************************");
	   put_line(outfile, "Sorting 100000 random obscure records with radix_bucket sort");
	   put_line(outfile, "*************************************");
	   makeRandom(obscures);
	   printArray(outfile, obscures);
	   timesort(obscure_radix_bucket_sort'Access, obscures, ms);
	   new_line(outfile);
	   put_line(outfile,"SORTED:");
	   new_line(outfile);
	   printArray(outfile, obscures);
	   new_line(outfile, 2);
	   put(outfile, "DIAGNOSTICS: radix_bucket sort on 100000 obscure records took ");
	   print(outfile, ms);
	   put(outfile, " ms");
	   new_line(outfile, 2);

	   put("DIAGNOSTICS: radix_bucket sort on 100000 obscure records took ");
	   put(ms, 0, 3, 0);
	   put("s");
	   new_line(2);

	    exit;

	elsif( cmd(1..cmdLen) = "input") then
	   put("Enter input filename: ");
	   get_line(filename, fileLen);
	   open_or_create(infile, In_File, filename);

	   put("Enter output filename: ");
	   get_line(filename, fileLen);
	   open_or_create(outfile, Out_File, filename);
	
	    put_line("Getting size...");
	   get_size_of_ints(infile, size);
	   put_line("Got size.");
	   declare
		original, data : IntArray(1..size);
	    begin
		put_line("Getting ints from file...");
		get_ints_from_file(infile, original);
		put_line("Got ints.");
		put_line(outfile, "*************************************");
		put_line(outfile, "Sorting " & Integer'Image(size) & " Integers with counting sort");
		put_line(outfile, "*************************************");
		new_line(outfile);
		data := original;
		put_line("data copied");
		printArray(outfile, data);
		put_line("data put");
		timesort(int_counting_sort'Access, data, ms);
		new_line(outfile);
		put_line(outfile, "SORTED: ");
		new_line(outfile);
		printArray(outfile, data);
		new_line(2);
		put(outfile, "DIAGNOSTICS: Counting sort on " & Integer'Image(size) & " Integers took ");
		put(outfile, ms, 0, 3, 0);
		put(outfile, "s");
		new_line(outfile, 2);

		put("Counting sort on" & Integer'Image(size) & " Integers done. Took ");
		put(ms, 0, 3, 0);
		put("s");
		new_line(2);

		put_line(outfile, "*************************************");
		put_line(outfile, "Sorting " & Integer'Image(size) & " Integers with bucket sort");
		put_line(outfile, "*************************************");
		new_line(outfile);
		data := original;
		printArray(outfile, data);
		timesort(int_bucket_sort'Access, data, ms);
		new_line(outfile);
		put_line(outfile, "SORTED: ");
		new_line(outfile);
		printArray(outfile, data);
		new_line(2);
		put(outfile, "DIAGNOSTICS: Bucket sort on " & Integer'Image(size) & " Integers took ");
		put(outfile, ms, 0, 3, 0);
		put(outfile, "s");
		new_line(outfile, 2);

		put("Bucket sort on" & Integer'Image(size) & " Integers done. Took ");
		put(ms, 0, 3, 0);
		put("s");
		new_line(2);

		put_line(outfile, "*************************************");
		put_line(outfile, "Sorting " & Integer'Image(size) & " Integers with Radix_Counting sort");
		put_line(outfile, "*************************************");
		new_line(outfile);
		data := original;
		printArray(outfile, data);
		timesort(int_radix_counting_sort'Access, data, ms);
		new_line(outfile);
		put_line(outfile, "SORTED: ");
		new_line(outfile);
		printArray(outfile, data);
		new_line(2);
		put(outfile, "DIAGNOSTICS: Radix_Counting sort on " & Integer'Image(size) & " Integers took ");
		put(outfile, ms, 0, 3, 0);
		put(outfile, "s");
		new_line(outfile, 2);

		put("Radix_Counting sort on" & Integer'Image(size) & " Integers took ");
		put(ms, 0, 3, 0);
		put("s");
		new_line(2);

		put_line(outfile, "*************************************");
		put_line(outfile, "Sorting " & Integer'Image(size) & " Integers with Radix_Bucket sort");
		put_line(outfile, "*************************************");
		new_line(outfile);
		data := original;
		printArray(outfile, data);
		timesort(int_radix_bucket_sort'Access, data, ms);
		new_line(outfile);
		put_line(outfile, "SORTED: ");
		new_line(outfile);
		printArray(outfile, data);
		new_line(2);
		put(outfile, "DIAGNOSTICS: Radix_Bucket sort on" & Integer'Image(size) & " Integers took ");
		put(outfile, ms, 0, 3, 0);
		put(outfile, "s");
		new_line(outfile, 2);

		put("Radix_Bucket sort on " & Integer'Image(size) & " Integers took ");
		put(ms, 0, 3, 0);
		put("s");
		new_line(2);
	    end;
		put_line("Operations completed");
	    exit;
	else
	    null;
	end if;
    end loop;
end assg3;
