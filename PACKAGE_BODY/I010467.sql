
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010467" is

  procedure pp_abm_carg(v_ind            in varchar2,
                        v_carg_empr_codi in number,
                        v_carg_codi      in number,
                        v_carg_codi_alte in number,
                        v_carg_desc      in varchar2,
                        v_carg_user_regi in varchar2,
                        v_carg_fech_regi in date) is
  begin

    if v_ind = 'I' then

      insert into rrhh_carg
        (carg_empr_codi,
         carg_codi,
         carg_codi_alte,
         carg_desc,
         carg_user_regi,
         carg_fech_regi)
      values
        (v_carg_empr_codi,
         v_carg_codi,
         v_carg_codi_alte,
         v_carg_desc,
         v_carg_user_regi,
         v_carg_fech_regi);

    elsif v_ind = 'U' then

      update rrhh_carg
         set carg_empr_codi = v_carg_empr_codi,
             carg_codi_alte = v_carg_codi_alte,
             carg_desc      = v_carg_desc,
             carg_user_modi = gen_user,
             carg_fech_modi = sysdate
       where carg_codi = v_carg_codi;

    elsif v_ind = 'D' then

      delete rrhh_carg where carg_codi = v_carg_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_carg;

end I010467;
