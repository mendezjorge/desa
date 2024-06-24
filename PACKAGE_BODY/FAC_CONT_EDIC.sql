
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."FAC_CONT_EDIC" is

  procedure pp_abm_edic_cont_serv_moni(v_ind            in varchar2,
                                       v_coed_nume_item in number,
                                       v_coed_desc      in varchar2,
                                       v_coed_tipo      in varchar2,
                                       v_coed_base      in number,
                                       v_COED_empr_codi in number) is
  x_coed_nume_item number;
  begin
    if v_ind = 'I' then
      --raise_application_error(-20010,'hola');
      select nvl(max(coed_nume_item), 0) + 1
        into x_coed_nume_item
        from come_cont_edic;
      insert into come_cont_edic
        (coed_nume_item,
         coed_desc,
         coed_tipo,
         coed_base,
         coed_user_regi,
         coed_fech_regi,
         COED_empr_codi)
      values
        (x_coed_nume_item,
         v_coed_desc,
         v_coed_tipo,
         v_coed_base,
         fa_user,
         sysdate,
         v_COED_empr_codi);
    
    elsif v_ind = 'U' then
    
      update come_cont_edic
         set coed_desc      = v_coed_desc,
             coed_tipo      = v_coed_tipo,
             coed_base      = v_coed_base,
             coed_user_modi = fa_user,
             coed_fech_modi = sysdate
       where coed_nume_item = v_coed_nume_item
       and COED_empr_codi= v_COED_empr_codi;
    
    elsif v_ind = 'D' then
    
      delete come_cont_edic where coed_nume_item = v_coed_nume_item
      and COED_empr_codi= v_COED_empr_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    /*when others then
      raise_application_error(-20010, sqlerrm);*/
    
  end pp_abm_edic_cont_serv_moni;
end fac_cont_edic;
