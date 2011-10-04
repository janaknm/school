Script started on Fri Sep 23 10:46:53 2011
bash-3.2$ gcc -Wall -o msh msh.c
bash-3.2$ ./msh
% ls
msh	msh.c	msh.ts
% ls  -al
total 40
drwxr-xr-x  5 mattforbes  staff   170 Sep 23 10:47 .
drwxr-xr-x  4 mattforbes  staff   136 Sep 21 19:01 ..
-rwxr-xr-x  1 mattforbes  staff  9376 Sep 23 10:47 msh
-rw-r--r--  1 mattforbes  staff  2514 Sep 23 10:40 msh.c
-rw-r--r--  1 mattforbes  staff    43 Sep 23 10:47 msh.ts
%       ls   -al
total 40
drwxr-xr-x  5 mattforbes  staff   170 Sep 23 10:47 .
drwxr-xr-x  4 mattforbes  staff   136 Sep 21 19:01 ..
-rwxr-xr-x  1 mattforbes  staff  9376 Sep 23 10:47 msh
-rw-r--r--  1 mattforbes  staff  2514 Sep 23 10:40 msh.c
-rw-r--r--  1 mattforbes  staff    43 Sep 23 10:47 msh.ts
%    touch    README
% ls
README	msh	msh.c	msh.ts
% rm  rm         README   
% ls -al    
msh	msh.c	msh.ts
%    
% ^C
bash-3.2$ exit

Script done on Fri Sep 23 10:47:59 2011
