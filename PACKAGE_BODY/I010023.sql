
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010023" is

  procedure pp_abm_cotizacion(v_ind            in varchar2,
                              v_coti_empr_codi in number,
                              v_coti_fech      in date,
                              v_coti_tica_codi in number,
                              v_coti_mone      in number,
                              v_coti_tasa      in number,
                              v_coti_tasa_come in number,
                              v_coti_base      in number,
                              v_coti_user_regi in varchar2,
                              v_coti_fech_regi in date,
                              v_rowid          in varchar2) is
  begin

    if v_ind = 'I' then

      insert into come_coti
        (coti_empr_codi,
         coti_fech,
         coti_tica_codi,
         coti_mone,
         coti_tasa,
         coti_tasa_come,
         coti_base,
         coti_user_regi,
         coti_fech_regi)
      values
        (v_coti_empr_codi,
         v_coti_fech,
         v_coti_tica_codi,
         v_coti_mone,
         v_coti_tasa,
         v_coti_tasa_come,
         v_coti_base,
         fa_user,
         sysdate);

    elsif v_ind = 'U' then
      update come_coti
         set coti_empr_codi = v_coti_empr_codi,
             coti_tasa      = v_coti_tasa,
             coti_tica_codi = v_coti_tica_codi,
             coti_tasa_come = v_coti_tasa_come,
             coti_base      = v_coti_base,
             coti_user_modi = fa_user,
             coti_fech_modi = sysdate,
             coti_mone = v_coti_mone
       where rowid = v_rowid;


    elsif v_ind = 'D' then

      delete come_coti where coti_fech = to_date(v_coti_fech,'dd/mm/yyyy') and coti_tica_codi = v_coti_tica_codi and coti_mone = v_coti_mone;

    end if;


  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_cotizacion;

end I010023;
