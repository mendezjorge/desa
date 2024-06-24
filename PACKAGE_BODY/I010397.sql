
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010397" is

  procedure pp_abm_asignar_reclamador(v_ind                  in varchar2,
                                      v_situ_clre_empr_codi  in number,
                                      v_situ_clre_situ_codi  in number,
                                      v_situ_clre_codi_recl  in number,
                                      v_situ_clre_clas1_codi in number,
                                      v_situ_clre_tipo_fact  in varchar2,
                                      v_situ_clre_base       in number,
                                      v_situ_clre_user_regi  in varchar2,
                                      v_situ_clre_fech_regi  in date,
                                      v_rowid                in varchar2) is
  begin

    if v_ind = 'I' then

      insert into come_situ_clas_recl
        (situ_clre_empr_codi,
         situ_clre_situ_codi,
         situ_clre_codi_recl,
         situ_clre_clas1_codi,
         situ_clre_tipo_fact,
         situ_clre_base,
         situ_clre_user_regi,
         situ_clre_fech_regi)
      values
        (v_situ_clre_empr_codi,
         v_situ_clre_situ_codi,
         v_situ_clre_codi_recl,
         v_situ_clre_clas1_codi,
         v_situ_clre_tipo_fact,
         v_situ_clre_base,
         v_situ_clre_user_regi,
         v_situ_clre_fech_regi);

    elsif v_ind = 'U' then
      update come_situ_clas_recl
         set situ_clre_empr_codi  = v_situ_clre_empr_codi,
             situ_clre_tipo_fact  = v_situ_clre_tipo_fact,
             situ_clre_codi_recl  = v_situ_clre_codi_recl,
             situ_clre_base       = v_situ_clre_base,
             situ_clre_user_modi  = gen_user,
             situ_clre_fech_modi  = sysdate,
             situ_clre_situ_codi  = v_situ_clre_situ_codi,
             situ_clre_clas1_codi = v_situ_clre_clas1_codi
       where rowid = v_rowid;

    elsif v_ind = 'D' then

      delete come_situ_clas_recl
       where situ_clre_situ_codi = v_situ_clre_situ_codi
         and situ_clre_codi_recl = v_situ_clre_codi_recl
         and situ_clre_clas1_codi = v_situ_clre_clas1_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_asignar_reclamador;

end I010397;
