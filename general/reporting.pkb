BEGIN

    execute immediate 'select * from t where part = :a' using '$';

END;
/
