
  CREATE OR REPLACE EDITIONABLE FUNCTION "SKN"."FP_USER" return varchar2 is
  v_return varchar2(2000);
begin
  --+ nuevo PRUEBA
  v_return := nvl(v('APP_USER'), user);
  return v_return;
exception
  when others then
    return user;
end fp_user;
