
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010201" is

  procedure pp_abm_idio(v_ind            in varchar2,
                        v_idio_codi      in number,
                        v_idio_desc      in varchar2,
                        v_idio_base      in number,
                        v_idio_empr_codi in number,
                        v_idio_codi_alte in number,
                        v_idio_user_regi in varchar2,
                        v_idio_fech_regi in date) is
  x_idio_codi number;
  x_idio_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(idio_codi), 0) + 1, nvl(max(idio_codi_alte), 0) + 1
        into x_idio_codi, x_idio_codi_alte
        from come_idio;
      insert into come_idio
        (idio_codi,
         idio_desc,
         idio_base,
         idio_empr_codi,
         idio_codi_alte,
         idio_user_regi,
         idio_fech_regi)
      values
        (x_idio_codi,
         v_idio_desc,
         v_idio_base,
         v_idio_empr_codi,
         x_idio_codi_alte,
         gen_user,
         sysdate);

    elsif v_ind = 'U' then

      update come_idio
         set idio_desc      = v_idio_desc,
             idio_base      = v_idio_base,
             idio_empr_codi = v_idio_empr_codi,
             idio_codi_alte = v_idio_codi_alte,
             idio_user_modi = gen_user,
             idio_fech_modi = sysdate
       where idio_codi = v_idio_codi;

    elsif v_ind = 'D' then

      delete come_idio where idio_codi = v_idio_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_idio;

end I010201;
