
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."GETMACNAME" is

procedure c_getName(nombre out varchar2) as language java name 'LocalHost.getName()';
  function c_getName(nombre out varchar2) return varchar2 is
    l_name varchar2(100);
  begin
    c_getName(l_name);
       return l_name;
  end;
end;
