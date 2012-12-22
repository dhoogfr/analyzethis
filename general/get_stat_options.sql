r_options       statoptions%rowtype

for r_obj in 
    ( select * 
      from table(list_need_stats(p_schema => 'SCHEMA'))
      where 
    )
loop

    if r_obj.subpartname is not null
    then
        select *
        into r_options
        from ( select statoptions
               where ( owner = r_obj.ownname
                       and object_name = r_obj.objname
                       and part_name = r_obj.partname
                       and subpart_name = r_obj.subpartname
                       and object_type = r_obj.objtype
                     )
                     or ( owner = r_obj.ownname
                          and object_name = r_obj.objname
                          and part_name = r_obj.partname
                          and subpart_name = is null
                          and object_type = r_obj.objtype
                     )
                     or ( owner = r_obj.ownname
                          and object_name = r_obj.objname
                          and part_name is null
                          and subpart_name = is null
                          and object_type = r_obj.objtype
                        )
                     or ( owner = r_obj.ownname
                          and object_name is null
                          and part_name is null
                          and subpart_name = is null
                          and object_type = r_obj.objtype
                        )
                     or ( owner is null
                          and object_name is null
                          and part_name is null
                          and subpart_name = is null
                          and object_type = r_obj.objtype
                        )
               order by owner nulls last, object_name nulls last, 
                        part_name nulls last, subpart_name nulls last
             )
        where rownum = 1;
        
        if ( r_options.analyze = 'TRUE'
             and r_obj.objtype = table 
           )
        then
            dbms_stats.gather_table_stats
                ( ownname       =>
                  tabname       =>
                  partname      =>
                  subpartname   =>
                  
        
    elsif r_obj.partname is not null
    then
        select *
        into r_options
        from ( select statoptions
               where ( owner = r_obj.ownname
                       and object_name = r_obj.objname
                       and part_name = r_obj.partname
                       and object_type = r_obj.objtype
                     )
                     or ( owner = r_obj.ownname
                          and object_name = r_obj.objname
                          and part_name is null
                          and object_type = r_obj.objtype
                        )
                     or ( owner = r_obj.ownname
                          and object_name is null
                          and part_name is null
                          and object_type = r_obj.objtype
                        )
                     or ( owner is null
                          and object_name is null
                          and part_name is null
                          and object_type = r_obj.objtype
                        )
               order by owner nulls last, object_name nulls last,
                        part_name nulls last
             )
        where rownum = 1;   
    else
        select *
        into r_options
        from ( select statoptions
               where ( owner = r_obj.ownname
                       and object_name = r_obj.objname
                       and object_type = r_obj.objtype
                     )
                     or ( owner = r_obj.ownname
                          and object_name is null
                          and object_type = r_obj.objtype
                        )
                     or ( owner is null
                          and object_name is null
                          and object_type = r_obj.objtype
                        )
               order by owner nulls last, object_name nulls last
             )
        where rownum = 1;
        
    end if;
    
end loop;
