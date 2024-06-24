
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010347_A" is

  procedure pp_abm_tipo_docu_requ(v_ind            in varchar2,
                                   v_requ_empr_codi in number,
                                   v_requ_codi      in number,
                                   v_requ_codi_alte in number,
                                   v_requ_desc      in varchar2,
                                   v_requ_tive_codi in number,
                                   v_requ_base      in number,
                                   v_requ_user_regi in varchar2,
                                   v_requ_fech_regi in date) is
  begin

    if v_ind = 'I' then

      insert into come_docu_requ_tipo
        (requ_empr_codi,
         requ_codi,
         requ_codi_alte,
         requ_desc,
         requ_tive_codi,
         requ_base,
         requ_user_regi,
         requ_fech_regi)
      values
        (v_requ_empr_codi,
         v_requ_codi,
         v_requ_codi_alte,
         v_requ_desc,
         v_requ_tive_codi,
         v_requ_base,
         v_requ_user_regi,
         v_requ_fech_regi);

    elsif v_ind = 'U' then

      update come_docu_requ_tipo
         set requ_empr_codi = v_requ_empr_codi,
             requ_codi_alte = v_requ_codi_alte,
             requ_desc      = v_requ_desc,
             requ_tive_codi = v_requ_tive_codi,
             requ_base      = v_requ_base,
             requ_user_modi = gen_user,
             requ_fech_modi = sysdate
       where requ_codi = v_requ_codi;

    elsif v_ind = 'D' then

      delete come_docu_requ_tipo where requ_codi = v_requ_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_tipo_docu_requ;

end i010347_a;
