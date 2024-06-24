
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010360" is

  procedure pp_abm_marc_vehi (v_ind           in varchar2,
                             v_mave_codi      in number,
                             v_mave_desc      in varchar2,
                             v_mave_empr_codi in number,
                             v_mave_codi_alte in number,
                             v_mave_user_regi in varchar2,
                             v_mave_fech_regi in date,
                             v_mave_base      in number) is
   begin

   if v_ind = 'I' then

     insert into come_marc_vehi
          (mave_codi,
           mave_desc,
           mave_empr_codi,
           mave_codi_alte,
           mave_user_regi,
           mave_fech_regi)
        values
          (v_mave_codi,
           v_mave_desc,
           v_mave_empr_codi,
           v_mave_codi_alte,
           v_mave_user_regi,
           v_mave_fech_regi);

  elsif  v_ind  = 'U' then

          update come_marc_vehi
        set mave_desc      = v_mave_desc,
            mave_base      = v_mave_base,
            mave_empr_codi = v_mave_empr_codi,
            mave_codi_alte = v_mave_codi_alte,
            mave_user_modi = gen_user,
            mave_fech_modi = sysdate
        where mave_codi = v_mave_codi;

  elsif v_ind = 'D' then

        delete come_marc_vehi
          where mave_codi = v_mave_codi;

  end if;


 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);

   end pp_abm_marc_vehi;


end i010360;
