
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010361" is

  procedure pp_abm_tipo_vehi (v_ind           in varchar2,
                             v_tive_codi      in number,
                             v_tive_desc      in varchar2,
                             v_tive_empr_codi in number,
                             v_tive_codi_alte in number,
                             v_tive_user_regi in varchar2,
                             v_tive_fech_regi in date,
                             v_tive_base      in number) is
   x_tive_codi number;
   x_tive_codi_alte number;
   begin

   if v_ind = 'I' then
     select nvl(max(tive_codi),0)+1, NVL(MAX(to_number(tive_codi_alte)),0)+1
     into x_tive_codi, x_tive_codi_alte
     from come_tipo_vehi;
     insert into come_tipo_vehi
          (tive_codi,
           tive_desc,
           tive_empr_codi,
           tive_codi_alte,
           tive_user_regi,
           tive_fech_regi)
        values
          (x_tive_codi,
           v_tive_desc,
           v_tive_empr_codi,
           x_tive_codi_alte,
           gen_user,
           sysdate);

  elsif  v_ind  = 'U' then

          update come_tipo_vehi
        set tive_desc      = v_tive_desc,
            tive_base      = v_tive_base,
            tive_empr_codi = v_tive_empr_codi,
            tive_codi_alte = v_tive_codi_alte,
            tive_user_modi = gen_user,
            tive_fech_modi = sysdate
        where tive_codi = v_tive_codi;

  elsif v_ind = 'D' then

        delete come_tipo_vehi
          where tive_codi = v_tive_codi;

  end if;


 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);

   end pp_abm_tipo_vehi;


end I010361;
