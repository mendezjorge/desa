
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010035" is

procedure pp_abm_ciud         (v_ind            in varchar2,
                               v_ciud_codi      in number,
                               v_ciud_desc      in varchar2,
                               v_ciud_pais_codi in number,
                               v_ciud_depa_codi in number,
                               v_ciud_empr_codi in number,
                               v_ciud_codi_alte in number,
                               v_ciud_user_regi in varchar2,
                               v_ciud_fech_regi in date,
                               v_ciud_base      in number,
                               v_ciud_zona_codi in number,
                               v_cuid_cod_sifen in number) is
   x_ciud_codi number;
   x_ciud_codi_alte number;

   begin

   if v_ind = 'I' then
   select nvl(max(to_number(ciud_codi_alte)),0)+1 ciud_codi_alte, nvl(max(ciud_codi),0)+1 ciud_codi
	 into x_ciud_codi_alte, x_ciud_codi
	 from come_ciud;
     insert into come_ciud
          (ciud_codi,
           ciud_desc,
           ciud_pais_codi,
           ciud_depa_codi,
           ciud_empr_codi,
           ciud_codi_alte,
           ciud_user_regi,
           ciud_fech_regi,
           ciud_base,
           ciud_zona_codi,
           cuid_cod_sifen)
        values
          (x_ciud_codi,
           v_ciud_desc,
           v_ciud_pais_codi,
           v_ciud_depa_codi,
           v_ciud_empr_codi,
           x_ciud_codi_alte,
           gen_user,
           sysdate,
           v_ciud_base,
           v_ciud_zona_codi,
           v_cuid_cod_sifen);

  elsif  v_ind  = 'U' then

        update come_ciud
        set ciud_desc      = v_ciud_desc,
            ciud_base      = v_ciud_base,
            ciud_pais_codi = v_ciud_pais_codi,
            ciud_depa_codi = v_ciud_depa_codi,
            ciud_empr_codi = v_ciud_empr_codi,
            ciud_codi_alte = v_ciud_codi_alte,
            ciud_user_modi = gen_user,
            ciud_fech_modi = sysdate,
            ciud_zona_codi = v_ciud_zona_codi,
            cuid_cod_sifen = v_cuid_cod_sifen
        where ciud_codi = v_ciud_codi;

  end if;

 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);

   end pp_abm_ciud;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_ciud_codi in number) is

  begin

    i010035.pp_validar_borrado(v_ciud_codi);
    delete come_ciud
          where ciud_codi = v_ciud_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_ciud_codi in number) is
    v_clpr number(6);
    v_camp number(6);
  begin
    select count(*)
  into v_clpr
  from come_clie_prov
  where clpr_ciud_codi =  v_ciud_codi;

  if v_clpr > 0 then
  	 raise_application_error(-20010,'Existen'||'  '||v_clpr||' '|| 'Clientes que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
  end if;

  select count(*)
  into v_camp
  from come_camp
  where camp_ciud_codi =  v_ciud_codi;

  if v_camp > 0 then
  	 raise_application_error(-20010,'Existen'||'  '||v_camp||' '|| 'Clientes que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
  end if;

  end pp_validar_borrado;

end i010035;
