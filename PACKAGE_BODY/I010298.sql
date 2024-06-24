
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010298" is

  procedure pp_vali_desc(chsi_desc in varchar2) is

  begin

    if chsi_desc is null then
      raise_application_error(-20010,'Debe ingresar la descripcion de la Situacion');
    end if;

  end pp_vali_desc;

-----------------------------------------------
  procedure pp_muestra_come_cuen_cont (p_codi in number) is

  v_indi_impu varchar2 (1);

  begin

  if p_codi is not null then

    select cuco_indi_impu
    into   v_indi_impu
    from   come_cuen_cont
    where  cuco_codi = p_codi;

    if nvl(v_indi_impu , 'N') <> 'S' then
      raise_application_error(-20010,'Debe ingresar solamente las cuentas contables que se encuentren en estado imputables !!!');
    end if;

  else
    null;
  end if;



  Exception
    when no_data_found then
        raise_application_error(-20010,'Cuenta Contable inexistente!: '||p_codi );
    when others then
       raise_application_error(-20010, sqlerrm);
  end pp_muestra_come_cuen_cont;

-----------------------------------------------
  procedure pp_vali_situ(chsi_situ in varchar2) is

  begin

    if chsi_situ is null then
       raise_application_error(-20010,'Debe ingresar la descripcion de la Situacion');
    end if;

  end pp_vali_situ;

-----------------------------------------------
  procedure pp_vali_suma_rest(chsi_indi_suma_rest in varchar2) is

  begin

    if chsi_indi_suma_rest is null then
       raise_application_error(-20010,'Debe ingresar el inidicador de saldo!');
    end if;

  end pp_vali_suma_rest;

-----------------------------------------------
  procedure pp_validar(chsi_desc in varchar2,
                       p_codi    in number,
                       chsi_situ in varchar2,
                       chsi_indi_suma_rest in varchar2) is

  begin

    pp_vali_desc(chsi_desc);
    pp_muestra_come_cuen_cont (p_codi);
    pp_vali_situ(chsi_situ);
    pp_vali_suma_rest(chsi_indi_suma_rest);

  end pp_validar;

-----------------------------------------------
  procedure pp_abm_situ_cheq(v_ind                 in varchar2,
                             v_chsi_codi           in number,
                             v_chsi_desc           in varchar2,
                             v_chsi_cuco_codi      in number,
                             v_chsi_situ           in varchar2,
                             v_chsi_indi_suma_rest in varchar2,
                             v_chsi_base           in number,
                             v_chsi_user_regi      in varchar2,
                             v_chsi_fech_regi      in date) is
  begin

    if v_ind = 'I' then

      pp_validar(v_chsi_desc, v_chsi_cuco_codi, v_chsi_situ, v_chsi_indi_suma_rest);


      insert into come_cheq_situ
        (chsi_codi,
         chsi_desc,
         chsi_cuco_codi,
         chsi_situ,
         chsi_indi_suma_rest,
         chsi_base,
         chsi_user_regi,
         chsi_fech_regi)
      values
        (v_chsi_codi,
         v_chsi_desc,
         v_chsi_cuco_codi,
         v_chsi_situ,
         v_chsi_indi_suma_rest,
         v_chsi_base,
         gen_user,
         sysdate);

    elsif v_ind = 'U' then

      pp_validar(v_chsi_desc, v_chsi_cuco_codi, v_chsi_situ, v_chsi_indi_suma_rest);

      update come_cheq_situ
         set chsi_desc           = v_chsi_desc,
             chsi_cuco_codi      = v_chsi_cuco_codi,
             chsi_situ           = v_chsi_situ,
             chsi_indi_suma_rest = v_chsi_indi_suma_rest,
             chsi_base           = v_chsi_base,
             chsi_user_modi      = gen_user,
             chsi_fech_modi      = sysdate
       where chsi_codi = v_chsi_codi;

    elsif v_ind = 'D' then

      delete come_cheq_situ where chsi_codi = v_chsi_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_situ_cheq;

end I010298;
