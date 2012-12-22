CREATE OR REPLACE PACKAGE &AnalyzeThisUser..debug

IS

--
--  version 1.0
--    clbeck - 13-OCT-98 - Initial version
--
--  PACKAGE TO DUMP DEBUG INFORMATION OF PL/SQL ROUTINE
--  TO A FILE DURING EXECUTION
--
--
--  This package allows the developer to selectively produce debug
--    iformation for pl/sql process.
--
--  Setup:
--    Make sure the utl_file_dir paramter is assigned in the init.ora
--    file.  You need an entry for each dir that you want to be able to
--    write to.
--    eg.
--      utl_file_dir = /tmp
--      utl_file_dir = /home/clbeck/sql/debug
--
--  Usage:
--    There are two procedure to write debug information ( f and fa ).
--    Anywhere in your code that you want to print debug information use:
--
--      debug.f( 'Expected %s bytes, got %s bytes', l_expect, l_got  );
--
--    This will replace the the first %s with the value of l_expect and the
--    second %s with the value of l_got.
--
--    If you have more than 10 %s in your string then you will need to use the fa
--    procedure like:
--
--      debug.fa( 'List: %s,%s,%s,%s,%s,%s',
--                  argv( 1, 2, l_num, 'Chris', l_cnt, 10 ) );
--
--  Runtime:
--    To enable the debug run:
--
--      debug.init( 'myProc' );
--
--    This will cause only debug for the procedure/package named
--    myProc to be generated.
--    All other debug statements will generate no output.
--    To debug all procedures/packages,
--    set p_modules = 'ALL';
--
--    To stop debug run:
--
--      debug.clear;
--
--  Output:
--    The output looks like:
--
--      981013 130530 (CLBECK.MYPROC, 221)  this is my debug output
--      ^^^^^^ ^^^^^^  ^^^^^^^^^^^^^  ^^^   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--      date   time    owner.proc  lineno   message
--
--
-- Enhancements and Bugs:
--
--  Send all enhancements requests and bugs to me,
--  Christopher Beck (clbeck@us.oracle.com)
--
--



/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global exception numbers
*/


/* END declaration of global exception_numbers
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global exception messages
*/


/*      END declaration of global exception messages
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global types
*/


/*      END declaration of global types
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global variables
*/

    g_dir_locat   constant varchar2(4000) := 'MIJN_TEST';
    emptyDebugArgv         Argv;


/*      END declaration of global variables
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of public functions and procedures
*/


  --
  --  Initializes the debuging for specified p_modules and will dump the
  --  output to the p_dir directory on the server for the user p_user.
  --
  PROCEDURE init
    ( p_modules     in  varchar2 default 'ALL',
      p_dir         in  varchar2 default g_dir_locat,
      p_file        in  varchar2 default null,
      p_user        in  varchar2 default user
    );

  procedure f
    ( p_message     in  varchar2,
      p_arg1        in  varchar2 default null,
      p_arg2        in  varchar2 default null,
      p_arg3        in  varchar2 default null,
      p_arg4        in  varchar2 default null,
      p_arg5        in  varchar2 default null,
      p_arg6        in  varchar2 default null,
      p_arg7        in  varchar2 default null,
      p_arg8        in  varchar2 default null,
      p_arg9        in  varchar2 default null,
      p_arg10       in  varchar2 default null
    );

  procedure fa
    ( p_message     in  varchar2,
      p_args        in  Argv default emptyDebugArgv
    );

  procedure clear
    ( p_user        in  varchar2 default user
    );

  --
  -- Returns the current status of debugging for the user p_user.
  --
  procedure status
    ( p_user        in      varchar2 default user,
      p_modules     out     varchar2,
      p_file        out     varchar2,
      p_dir         out     varchar2 );

/*      END declaration of public functions and procedures
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END debug;
/

