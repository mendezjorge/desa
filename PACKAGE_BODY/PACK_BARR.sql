
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."PACK_BARR" is

  procedure pp_abm_barr(v_ind            in varchar2,
                        v_barr_codi      in number,
                        v_barr_desc      in varchar2,
                        v_barr_ciud_codi in number,
                        v_barr_empr_codi in number,
                        v_barr_codi_alte in number,
                        v_barr_user_regi in varchar2,
                        v_barr_fech_regi in date,
                        v_barr_base      in number) is
    x_barr_codi      number;
    x_barr_codi_alte number;

  begin

    if v_ind = 'I' then

      select nvl(max(barr_codi), 0) + 1
        into x_barr_codi
        from come_barr;

      select nvl(max(to_number(barr_codi_alte)), 0) + 1
        into x_barr_codi_alte
        from come_barr
        where barr_empr_codi = fa_empresa;

      insert into come_barr
        (barr_codi,
         barr_desc,
         barr_ciud_codi,
         barr_empr_codi,
         barr_codi_alte,
         barr_user_regi,
         barr_fech_regi)
      values
        (x_barr_codi,
         v_barr_desc,
         v_barr_ciud_codi,
         v_barr_empr_codi,
         x_barr_codi_alte,
         fa_user,
         sysdate);

    elsif v_ind = 'U' then

      update come_barr
         set barr_desc      = v_barr_desc,
             barr_base      = v_barr_base,
             barr_ciud_codi = v_barr_ciud_codi,
             barr_empr_codi = v_barr_empr_codi,
             barr_codi_alte = v_barr_codi_alte,
             barr_user_modi = fa_user,
             barr_fech_modi = sysdate
       where barr_codi = v_barr_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_barr;

  ---------------------------------------------------------------------------------------
  procedure pp_elim_regi(v_barr_codi in number) is
  begin

    pack_barr.pp_vali_elim_regi(v_barr_codi);
    delete come_barr where barr_codi = v_barr_codi;

  end pp_elim_regi;

  ---------------------------------------------------------------------------------------
  procedure pp_vali_elim_regi(v_barr_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from cope_soci
     where soci_barr_codi = v_barr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque existen' || '  ' ||
                              v_count || ' ' ||
                              ' socios relacionados a este registro');
    end if;

  --Validando objeto
  end pp_vali_elim_regi;

---------------------------------------------------------------------------------------

end pack_barr;
