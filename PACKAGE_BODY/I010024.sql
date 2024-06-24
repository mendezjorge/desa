
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010024" is

  p_codi_base number := pack_repl.fa_devu_codi_base;

  p_indi_exis_empl      varchar2(1) := 'S';
  p_indi_most_mens_sali varchar2(100) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));
  p_codi_tipo_empl_vend number := to_number(fa_busc_para('p_codi_tipo_empl_vend'));
  p_codi_tipo_empl_cobr number := to_number(fa_busc_para('p_codi_tipo_empl_cobr'));
  p_codi_tipo_empl_recl number := to_number(fa_busc_para('p_codi_tipo_empl_recl'));

  p_empresa number := v('AI_EMPR_CODI');
  p_sess    varchar2(500) := v('APP_SESSION');

  procedure pp_actualizar_registro(i_empl_codi           in number,
                                   i_empl_maxi_porc_deto come_empl.empl_maxi_porc_deto%type,
                                   v_empl_cont_supe      come_empl.empl_cont_supe%type,
                                   v_empl_cost_hora      come_empl.empl_cost_hora%type,
                                   v_empl_emse_codi      come_empl.empl_emse_codi%type,
                                   v_empl_esta           come_empl.empl_esta%type,
                                   v_empl_fech_venc_habi come_empl.empl_fech_venc_habi%type,
                                   v_empl_hora_reco_chof come_empl.empl_hora_reco_chof%type,
                                   v_empl_inic_presu     come_empl.empl_inic_presu%type,
                                   v_empl_kilo_reco_chof come_empl.empl_kilo_reco_chof%type,
                                   v_empl_list_codi      come_empl.empl_list_codi%type,
                                   v_empl_maxi_plaz_cobr come_empl.empl_maxi_plaz_cobr%type,
                                   v_empl_nume_habi      come_empl.empl_nume_habi%type,
                                   v_empl_obse_chof      come_empl.empl_obse_chof%type,
                                   v_empl_regi           come_empl.empl_regi%type,
                                   v_empl_secu_presu     come_empl.empl_secu_presu%type,
                                   v_empl_sucu_codi      come_empl.empl_sucu_codi%type,
                                   v_empl_desc           come_empl.empl_desc%type,
                                   v_indi                in varchar2,
                                   v_empl_codi           in number) is
  
    cursor c_Det is
      select taax_c001 codigo
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_c003 = 'S';
  
  begin
    null;
  
    if i_empl_maxi_porc_deto is not null then
      if i_empl_maxi_porc_deto > 99 and i_empl_maxi_porc_deto < 0 then
        raise_application_error(-20010,
                                'Porcentaje de descuento invalido.');
      end if;
   
   end if;
  
 -- raise_application_error(-20010, v_indi);
  
  if v_indi = 'U' then     
    -- guardamos detalle de empleados
    delete from come_empl_tiem where emti_empl_codi = i_empl_codi;
  
    for i in c_Det loop
    
      insert into come_empl_tiem
        (emti_tiem_codi, emti_empl_codi, emti_base)
      values
        (to_number(I.CODIGO), i_empl_codi, p_codi_base);
    
    end loop;
  
  
      -- modificamos datos extras de empleados
      update come_empl
         set empl_desc           = v_empl_desc,
             empl_cont_supe      = v_empl_cont_supe,
             empl_cost_hora      = v_empl_cost_hora,
             empl_emse_codi      = v_empl_emse_codi,
             empl_esta           = v_empl_esta,
             empl_fech_venc_habi = v_empl_fech_venc_habi,
             empl_hora_reco_chof = v_empl_hora_reco_chof,
             empl_inic_presu     = v_empl_inic_presu,
             empl_kilo_reco_chof = v_empl_kilo_reco_chof,
             empl_list_codi      = v_empl_list_codi,
             empl_maxi_plaz_cobr = v_empl_maxi_plaz_cobr,
             empl_maxi_porc_deto = i_empl_maxi_porc_deto,
             empl_nume_habi      = v_empl_nume_habi,
             empl_obse_chof      = v_empl_obse_chof,
             empl_regi           = v_empl_regi,
             empl_secu_presu     = v_empl_secu_presu,
             empl_sucu_codi      = v_empl_sucu_codi,
             empl_user_modi      = gen_user,
             empl_fech_modi      = sysdate
       where empl_codi = i_empl_codi;
    
    elsif v_indi = 'N' then
    
      insert into come_empl
        (empl_codi,
         empl_desc,
         empl_cont_supe,
         empl_cost_hora,
         empl_emse_codi,
         empl_esta,
         empl_fech_venc_habi,
         empl_hora_reco_chof,
         empl_inic_presu,
         empl_kilo_reco_chof,
         empl_list_codi,
         empl_maxi_plaz_cobr,
         empl_maxi_porc_deto,
         empl_nume_habi,
         empl_obse_chof,
         empl_regi,
         empl_secu_presu,
         empl_sucu_codi,
         empl_user_regi,
         empl_fech_regi)
      values
        (v_empl_codi,
         v_empl_desc,
         v_empl_cont_supe,
         v_empl_cost_hora,
         v_empl_emse_codi,
         v_empl_esta,
         v_empl_fech_venc_habi,
         v_empl_hora_reco_chof,
         v_empl_inic_presu,
         v_empl_kilo_reco_chof,
         v_empl_list_codi,
         v_empl_maxi_plaz_cobr,
         i_empl_maxi_porc_deto,
         v_empl_nume_habi,
         v_empl_obse_chof,
         v_empl_regi,
         v_empl_secu_presu,
         v_empl_sucu_codi,
         gen_user,
         sysdate);
    
    
    for i in c_Det loop
    
      insert into come_empl_tiem
        (emti_tiem_codi, emti_empl_codi, emti_base)
      values
        (to_number(I.CODIGO), v_empl_codi, p_codi_base);
    
    end loop;
    
    
    end if;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  function pp_genera_codigo_alte return number is
    o_empl_codi_alte number;
  begin
    select NVL(max(to_number(empl_codi_alte)), 0) + 1
      into o_empl_codi_alte
      from come_empl
     where empl_empr_codi = p_empresa;
  
    return o_empl_codi_alte;
  exception
    when others then
      null;
  end;

  procedure pp_migr_dato(v_tipo           in varchar2,
                         v_empl_codi      in number,
                         v_migr_empl_codi in number,
                         v_cobr_empl_codi in number,
                         v_recl_empl_codi in number) is
  
  begin
  
  --VENDEDOR
  if v_tipo = 'V' then 
      
    update come_clie_prov c
       set c.clpr_empl_codi = v_empl_codi
     where c.clpr_empl_codi = v_migr_empl_codi
       and c.clpr_indi_clie_prov = 'C';
  
    update come_movi m
       set m.movi_empl_codi = v_empl_codi
     where m.movi_empl_codi = v_migr_empl_codi
       and m.movi_timo_codi in (2, 4, 45)
       and m.movi_sald_mone > 0;
 
 --COBRADOR
  elsif v_tipo = 'C' then
      
  		update come_clie_prov c
		   set c.clpr_empl_codi_cobr = v_empl_codi
		 where c.clpr_empl_codi_cobr = v_cobr_empl_codi
		   and c.clpr_indi_clie_prov = 'C';
  
  --RECLAMADOR
  elsif v_tipo = 'R' then 
    
     
    	update come_clie_prov c
		   set c.clpr_empl_codi_recl = v_empl_codi
		 where c.clpr_empl_codi_recl = v_recl_empl_codi
		   and c.clpr_indi_clie_prov = 'C';
       
  end if;
  
  exception
    when others then
      raise_application_error(-20010, 'Error al momento de migrar');
  end;


end I010024;
