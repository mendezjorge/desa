
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010424" is

  procedure pp_traer_consulta(p_user in number) is
  
  begin
    I010082.pp_carga_bloque_habi(p_user_codi => p_user);
  
    I010200.pp_carga_bloque_habi(p_user_codi => p_user);
  
    I010043.pp_carga_bloque_habi(p_user_codi => p_user);
  
    I010042.pp_carga_bloque_habi(p_user_codi => p_user);
  
    I010016.pp_carga_bloque_habi(p_user_codi => p_user);
  
    I010033.pp_carga_bloque_habi(p_user_codi => p_user,
                                 p_modu_codi => NULL);
  
  end;

  procedure pp_actualizar(p_user in number, p_copiar in varchar2) is
  
  begin
    --raise_application_error(-20001,'Hola');
    I010082.pp_actu_regi(p_user => p_user, p_copiar => p_copiar);
    I010200.pp_actu_regi(p_user => p_user, p_copiar => p_copiar);
    I010043.pp_actu_regi(p_user => p_user, p_copiar => p_copiar);
    I010042.pp_actu_regi(p_user => p_user, p_copiar => p_copiar);
    I010016.pp_actualiza_registro(p_user => p_user, p_copiar => p_copiar);
    I010033.pp_actualizar_registro(p_user => p_user, p_copiar => p_copiar);
  end;

  procedure pp_copiar_permisos(p_user_1 in number, p_user_2 in number) is
  
  begin
  
    I010082.pp_carga_bloque_habi(p_user_codi => p_user_2);
  
    I010200.pp_carga_bloque_habi(p_user_codi => p_user_2);
  
    I010043.pp_carga_bloque_habi(p_user_codi => p_user_2);
  
    I010042.pp_carga_bloque_habi(p_user_codi => p_user_2);
  
    I010016.pp_carga_bloque_habi(p_user_codi => p_user_2);
  
    I010033.pp_carga_bloque_habi(p_user_codi => p_user_2,
                                 p_modu_codi => NULL);
  end;

end I010424;
