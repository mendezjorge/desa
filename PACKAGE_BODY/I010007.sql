
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010007" is

procedure pp_abm_depositos (v_ind                 in varchar2,
                             v_depo_empr_codi      in number,
                             v_depo_codi           in number,
                             v_depo_codi_alte      in number,
                             v_depo_desc           in varchar2,
                             v_depo_desc_abre      in varchar2,
                             v_depo_sucu_codi      in number,
                             v_depo_maxi_dias_rece in number,
                             v_depo_ciud_codi      in number,
                             v_depo_indi_movi      in varchar2,
                             v_depo_indi_visi      in varchar2,
                             v_depo_indi_fact      in varchar2,
                             v_depo_indi_incl_list in varchar2,
                             v_depo_indi_exte      in varchar2,
                             v_depo_base           in number,
                             v_depo_user_regi      in varchar2,
                             v_depo_fech_regi      in date) is
   x_depo_codi number;
   x_depo_codi_alte number;   
   begin
   if v_ind = 'I' then
     select  nvl(max(depo_codi),0)+1, nvl(max(to_number(depo_codi_alte)),0)+1
	   into x_depo_codi, x_depo_codi_alte
	   from come_depo;
     insert into come_depo
          (depo_empr_codi,
           depo_codi,
           depo_codi_alte,
           depo_desc,
           depo_desc_abre,
           depo_sucu_codi,
           depo_maxi_dias_rece,
           depo_ciud_codi,
           depo_indi_movi,
           depo_indi_visi,
           depo_indi_fact,
           depo_indi_incl_list,
           depo_indi_exte,
           depo_base,
           depo_user_regi,
           depo_fech_regi)
        values
          (v_depo_empr_codi,
           x_depo_codi,
           x_depo_codi_alte,
           v_depo_desc,
           v_depo_desc_abre,
           v_depo_sucu_codi,
           v_depo_maxi_dias_rece,
           v_depo_ciud_codi,
           v_depo_indi_movi,
           v_depo_indi_visi,
           v_depo_indi_fact,
           v_depo_indi_incl_list,
           v_depo_indi_exte,
           v_depo_base,
           gen_user,
           sysdate);

  elsif  v_ind  = 'U' then

          update come_depo
        set depo_empr_codi           = v_depo_empr_codi,
            depo_codi_alte           = v_depo_codi_alte,
            depo_desc                = v_depo_desc,
            depo_desc_abre           = v_depo_desc_abre,
            depo_sucu_codi           = v_depo_sucu_codi,
            depo_maxi_dias_rece      = v_depo_maxi_dias_rece,
            depo_ciud_codi           = v_depo_ciud_codi,
            depo_indi_movi           = v_depo_indi_movi,
            depo_indi_visi           = v_depo_indi_visi,
            depo_indi_fact           = v_depo_indi_fact,
            depo_indi_incl_list      = v_depo_indi_incl_list,
            depo_indi_exte           = v_depo_indi_exte,
            depo_base                = v_depo_base,
            depo_user_modi           = gen_user,
            depo_fech_modi           = sysdate
        where depo_codi              = v_depo_codi;

  elsif v_ind = 'D' then
        I010007.pp_validar_borrado(v_depo_codi);

        delete come_depo
          where depo_codi = v_depo_codi;

  end if;


 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);
     end pp_abm_depositos;

-------------------------------------------------------------------------------------------

    procedure pp_validar_borrado(v_depo_codi in number) is
      v_count number(6);
    begin
      select count(*)
        into v_count
        from come_movi
       where movi_depo_codi_orig = v_depo_codi
          or movi_depo_codi_dest = v_depo_codi;

      if v_count > 0 then
       raise_application_error(-20010,'Existen' || '  ' || v_count || ' ' ||
                         'movimientos que tienen asignados este Deposito. Primero debes borrarlos o asignarlos a otra');
      end if;

    end pp_validar_borrado;


end I010007;
