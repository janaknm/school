code MyProgram

-----------------------------  main  ---------------------------------

  function main ()
    --
    -- This is a generic User-Level program.  Feel free to modify it and
    -- use it during debugging.
    --
    var ppid, cpid, ign: int 

      print ("Testing system calls Sys_GetPID and Sys_GetPPID\n\n")
      print ("  The main thread will create a child thread and we verify\n")
      print ("  that the correct PIDs are returned from the two sys calls\n\n")

      ppid = Sys_GetPID ()
      
      print ("MAIN PID: ")
      printInt (ppid)
      nl ()
      
      cpid = Sys_Fork ()
      if cpid == 0
        -- we are the child
	print ("  CHILD PID: ")
	printInt (Sys_GetPID ())
	print ("\n  PARENT PID: ")
	printInt (Sys_GetPPID ())
	print ("\n\nCorrect? ")
	printBool (ppid == Sys_GetPPID ())
	nl()
	Sys_Exit (0)
      else
        -- we are the parent
	ign = Sys_Join (cpid)
      endIf
      
      Sys_Shutdown ()

    endFunction

endCode
