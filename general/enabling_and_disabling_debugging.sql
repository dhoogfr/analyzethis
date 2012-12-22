@debug.pkb

create directory debug_dir as '/opt/oracle/admin/LOKI/debug';
grant read, write on directory debug_dir to analyzethis;


BEGIN

    analyzethis.debug.init
        ( p_modules     =>  'ALL',
          p_dir         =>  'DEBUG_DIR',
          p_user        =>  'ANALYZETHIS'
         );  
   
    commit;
    
END;
/

-- om debugging te disablen

BEGIN

    debug.clear
        ( p_user        =>  'ANALYZETHIS'
         );  

    commit;
    
END;
/
