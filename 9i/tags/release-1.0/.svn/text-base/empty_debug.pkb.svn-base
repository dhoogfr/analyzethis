CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..debug

IS


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global constants
*/


/* END declaration of global constants
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global variables
*/

  g_owner       varchar2(2000);
  g_name        varchar2(2000);
  g_lineno      number;
  g_caller_t    varchar2(2000);
  g_file        varchar2(2000);

/*      END declaration of global variables
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN type declarations
*/


/*
        END type declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception declaration
*/


/*
        END global exception declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception messages declaration
*/

/*
        END global exception messages declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN forward declarations
*/

    PROCEDURE internal_f
        ( p_message     in  varchar2,
          p_args        in  Argv default emptyDebugArgv
        );
        
    FUNCTION parse_it
        ( p_message in  varchar2,
          p_args    in  argv default emptyDebugArgv
        ) RETURN varchar2;

    PROCEDURE who_called_me
        ( owner     out varchar2,
          name      out varchar2,
          lineno    out number,
          caller_t  out varchar2
        );

    FUNCTION is_number
        ( n varchar2
        ) RETURN boolean;


/*
        END forward declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> init </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>
            
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE init
        ( p_modules     in  varchar2 default 'ALL',
          p_dir         in  varchar2 default g_dir_locat,
          p_file        in  varchar2 default null,
          p_user        in  varchar2 default user
        )

    IS
    
        r debugTab%rowtype;

    BEGIN
    
        clear( p_user );

        insert into debugTab
        values ( p_user, p_modules, p_dir, p_file );
        
    END init;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> clear </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE clear
        ( p_user    varchar2    default user
        )

    IS

    BEGIN
    
        delete from debugTab where userid = p_user;

    END clear;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> Status </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE status
        ( p_user    in  varchar2    default user,
          p_modules out varchar2,
          p_file    out varchar2,
          p_dir     out varchar2
        )

    IS
    
    BEGIN
        select modules, locat, filename
        into p_modules, p_dir, p_file
        from debugTab
        where userid = p_user;
        
    EXCEPTION
        when NO_DATA_FOUND then
            p_modules := null;
            p_dir := null;
            p_file := null;
            
    END status;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> who_called_me </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 31/01/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> Changed the length of the substrings because in 10g 
                       the format of format_call_stack changed
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE who_called_me
        ( owner     out varchar2,
          name      out varchar2,
          lineno    out number,
          caller_t  out varchar2
        )

    IS

        call_stack      varchar2(4096) default dbms_utility.format_call_stack;
        n               number;
        found_stack     BOOLEAN default FALSE;
        line            varchar2(255);
        cnt             number := 0;
        
    BEGIN
    
        loop
            n := instr( call_stack, chr(10) );
            exit when ( cnt = 3 or n is NULL or n = 0 );

            line := substr( call_stack, 1, n-1 );
            call_stack := substr( call_stack, n+1 );
            if not found_stack
            then
                if line like '%handle%number%name%'
                then
                    found_stack := TRUE;
                end if;
            else
                cnt := cnt + 1;
                -- cnt = 1 is ME
                -- cnt = 2 is MY Caller
                -- cnt = 3 is Their Caller
                if ( cnt = 3 )
                then
                    -- changed with 10g (10.1.0.3 ?)
                    --lineno := to_number(substr( line, 13, 6 ));
                    --line   := substr( line, 21 );
                    lineno := to_number(substr( line, 13, 8 ));
                    line   := substr( line, 23 );

                    if ( line like 'pr%' )
                    then
                        n := length( 'procedure ' );
                    elsif ( line like 'fun%' )
                    then
                        n := length( 'function ' );
                    elsif ( line like 'package body%' )
                    then
                        n := length( 'package body ' );
                    elsif ( line like 'pack%' )
                    then
                        n := length( 'package ' );
                    else
                        n := length( 'anonymous block ' );
                    end if;

                    caller_t := ltrim(rtrim(upper(substr( line, 1, n-1 ))));
                    line := substr( line, n );
                    n := instr( line, '.' );
                    owner := ltrim(rtrim(substr( line, 1, n-1 )));
                    name  := ltrim(rtrim(substr( line, n+1 )));
                end if;
            end if;
        end loop;
        
    END who_called_me;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> is_number </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION is_number
        ( n varchar2
        ) RETURN boolean

    IS

    BEGIN
    
        if n between '0' and '9'
        then
            return true;
        end if;
        return false;
        
    END is_number;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> parse_it </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION parse_it
        ( p_message in  varchar2,
          p_args    in  argv default emptyDebugArgv
        ) RETURN varchar2

    IS
    
        l_tmp long := p_message;
        l_str long := null;
        l_idx number;

        l_numstr1 varchar2(10);
        l_numstr2 varchar2(10);

        l_tmp1 long;
        l_str1 long;

        l_num number;
        l_char long;

    BEGIN

        for i in 1 .. p_args.count
        loop
            l_idx := instr( l_tmp, '%' ) ;
            exit when nvl(l_idx,0) = 0;

            l_str := l_str || substr( l_tmp, 1, l_idx-1 );
            l_tmp := substr( l_tmp, l_idx+1 );

            if substr( l_tmp, 1, 1 ) = 's'
               or substr( l_tmp, 1, 1 ) = 'd'
            then
                l_str := l_str || p_args(i);
                l_tmp := substr( l_tmp, 2 );
            elsif is_number( substr( l_tmp, 1, 1 ) )
                  or substr( l_tmp, 1, 1 ) = '.'
            then
                l_numstr1 := null;
                l_numstr2 := null;

                l_tmp1 := l_tmp;
                l_str1 := l_str;

                loop
                    exit when not is_number( substr( l_tmp1, 1, 1 ) );
                    l_numstr1 := l_numstr1 || substr( l_tmp1, 1, 1 );
                    l_tmp1 := substr( l_tmp1, 2 );
                end loop;

                if substr( l_tmp1, 1, 1 ) = '.'
                then
                    l_tmp1 := substr( l_tmp1, 2 );
                    if is_number( substr( l_tmp1, 1, 1 ) )
                    then
                        loop
                            exit when not is_number( substr( l_tmp1, 1, 1 ) );
                            l_numstr2 := l_numstr2 || substr( l_tmp1, 1, 1 );
                            l_tmp1 := substr( l_tmp1, 2 );
                        end loop;
                    else
                        l_tmp1 := '!' || l_tmp1;
                    end if;
                end if;

                begin
                    if substr( l_tmp1, 1, 1 ) = 's'
                    then
                        l_tmp := substr( l_tmp1, 2 );
                        if l_numstr2 is null
                        then
                            l_tmp1 := p_args(i);
                        else
                            l_tmp1 := substr( p_args(i), 1, l_numstr2 );
                        end if;
                        if l_numstr1 is not null
                        then
                            l_tmp1 := lpad( l_tmp1, l_numstr1 );
                        end if;
                            l_str := l_str1 || l_tmp1;
                    elsif substr( l_tmp1, 1, 1 ) = 'd'
                    then
                        l_tmp := substr( l_tmp1, 2 );
                        if l_numstr1 is null
                        then
                            l_tmp1 := lpad( '9', 39, '9' );
                        else
                            l_tmp1 := lpad( '9', l_numstr1, '9' );
                        end if;
                        if l_numstr2 is not null
                        then
                            l_tmp1 := substr( l_tmp1, 1, l_numstr1-l_numstr2 ) || '.' || substr( l_tmp1, -l_numstr2 );
                        end if;
                        l_str := l_str1 || to_char( to_number( p_args(i) ), l_tmp1 );
                    else
                        l_str := l_str || '%';
                    end if;

                EXCEPTION
                    when others then
                        l_str := l_str1 || 'XXXXXXXXXX';
                END;

            else
                l_str := l_str || '%';
            end if;

        end loop;

    return l_str || l_tmp;

    EXCEPTION
        when others then
            return l_str || l_tmp;
    END parse_it;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> internal_f </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 31/01/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> Changed the output format to allow more space for the package/procedure name 
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE internal_f
        ( p_message     in  varchar2,
          p_args        in  Argv default emptyDebugArgv
        )
        
    IS

        l_locat     varchar2(4000);
        l_modules   varchar2(4000);
        l_filename  varchar2(4000);
        l_message   long := null;
        l_file      utl_file.file_type;
        l_date      varchar2(255);

    BEGIN

        select modules, locat, filename, to_char( sysdate, 'YYMMDD HH24MISS' )
        into l_modules, l_locat, l_filename, l_date
        from debugTab
        where userid = user;

        if instr( l_modules, nvl(g_name,'BLAH') ) = 0 and l_modules <> 'ALL' then
            return;
        end if;

        if l_filename is not null then
            g_file := l_filename;
        end if;

        l_message := parse_it( p_message, p_args );
    /*
        l_message := p_message;

        BEGIN
        
            for i in 1 .. p_args.count
            loop
                if instr( l_message, '%s' ) = 0
                then
                    exit;
                else
                    l_message := substr( l_message, 1, instr( l_message, '%s' )-1 ) ||
                                 p_args(i) ||
                                 substr( l_message, instr( l_message, '%s' )+2 );
                end if;
            end loop;
            
        EXCEPTION
            when others then
                null;
        END;
    */

        l_message := replace( l_message, '\n', chr(10) );
        l_message := replace( l_message, '\t', chr(9) );

        l_file := utl_file.fopen( l_locat, g_file, 'a', 32767 );
        if not utl_file.is_open( l_file ) then
            dbms_output.put_line( 'File not opened' );
        end if;
        if g_owner is null then
            g_owner := user;
            g_name := 'ANONYMOUS BLOCK';
        end if;
        utl_file.put( l_file, '' );
        utl_file.put_line( l_file,
                           l_date ||
                               ' (' || rpad( g_owner || '.' || g_name, 35 ) || ',' ||
                               lpad(g_lineno,5) || ') ' || l_message
                         );
        utl_file.fclose( l_file );

    EXCEPTION
        when NO_DATA_FOUND then
            -- dbms_output.put_line( sqlerrm );
            null;
    END internal_f;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> fa </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE fa
        ( p_message     in  varchar2,
          p_args        in  Argv default emptyDebugArgv
        )
    IS
    
    BEGIN
/*    
        who_called_me( g_owner, g_name, g_lineno, g_caller_t );
        internal_f( p_message, p_args );
*/

    NULL;
    END fa;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> f </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Christopher Beck </AUTHOR>
        <SUMMARY>

        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE f
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
        )

    IS

    BEGIN

/*    
        who_called_me( g_owner, g_name, g_lineno, g_caller_t );
        internal_f( p_message,
                    argv( substr( p_arg1, 1, 4000 ),
                          substr( p_arg2, 1, 4000 ),
                          substr( p_arg3, 1, 4000 ),
                          substr( p_arg4, 1, 4000 ),
                          substr( p_arg5, 1, 4000 ),
                          substr( p_arg6, 1, 4000 ),
                          substr( p_arg7, 1, 4000 ),
                          substr( p_arg8, 1, 4000 ),
                          substr( p_arg9, 1, 4000 ),
                          substr( p_arg10, 1, 4000 )
                        )
                  );
*/

    NULL;
    
    END f;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN initialization code
*/

BEGIN

  g_file := 'DEBUGF_'||userenv('SESSIONID');


/* END initialization code
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END debug;
/
