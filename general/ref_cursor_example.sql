
create or replace package p_types
as
    TYPE rfc_statsinput is ref cursor return dbms_stats.ObjectElem;
END;
/


DECLARE

    rfc_test p_types.rfc_statsinput;
    l_objectElem  dbms_stats.objectelem;

BEGIN

    open rfc_test for
        select *
        from table(list_needs_stats('FREEK', 'TRUE'))
        where objtype = 'TABLE';

    loop
        fetch rfc_test into l_objectElem;
        exit when rfc_test%NOTFOUND;
        dbms_output.put_line ('Fetched record');
    end loop;
    
    close rfc_test;

END;
/


DECLARE

    l_tab_cursor    AnalyzeThis.rfc_statsinput;
    l_objectElem  dbms_stats.objectelem;

BEGIN
        
        open l_tab_cursor for
            select *
            from table(AnalyzeThis.NeedStatsList('FREEK'))
            where objtype = 'TABLE';
    loop
        fetch l_tab_cursor into l_objectElem;
        exit when l_tab_cursor%NOTFOUND;
        dbms_output.put_line ('Fetched record');
    end loop;
    
    close l_tab_cursor;

END;
/
