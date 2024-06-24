
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010440" is

  procedure pp_abm_perf (v_ind           in varchar2,
                         v_perf_codi      in number,
                         v_perf_desc      in varchar2,
                         v_perf_empr_codi in number,
                         v_perf_codi_alte in number,
                         v_perf_user_regi in varchar2,
                         v_perf_fech_regi in date,
                         v_perf_max_desc  in number) is
   begin

   if v_ind = 'I' then

     insert into come_perf_auto_desc_inte
          (perf_codi,
           perf_desc,
           perf_empr_codi,
           perf_codi_alte,
           perf_user_regi,
           perf_fech_regi,
           perf_max_desc)
        values
          (v_perf_codi,
           v_perf_desc,
           v_perf_empr_codi,
           v_perf_codi_alte,
           v_perf_user_regi,
           v_perf_fech_regi,
           v_perf_max_desc);

  elsif  v_ind  = 'U' then

          update come_perf_auto_desc_inte
        set perf_desc      = v_perf_desc,
            perf_max_desc      = v_perf_max_desc,
            perf_empr_codi = v_perf_empr_codi,
            perf_codi_alte = v_perf_codi_alte,
            perf_user_modi = gen_user,
            perf_fech_modi = sysdate
        where perf_codi = v_perf_codi;

  elsif v_ind = 'D' then

        delete come_perf_auto_desc_inte
          where perf_codi = v_perf_codi;

  end if;


 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);

   end pp_abm_perf;

end i010440;
