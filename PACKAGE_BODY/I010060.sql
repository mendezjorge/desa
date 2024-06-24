
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010060" is

  procedure pp_actualiza_parametro(i_hab_desh            in varchar2,
                                   i_hab_desh_orig       in varchar2,
                                   i_maxi_fech_habi      in date,
                                   i_maxi_Fech_habi_orig in date) is
  
    v_mensaje varchar2(100) := '¿Realmente desea actualizar el parametro?';
  
    v_aumo_user                    varchar2(40);
    v_aumo_fech                    date;
    v_aumo_maxi_fech_habi_ante     date;
    v_aumo_maxi_fech_habi_nuev     date;
    v_aumo_indi_habi_peri_cerr_ant varchar2(1);
    v_aumo_indi_habi_peri_cerr_nue varchar2(1);
  
  begin
  
    --i_s_mensaje := 'Actualizando situaciones, Favor aguarde un momento!!';    
    --
    if i_hab_desh = 'S' then
      update come_para
         set para_valo = 'S'
       where para_nomb = 'p_indi_habl_peri_cerr';
    else
      update come_para
         set para_valo = 'N'
       where para_nomb = 'p_indi_habl_peri_cerr';
    
    end if;
  
    update come_para
       set para_valo = i_maxi_fech_habi
     where upper(ltrim(rtrim(para_nomb))) = upper('p_fech_maxi_habi');
  
    if i_maxi_Fech_habi <> i_maxi_Fech_habi_orig or
       i_hab_desh <> i_hab_desh_orig then
      v_aumo_user                    := gen_user;
      v_aumo_fech                    := sysdate;
      v_aumo_maxi_fech_habi_ante     := i_maxi_fech_habi_orig;
      v_aumo_maxi_fech_habi_nuev     := i_maxi_fech_habi;
      v_aumo_indi_habi_peri_cerr_ant := i_hab_desh_orig;
      v_aumo_indi_habi_peri_cerr_nue := i_hab_desh;
    
      insert into audi_modi_habi_peri
        (aumo_user,
         aumo_fech,
         aumo_maxi_fech_habi_ante,
         aumo_maxi_fech_habi_nuev,
         aumo_indi_habi_peri_cerr_ante,
         aumo_indi_habi_peri_cerr_nuev)
      values
        (v_aumo_user,
         v_aumo_fech,
         v_aumo_maxi_fech_habi_ante,
         v_aumo_maxi_fech_habi_nuev,
         v_aumo_indi_habi_peri_cerr_ant,
         v_aumo_indi_habi_peri_cerr_nue);
    
    end if;
  
    commit;
  
  end;

  procedure pp_iniciar(o_hab_desh            out varchar2,
                       o_hab_desh_orig       out varchar2,
                       o_maxi_fech_habi      out date,
                       o_maxi_fech_habi_orig out date) is
  
    o_s_maxi_fech_habi varchar2(500);
  
  begin
    --o_s_mensaje := 'Marque la casilla para habilitar periodos cerrados';
  
    begin
      select para_valo
        into o_hab_desh
        from come_para
       where rtrim(ltrim(para_nomb)) = 'p_indi_habl_peri_cerr';
    
      o_hab_desh_orig := o_hab_desh;
    
    exception
      when no_data_found then
        raise_application_error(-20010,
                                'Parametro no encontrado..' ||
                                'p_indi_habl_peri_cerr');
      when too_many_rows then
        raise_application_error(-20010, 'Parametro duplicado');
      when others then
        raise_application_error(-20010, 'Exception When others..');
    end;
  
    begin
      select para_valo
        into o_s_maxi_fech_habi
        from come_para
       where rtrim(ltrim(para_nomb)) = 'p_fech_maxi_habi';
      o_maxi_fech_habi      := to_date(o_s_maxi_fech_habi, 'dd-mm-yyyy');
      o_maxi_fech_habi_orig := o_maxi_fech_habi;
    exception
      when no_data_found then
        raise_application_error(-20010,
                                'Parametro no encontrado..' ||
                                'p_fech_maxi_habi');
      when too_many_rows then
        raise_application_error(-20010, 'Parametro duplicado');
      when others then
        raise_application_error(-20010, 'Exception When others..');
    end;
  
  end;
  

 procedure pp_actualizar_registro(p_user_codi           segu_user.user_codi%type,
                                  p_user_fech_maxi_habi segu_user.user_fech_maxi_habi%type) is
begin
  update segu_user
     set user_fech_maxi_habi = p_user_fech_maxi_habi
   where user_codi = p_user_codi;
 

  
  exception
  when no_data_found then
    rollback;
    raise_application_error(-20010, 'No se encontró el usuario con el código ' || p_user_codi);
  when others then
    rollback;
    raise_application_error(-20010, 'Se produjo un error al actualizar el usuario con el código ' || p_user_codi || ': ' || sqlcode || ' - ' || sqlerrm);

end pp_actualizar_registro;
  
  

end I010060;
