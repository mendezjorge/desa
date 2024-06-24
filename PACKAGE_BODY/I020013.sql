
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020013" is

  p_peco_codi           number := 1;
  p_form_impr_tran_valo varchar2(500) := rtrim(ltrim(fa_busc_para('p_form_impr_tran_valo')));
  --
  p_codi_clie_espo number := to_number(fa_busc_para('p_codi_clie_espo'));
  p_codi_prov_espo number := to_number(fa_busc_para('p_codi_prov_espo'));
  p_codi_timo_fcor number := to_number(fa_busc_para('p_codi_timo_fcor'));
  p_secu_tran_valo number := to_number(fa_busc_para('p_secu_tran_valo'));
  --  
  p_emit_reci           varchar2(1) := 'E';
  p_indi_impr_cheq_emit varchar2(100) := ltrim(rtrim(fa_busc_para('p_indi_impr_cheq_emit')));
  --tipos de movi. extraccion y deposito bancario....  
  p_codi_timo_depo_banc number := to_number(fa_busc_para('p_codi_timo_depo_banc'));
  p_codi_timo_extr_banc number := to_number(fa_busc_para('p_codi_timo_extr_banc'));
  --conceptos de Deposito y Extraccion bancaria...  
  p_codi_conc_depo_mone number := to_number(fa_busc_para('p_codi_conc_depo_mone'));
  p_codi_conc_extr_mone number := to_number(fa_busc_para('p_codi_conc_extr_mone'));
  --  
  p_codi_impu_exen number := to_number(fa_busc_para('p_codi_impu_exen'));
  p_codi_mone_mmnn number := to_number(fa_busc_para('p_codi_mone_mmnn'));
  p_cant_deci_mmnn number := to_number(fa_busc_para('p_cant_deci_mmnn'));
  --
  p_codi_mone_mmee number := to_number(fa_busc_para('p_codi_mone_mmee'));
  p_cant_deci_mmee number := to_number(fa_busc_para('p_cant_deci_mmee'));
  --  
  p_codi_sucu_defa      number := to_number(fa_busc_para('p_codi_sucu_defa'));
  p_indi_vali_repe_cheq varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_vali_repe_cheq')));
  --
  p_codi_timo_fcoe      number := to_number(fa_busc_para('p_codi_timo_fcoe'));
  p_codi_timo_fcre      number := to_number(fa_busc_para('p_codi_timo_fcre'));
  p_codi_timo_reem      number := to_number(fa_busc_para('p_codi_timo_reem'));
  p_most_rela_fact_tran varchar2(500) := rtrim(ltrim(fa_busc_para('p_most_rela_fact_tran')));
  --
  p_fech_inic date;
  p_fech_fini date;
  p_codi_base number := pack_repl.fa_devu_codi_base;

  v_nume_s         number;
  p_tran_secu      number;
  p_movi_codi_depo number;
  p_codi_padr      number;
  v_movi_codi      number;

  /******************* ACTUALIZAR REGISTROS ***********************/
  procedure pp_Actualizar_registro(ii_movi_clpr_codi      in number,
                                   ii_fech_emis           in date,
                                   ii_s_nume              in number,
                                   ii_movi_tipo_tran      in varchar2,
                                   ii_s_sald_fini         in number,
                                   ii_orig_impo_mone      in number,
                                   ii_dest_impo_mone      in number,
                                   ii_dest_cuen_codi      in number,
                                   ii_orig_cuen_codi      in number,
                                   ii_orig_impo_mmnn      in number,
                                   ii_dest_impo_mmnn      in number,
                                   ii_orig_mone_codi      in number,
                                   ii_dest_mone_codi      in number,
                                   ii_obse                in varchar2,
                                   ii_movi_form_pago      in varchar2,
                                   ii_apci_codi           in number,
                                   ii_orig_mone_cant_deci in number,
                                   ii_dest_mone_cant_deci in number,
                                   ii_orig_tasa_mone      in number,
                                   ii_dest_tasa_mone      in number,
                                   ii_movi_nume_timb      in varchar,
                                   ii_fech_venc_timb      in date) is
  
    v_record number;
    v_MOVI_NUME_TIMB varchar2(60);
    v_S_FECH_VENC_TIMB varchar2(60);
  begin
  
   if ii_movi_tipo_tran  is null then 
      raise_application_Error(-20001, 'El tipo de mov. no puede quedar vacio');
   end if;
  
  if ii_fech_emis is null then
      raise_application_Error(-20001, 'La fecha de emision no puede quedar vacia');
    end if;
  
  
  -----------validaciones
  
  if ii_movi_tipo_tran  = 'I' then--Transferencia Interna
   if  ii_s_nume is null then
     
     raise_application_Error(-20001,'Numero de documento no puede quedar vacio');
   end if;
  
  
  end if;
  
  if ii_movi_tipo_tran  = 'C' then--Cambio de Divisa con Facturas
    
     if  ii_s_nume is null then
        raise_application_Error(-20001,'Numero de documento no puede quedar vacio');
     end if;
  
     if ii_movi_clpr_codi is null then 
        raise_application_Error(-20001,'Debe elegir un proveedor');   
     end if;
     
     



      begin
        -- Call the procedure
        I020013.pp_validar_nro(i_movi_fech_emis      => V('P45_S_FECH_EMIS'),
                               i_tico_fech_rein      => V('P45_TICO_FECH_REIN'),
                               i_clpr_indi_clie_prov => 'P',--'C',
                               i_tico_codi           => V('P45_TICO_CODI'),
                               i_movi_clpr_codi      => V('P45_CLPR_CODI'),
                               i_movi_nume           => V('P45_MOVI_NUME'));
      end;


          begin
            
            I020013.pp_validar_timbrado(p_tico_codi           => V('P45_TICO_CODI'),
                                        p_esta                => V('P45_S_NRO_1'),
                                        p_punt_expe           => V('P45_S_NRO_2'),
                                        p_clpr_codi           => V('P45_CLPR_CODI'),
                                        p_fech_movi           => V('P45_S_FECH_EMIS'),
                                        p_timb                => v_MOVI_NUME_TIMB,
                                        p_fech_venc           => v_S_FECH_VENC_TIMB,
                                        p_tico_indi_timb      => V('P45_TICO_INDI_TIMB'),
                                        i_s_clpr_codi_alte    => V('P45_S_CLPR_CODI_ALTE'),
                                        i_clpr_indi_clie_prov => 'P',--'C',
                                        I_tico_indi_vali_timb => V('P45_TICO_INDI_VALI_TIMB'),
                                        i_tico_indi_timb_auto => V('P45_TICO_INDI_TIMB_AUTO'),
                                        i_movi_nume_timb      => V('P45_MOVI_NUME_TIMB'),
                                        i_fech_venc_timb      => V('P45_S_FECH_VENC_TIMB'));
          end;

      if V('P45_S_CLPR_CODI_ALTE') is not null then
          if nvl(V('P45_TICO_INDI_VALI_TIMB'), 'N') = 'S' then
            if V('P45_MOVI_NUME_TIMB') is null then
               raise_application_error(-20010, 'Debe ingresar el nro de Timbrado!!!');
            end if;   
        end if;
      end if;

        if V('P45_S_CLPR_CODI_ALTE') is not null then
            if nvl(V('P45_TICO_INDI_VALI_TIMB'), 'N') = 'S' then
              if V('P45_S_FECH_VENC_TIMB') is null then
                 raise_application_error(-20010, 'Debe ingresar la fecha de Venc de Timbrado!!!');
               end if;  
            end if; 
            
            if V('P45_S_FECH_VENC_TIMB') is not null then
            
              if TO_DATE(V('P45_S_FECH_EMIS')) > TO_DATE(V('P45_S_FECH_VENC_TIMB')) then
                 raise_application_error(-20010, 'La fecha de vencimiento de timbrado no puede ser menor a la fecha de emision del documento!!');
              end if; 
              
            end if;
        end if;
     
  end if;
  
    if ii_movi_tipo_tran = 'D' then
      if ii_s_nume is null then
        raise_application_error(-20010, 'Debe ingresar el numero del Documento.!');
      end if;
    end if;
    --
    pp_consulta_nume_docu(i_fech_emis      => ii_fech_emis,
                          i_s_nume         => ii_s_nume,
                          i_movi_tipo_tran => ii_movi_tipo_tran);
  

  


   if ii_dest_cuen_codi is null then
      raise_application_error(-20010, 'La cuenta de destino no puede quedar vacia!');
   end if;


     if ii_orig_cuen_codi is null then
      raise_application_error(-20010, 'La cuenta de origen no puede quedar vacia!');
   end if;
   
  if ii_orig_impo_mone      is null then raise_application_Error(-20001, 'El importe origen no puede quedar vacio'); end if; 
  if ii_dest_impo_mone      is null then raise_application_Error(-20001, 'El importe destino puede quedar vacio'); end if; 
  if ii_dest_cuen_codi      is null then raise_application_Error(-20001, 'La cuenta destino no puede quedar vacio'); end if; 
  if ii_orig_cuen_codi      is null then raise_application_Error(-20001, 'La cuenta origen no puede quedar vacio'); end if; 
  if ii_orig_impo_mmnn      is null then raise_application_Error(-20001, 'El importe MMNN origen no puede quedar vacio'); end if; 
  if ii_dest_impo_mmnn      is null then raise_application_Error(-20001, 'El importe MMNN destino no puede quedar vacio'); end if; 
  if ii_orig_mone_codi      is null then raise_application_Error(-20001, 'La moneda origen no puede quedar vacio'); end if; 
  if ii_dest_mone_codi      is null then raise_application_Error(-20001, 'La noneda destino no puede quedar vacio'); end if; 
  if ii_orig_tasa_mone      is null then raise_application_Error(-20001, 'La tasa origen puede quedar vacio'); end if; 
  if ii_dest_tasa_mone      is null then raise_application_Error(-20001, 'La tasa destino puede quedar vacio'); end if; 

  
    if nvl(ii_dest_tasa_mone, 0) <= 0 then
      raise_application_error(-20010,
                              'La tasa destino debe ser mayor a cero....');
    end if;
  
    if nvl(ii_dest_cuen_codi, 0) = nvl(ii_orig_cuen_codi, 0) then
      raise_application_error(-20010,
                              'Las cajas origen y destino, no pueden ser iguales');
    end if;
  
  
  
  
  
        if ii_dest_mone_codi= to_number(fa_busc_para('p_codi_mone_mmnn')) and  nvl(ii_dest_tasa_mone,0) <> 1  then
      	
           raise_application_error(-20001, 'La tasa debe ser 1');
        end if;
      
     if ii_orig_mone_codi= to_number(fa_busc_para('p_codi_mone_mmnn')) and  nvl(ii_orig_tasa_mone,0) <> 1  then
      	
           raise_application_error(-20001, 'La tasa debe ser 1');
      end if;
  
    begin
      --   pp_validar_importes;
      I020013.pp_validar_importes(i_orig_impo_mmnn => ii_orig_impo_mmnn,
                                  i_dest_impo_mmnn => ii_dest_impo_mmnn,
                                  i_orig_impo_mone => ii_orig_impo_mone,
                                  i_dest_impo_mone => ii_dest_impo_mone,
                                  i_orig_mone_codi => ii_orig_mone_codi,
                                  i_dest_mone_codi => ii_dest_mone_codi,
                                  I_movi_form_pago => ii_movi_form_pago);
          exception
        when others then 
          raise_application_error(-20010, 'Error el moemnto de validar importes');
          
          end;
  
    begin
      I020013.pp_veri_secu(i_s_nro_4 => ii_s_nume, o_s_nro => v_nume_s);
    
    end;
  
    -- pp_actualizar_movi;
    begin
        
      I020013.pp_actualizar_movi(i_s_nume              => ii_s_nume,
                                 i_fech_emis           => ii_fech_emis,
                                 i_obse                => ii_obse,
                                 i_movi_form_pago      => ii_movi_form_pago,
                                 i_movi_tipo_tran      => ii_movi_tipo_tran,
                                 i_apci_codi           => ii_apci_codi,
                                 i_orig_mone_cant_deci => ii_orig_mone_cant_deci,
                                 i_dest_mone_cant_deci => ii_dest_mone_cant_deci,
                                 i_orig_cuen_codi      => ii_orig_cuen_codi,
                                 i_dest_cuen_codi      => ii_dest_cuen_codi,
                                 i_ORIG_MONE_CODI      => ii_ORIG_MONE_CODI,
                                 i_dest_mone_codi      => ii_dest_mone_codi,
                                 i_orig_tasa_mone      => ii_orig_tasa_mone,
                                 i_dest_tasa_mone      => ii_dest_tasa_mone,
                                 i_orig_impo_mmnn      => ii_orig_impo_mmnn,
                                 i_dest_impo_mmnn      => ii_dest_impo_mmnn,
                                 i_orig_impo_mone      => ii_orig_impo_mone,
                                 i_dest_impo_mone      => ii_dest_impo_mone);
  
     /*     exception
        when others then 
          raise_application_error(-20010, 'Error el moemnto de actualizar movi_gral');
 */   end;
  
    if ii_movi_tipo_tran = 'I' then
      i020013.pp_actu_secu;
    end if;
  
    if ii_movi_tipo_tran = 'C' then
      begin
        I020013.pp_actualizar_movi_fact(i_dest_cuen_codi => ii_dest_cuen_codi,
                                        i_movi_clpr_codi => ii_movi_clpr_codi,
                                        i_dest_mone_codi => ii_dest_mone_codi,
                                        i_s_nume         => ii_s_nume,
                                        i_fech_emis      => ii_fech_emis,
                                        i_dest_tasa_mone => ii_dest_tasa_mone,
                                        i_dest_impo_mmnn => ii_dest_impo_mmnn,
                                        i_dest_impo_mone => ii_dest_impo_mone,
                                        i_obse           => ii_obse,
                                        i_movi_nume_timb => ii_movi_nume_timb,
                                        i_fech_venc_timb => ii_fech_venc_timb);
      exception
        when others then 
          raise_application_error(-20010, 'Error el momento de actualizar movi_fact');
      end;

    end if;
  
  
  begin
  -- Call the procedure
  I020013.pp_generar_reporte(i_movi_codi => v_movi_codi);
  end;
   --  Raise_application_error(-20001, 'paso todo');
   delete from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
         and nvl(taax_c011,'x')<>'Reporte';
  end;

  procedure pp_actu_regi_cheq is
  
    cursor c_det_cheq is
      select taax_sess,
             taax_user,
             taax_c001 i_cheq_tach_codi,
             taax_c002 i_cheq_cuen_codi,
             taax_c003 i_cheq_cuen_desc,
             taax_c004 i_cheq_nume_cuen,
             taax_c005 i_cheq_impo_mone_movi,
             taax_c006 i_cheq_banc_codi,
             taax_c007 i_cheq_mone_codi,
             taax_c008 i_cheq_banc_desc,
             taax_c009 i_cheq_mone_desc,
             taax_c010 i_cheq_serie,
             taax_c011 i_cheq_mone_desc_abre,
             taax_c012 i_cheq_nume,
             taax_c013 i_cheq_mone_cant_deci,
             taax_c014 i_tach_tipo_cheq,
             taax_c015 i_cheq_fech_emis,
             taax_c016 i_cheq_fech_venc,
             to_number(taax_c017) i_cheq_tasa_mone,
             to_number(taax_c018) i_cheq_impo_mone,
             to_number(taax_c019) i_cheq_impo_mmnn,
             to_number(taax_c020) i_cheq_impo_mone_movi_orig,
             taax_seq
        from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
         and nvl(taax_c011,'x')<>'Reporte';
  begin
  
    for i in c_det_cheq loop
    
      begin
        I020013.pp_valida_nume_cheq(p_cheq_nume      => i.i_cheq_nume,
                                    p_cheq_serie     => i.i_cheq_serie,
                                    p_cheq_banc_codi => i.i_cheq_banc_codi);
      end;
    
    end loop;
  
  end;

  procedure pp_carga_secu(p_secu_tran_valo out number) is
  begin
  
    p_secu_tran_valo := nvl(to_number(fa_busc_para('p_secu_tran_valo')), 0) + 1;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Numero de Secuencia inexistente ....');
    
  end;

  procedure pp_vali_fech(i_fech_emis in date) is
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if i_fech_emis not between p_fech_inic and p_fech_fini then
    
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  end pp_vali_fech;

  procedure pp_consulta_nume_docu(i_s_nume_4       in number,
                                  i_fech_emis      in date,
                                  i_movi_tipo_tran in varchar2) is
    v_count number(20);
  begin
    select count(*)
      into v_count
      from come_movi c
     where c.movi_nume = i_s_nume_4
       and c.movi_timo_codi = 27
       and c.movi_fech_emis >= (i_fech_emis - 365);
  
    if i_movi_tipo_tran = 'D' then
      if v_count > 0 then
        raise_application_error(-20010,
                                'Atencion! El numero de Documento ingresado ya existe');
      end if;
    end if;
  
  end;

  procedure pp_muestra_clpr(p_ind_clpr          in char,
                            p_clpr_codi         in number,
                            p_clpr_desc         out char,
                            p_clpr_tele         out char,
                            p_clpr_dire         out char,
                            p_clpr_ruc          out char,
                            p_clpr_prov_retener out varchar2,
                            p_pais_codi         out number) is
  begin
    select clpr_desc,
           rtrim(ltrim(substr(clpr_tele, 1, 50))) Tele,
           rtrim(ltrim(substr(clpr_dire, 1, 100))) dire,
           rtrim(ltrim(substr(clpr_ruc, 1, 20))) Ruc,
           nvl(clpr_prov_retener, 'NO'),
           clpr_pais_codi
      into p_clpr_desc,
           p_clpr_tele,
           p_clpr_dire,
           p_clpr_ruc,
           p_clpr_prov_retener,
           p_pais_codi
      from come_clie_prov
     where clpr_codi = p_clpr_codi
       and clpr_indi_clie_prov = p_ind_clpr; -- decode(p_ind_clpr, 'R', 'P', 'E', 'C');
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      if p_ind_clpr = 'P' then
        raise_application_error(-20010, 'Proveedor inexistente!');
      else
        raise_application_error(-20010, 'Cliente inexistente!');
      end if;
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  procedure pp_mostrar_tipo_movi(p_movi_timo_codi      in number,
                                 o_tico_codi           out number,
                                 o_tico_indi_vali_timb out varchar2,
                                 o_tico_indi_timb_auto out varchar2,
                                 o_tico_indi_timb      out varchar2,
                                 o_tico_fech_rein      out date,
                                 o_tico_indi_habi_timb out varchar2) is
    v_timo_ingr_dbcr_vari char(1);
  begin
  
    select timo_tico_codi, /*timo_tica_codi, tico_indi_vali_nume,*/
           tico_indi_vali_timb, /*, tico_indi_habi_timb,*/
           tico_indi_timb_auto,
           tico_indi_timb,
           tico_fech_rein,
           tico_indi_habi_timb
      into o_tico_codi, --i_timo_tica_codi,  i_tico_indi_vali_nume ,
           o_tico_indi_vali_timb, /* i_tico_indi_habi_timb, */
           o_tico_indi_timb_auto,
           o_tico_indi_timb,
           o_tico_fech_rein,
           o_tico_indi_habi_timb
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = p_movi_timo_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Movimiento duplicado');
  end;

  procedure pp_validar_nro(i_movi_fech_emis      in date,
                           i_tico_fech_rein      in date,
                           i_clpr_indi_clie_prov in varchar2,
                           i_tico_codi           in number,
                           i_movi_clpr_codi      in number,
                           i_movi_nume           in number) is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
  
  begin
  
    if i_movi_fech_emis < i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and ((i_clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = i_movi_clpr_codi) or
             nvl(i_clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < i_tico_fech_rein;
    
    elsif i_movi_fech_emis > i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and ((i_clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = i_movi_clpr_codi) or
             nvl(i_clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= i_tico_fech_rein;
    
    end if;
  
    if v_count > 0 then
      raise_application_error(-20010, v_message);
    end if;
  
  exception
    when others then
      raise_application_error(-20010, 'Reigrese el nro de comprobante');
  end;

  procedure pp_validar_timbrado(p_tico_codi           in number,
                                p_esta                in number,
                                p_punt_expe           in number,
                                p_clpr_codi           in number,
                                p_fech_movi           in date,
                                p_timb                out varchar2,
                                p_fech_venc           out date,
                                p_tico_indi_timb      in varchar2,
                                i_s_clpr_codi_alte    in number,
                                i_clpr_indi_clie_prov in varchar2,
                                I_tico_indi_vali_timb in varchar2,
                                i_tico_indi_timb_auto in varchar2,
                                i_movi_nume_timb      in number,
                                i_fech_venc_timb      in date) is
  
    cursor c_timb is
      select cptc_nume_timb, cptc_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = p_clpr_codi --proveedor, cliente
         and cptc_tico_codi = p_tico_codi --tipo de comprobante
         and cptc_esta = p_esta --establecimiento 
         and cptc_punt_expe = p_punt_expe --punto de expedicion
         and cptc_fech_venc >= p_fech_movi
       order by cptc_fech_venc;
  
    cursor c_timb_2 is
      select deta_nume_timb, deta_fech_venc
        from come_tipo_comp_deta
       where deta_tico_codi = p_tico_codi --tipo de comprobante
         and deta_esta = p_esta --establecimiento 
         and deta_punt_expe = p_punt_expe --punto de expedicion
         and deta_fech_venc >= p_fech_movi
       order by deta_fech_venc;
  
    cursor c_timb_3 is
      select setc_nume_timb, setc_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := upper('n');
  
    v_indi_espo varchar2(1) := upper('n');
  begin
  
    if i_clpr_indi_clie_prov = upper('p') then
      if i_s_clpr_codi_alte = p_codi_prov_espo then
        v_indi_espo := upper('s');
      end if;
    else
      if i_s_clpr_codi_alte = p_codi_clie_espo then
        v_indi_espo := upper('s');
      end if;
    end if;
  
    if nvl(i_tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'P' then
      
        if i_clpr_indi_clie_prov = upper('p') and
           nvl(v_indi_espo, 'N') = 'N' then
        
          for x in c_timb loop
            v_indi_entro := upper('s');
          
            if i_movi_nume_timb is not null then
              p_timb      := i_movi_nume_timb;
              p_fech_venc := i_fech_venc_timb;
            else
              p_timb      := x.cptc_nume_timb;
              p_fech_venc := x.cptc_fech_venc;
            end if;
            exit;
          end loop;
        
        else
          v_indi_entro := upper('s');
        
        end if;
      
      elsif nvl(p_tico_indi_timb, 'C') = 'C' then
      
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := upper('s');
          if i_movi_nume_timb is not null then
            p_timb      := i_movi_nume_timb;
            p_fech_venc := i_fech_venc_timb;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
      
        for x in c_timb_3 loop
          v_indi_entro := upper('s');
          if i_movi_nume_timb is not null then
            p_timb      := i_movi_nume_timb;
            p_fech_venc := i_fech_venc_timb;
          else
            p_timb      := x.setc_nume_timb;
            p_fech_venc := x.setc_fech_venc;
          end if;
          exit;
        end loop;
      
      end if;
    end if;
  
    if I_s_clpr_codi_alte is not null and v_indi_entro = upper('n') and
       nvl(upper(I_tico_indi_vali_timb), 'N') = 'S' then
      raise_application_error(-20010,
                              'No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
    end if;
  
  end;

  procedure pp_devu_timb(p_tico_codi      in number,
                         p_esta           in number,
                         p_punt_expe      in number,
                         p_clpr_codi      in number,
                         p_fech_movi      in date,
                         p_tico_indi_timb in varchar2,
                         p_tim_mas        out varchar2) is
    v_nume_timb varchar2(20);
    v_fech_venc date;
  
  begin
    if nvl(p_tico_indi_timb, 'C') <> 'S' then
      select cptc_nume_timb, cptc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = p_clpr_codi --proveedor, cliente
         and cptc_tico_codi = p_tico_codi --tipo de comprobante
         and cptc_esta = p_esta --establecimiento 
         and cptc_punt_expe = p_punt_expe --punto de expedicion
         and cptc_fech_venc >= p_fech_movi
       order by cptc_fech_venc;
    else
      select setc_nume_timb, setc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select p.peco_secu_codi
                from come_pers_comp p
               where p.peco_codi = p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
    end if;
    p_tim_mas := 'N';       
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'El proveedor no tiene un timbrado vigente. Favor verificar.');
     when too_many_rows then
        p_tim_mas := 'S';                         
    when others then
      raise_application_error(-20010, 'Error al recuperar timbrado.');
  end;

  procedure pp_veri_aper_caja(p_indi_caja      in varchar2,
                              i_movi_tipo_tran in varchar2,
                              i_orig_cuen_codi in number,
                              i_orig_cuen_desc in varchar2,
                              i_dest_cuen_codi in number,
                              o_apci_codi      out number,
                              o_obse           out varchar2,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
    v_apci_codi number;
  
  begin
  
    if i_movi_tipo_tran = 'I' then
      if p_indi_caja = 'O' then
        begin
          select apci_codi
            into o_apci_codi
            from come_aper_cier_caja
           where apci_cuen_codi_post = i_orig_cuen_codi
             and apci_esta = 'A';
        
          if o_apci_codi is not null then
            o_obse      := 'Retiro de efectivo en ' || i_orig_cuen_desc;
            o_resp_codi := 4;
            o_resp_desc := 'Se realizara la extraccion de una caja abierta en el Post de Ventas!';
          end if;
        
        exception
          when no_data_found then
            o_apci_codi := null;
        end;
      
      else
      
        begin
          select apci_codi
            into v_apci_codi
            from come_aper_cier_caja
           where apci_cuen_codi_post = i_dest_cuen_codi
             and apci_esta = 'A';
        
          if v_apci_codi is not null then
            raise_application_error(-20010,
                                    'No puede realizar depositos en la caja, se encuentra abierta en el Post de Ventas!');
          end if;
        exception
          when no_data_found then
            null;
        end;
      end if;
    end if;
  end;

  procedure pp_mostrar_mone(p_mone_codi      in number,
                            p_mone_desc_abre out char,
                            p_mone_cant_deci out char) is
  begin
    select mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  
  exception
    when no_data_found then
      p_mone_desc_abre := null;
      p_mone_cant_deci := null;
      raise_application_error(-20010, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al momento de obtener moneada: ' ||
                              sqlerrm);
  end;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_fech_emis in date,
                               p_mone_coti out number,
                               p_tica_codi in number) is
  begin
    if p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_fech_emis
         and coti_tica_codi = p_tica_codi;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
    when too_many_rows then
      raise_application_error(-20010, 'Tasa Duplicada');
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar Tasa: ' ||
                              sqlerrm);
    
  end;

  procedure pp_muestra_tica(p_tica_codi out number) is
  begin
  
    select timo_tica_codi
      into p_tica_codi
      from come_tipo_movi
     where timo_codi = p_codi_timo_extr_banc;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_cargar_sald_ini(i_orig_cuen_codi in number,
                               i_fech_emis      in date,
                               i_ORIG_MONE_CODI in number,
                               o_s_sald_inic    out number) is
  
    v_sald_inic_mmnn number;
    v_sald_inic_mone number;
  
  begin
    select nvl(sald_inic_mmnn, 0), nvl(sald_inic_mone, 0)
      into v_sald_inic_mmnn, v_sald_inic_mone
      from come_cuen_banc_sald
     where sald_cuen_codi = i_ORIG_CUEN_CODI
       and sald_fech = i_fech_emis;
  
    if i_ORIG_MONE_CODI = 1 then
      o_s_sald_inic := v_sald_inic_mmnn;
    else
      o_s_sald_inic := v_sald_inic_mone;
    end if;
  
  exception
    when no_data_found then
      o_s_sald_inic := 0;
  end;

  procedure pp_cargar_sald_fini(i_orig_cuen_codi in number,
                                i_fech_emis      in date,
                                i_s_sald_inic    in number,
                                i_orig_mone_codi in number,
                                o_s_sald_fini    out number) is
    --debito  = (+)
    --credito = (-)    
  
    cursor c_movi is
      select decode(rtrim(ltrim(i.moim_dbcr)),
                    'C',
                    nvl(moim_impo_mone, 0),
                    0) Cred_mone,
             decode(rtrim(ltrim(i.moim_dbcr)),
                    'C',
                    nvl(moim_impo_mmnn, 0),
                    0) Cred_mmnn,
             decode(rtrim(ltrim(i.moim_dbcr)),
                    'D',
                    nvl(moim_impo_mone, 0),
                    0) debi_mone,
             decode(rtrim(ltrim(i.moim_dbcr)),
                    'D',
                    nvl(moim_impo_mmnn, 0),
                    0) debi_mmnn
        from come_movi m, come_movi_impo_deta i, come_tipo_movi t
      
       where m.movi_codi = i.moim_movi_codi
         and m.movi_timo_codi = t.timo_codi
         and i.moim_cuen_codi = i_orig_cuen_codi
         and i.moim_afec_caja = 'S'
            --and m.movi_cuen_codi is not null
         and i.moim_fech between i_fech_emis and i_fech_emis
       order by i.moim_fech,
                moim_movi_codi,
                timo_desc_abre,
                movi_nume,
                moim_tipo;
  
    v_sald_inic number := 0;
    v_sald_fini number := 0;
  
  begin
  
    v_sald_inic := i_s_sald_inic;
    if i_orig_mone_codi = 1 then
      --Si es en moneda local 
    
      for x in c_movi loop
        v_sald_fini := v_sald_fini + x.debi_mmnn - x.cred_mmnn;
      end loop;
    
    else
      --Si es en la moneda de la Cta. bancaria 
    
      for x in c_movi loop
        v_sald_fini := v_sald_fini + x.debi_mone - x.cred_mone;
      end loop;
    
    end if;
  
    o_s_sald_fini := v_sald_inic + v_sald_fini;
  
  end;

  procedure pp_mostrar_talo(p_tach_codi in number,
                            p_cheq_nume out number,
                            p_seri      out varchar2,
                            p_cuen_codi out number,
                            p_tipo_cheq out varchar2) is
  
    v_tach_esta varchar2(1);
  begin
  
    select tach_cuen_codi,
           (nvl(tach_ulti_nume, 0) + 1),
           tach_seri,
           tach_esta,
           nvl(tach_tipo_cheq, 'DIFE')
      into p_cuen_codi, p_cheq_nume, p_seri, v_tach_esta, p_tipo_cheq
      from come_talo_cheq
     where tach_codi = p_tach_codi;
  
    if v_tach_esta = 'I' then
      raise_application_error(-20010, 'El talonario se encuentra inactivo');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Talonario de cheque inexistente');
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar talo: ' ||
                              sqlcode);
  end;

  procedure pl_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_cuen_desc      out char,
                                      p_cuen_mone_codi out number,
                                      p_banc_codi      out number,
                                      p_banc_desc      out char,
                                      p_cuen_nume      out char) is
  begin
    select cuen_desc, cuen_mone_codi, banc_codi, banc_desc, cuen_nume
      into p_cuen_desc,
           p_cuen_mone_codi,
           p_banc_codi,
           p_banc_desc,
           p_cuen_nume
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi;
  
  exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      raise_application_error(-20010, 'Cuenta Bancaria Inexistente');
    when others then
      raise_application_error(-20010, 'Error al momento de cargar cuenta');
  end;

  procedure pl_muestra_come_mone(p_mone_codi      in number,
                                 p_mone_desc      out char,
                                 p_mone_desc_abre out char,
                                 p_mone_cant_deci out number) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  exception
    when no_data_found then
      p_mone_desc := null;
      raise_application_error(-20010, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar moneda: ' ||
                              sqlcode);
  end;

  procedure pp_valida_nume_cheq(p_cheq_nume      in char,
                                p_cheq_serie     in char,
                                p_cheq_banc_codi in number) is
    v_banc_desc varchar2(60);
  begin
    select banc_desc
      into v_banc_desc
      from come_cheq, come_banc
     where cheq_banc_codi = banc_codi
       and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
       and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
       and cheq_banc_codi = p_cheq_banc_codi;
  
    if p_indi_vali_repe_cheq = 'S' then
      raise_application_error(-20010,
                              'Atencion!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    else
      raise_application_error(-20010,
                              'Atencion!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    end if;
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if p_indi_vali_repe_cheq = 'S' then
        raise_application_error(-20010,
                                'Atencion!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      else
        raise_application_error(-20010,
                                'Atencion!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      end if;
    /*when others then
      raise_application_error(-20010,
                              'Error al momento de validar cheques: ' ||
                              sqlcode);
    */
  end;

  procedure pp_vali_fech_cheq(i_fech_emis      in date,
                              i_cheq_fech_emis in date) is
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if i_cheq_fech_emis < i_fech_emis then
      raise_application_error(-20010,
                              'La fecha de emision del cheque no puede ser menor a la fecha del documento');
    end if;
  
    if i_cheq_fech_emis > add_months(p_fech_fini, 6) then
      raise_application_error(-20010,
                              'La fecha de emision supera los 180 dias ' ||
                              to_char(add_months(p_fech_fini, 6),
                                      'dd-mm-yyyy'));
    end if;
  
    if i_cheq_fech_emis > add_months(p_fech_fini, 12) then
      raise_application_error(-20010,
                              'La fecha de emision no debe ser mayor a ' ||
                              to_char(add_months(p_fech_fini, 12),
                                      'dd-mm-yyyy'));
    end if;
  
  end pp_vali_fech_cheq;

  procedure pp_vali_fech_cheq_venc(i_cheq_fech_emis in date,
                                   i_cheq_fech_venc in date) is
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if p_emit_reci = 'E' then
    
      if i_cheq_fech_venc < i_cheq_fech_emis then
        raise_application_error(-20010,
                                'La fecha de vencimiento debe ser mayor o igual a la fecha de emision');
      end if;
    
      if i_cheq_fech_venc > add_months(p_fech_fini, 6) then
        raise_application_error(-20010,
                                'Atencion!!!!! La fecha de vencimiento es mayor a 180 dias ' ||
                                to_char(add_months(p_fech_fini, 6),
                                        'dd-mm-yyyy'));
      end if;
    
      if i_cheq_fech_venc > add_months(p_fech_fini, 12) then
        raise_application_error(-20010,
                                'La fecha de vencimiento no debe ser mayor a ' ||
                                to_char(add_months(p_fech_fini, 12),
                                        'dd-mm-yyyy'));
      end if;
    end if;
  
  end pp_vali_fech_cheq_venc;

  procedure pp_mane_cheq(i_cheq_tach_codi           in varchar2, --number,
                         i_cheq_cuen_codi           in varchar2, --number,
                         i_cheq_cuen_desc           in varchar2,
                         i_cheq_nume_cuen           in varchar2,
                         i_cheq_impo_mone_movi      in varchar2, --number,
                         i_cheq_banc_codi           in varchar2, --number,
                         i_cheq_mone_codi           in varchar2, --number,
                         i_cheq_banc_desc           in varchar2,
                         i_cheq_mone_desc           in varchar2,
                         i_cheq_serie               in varchar2,
                         i_cheq_mone_desc_abre      in varchar2,
                         i_cheq_nume                in varchar2,
                         i_cheq_mone_cant_deci      in varchar2, --number,
                         i_tach_tipo_cheq           in varchar2, --number,
                         i_cheq_fech_emis           in varchar2, --date,
                         i_cheq_fech_venc           in varchar2, --date,
                         i_cheq_tasa_mone           in varchar2, --number,
                         i_cheq_impo_mone           in varchar2, --number,
                         i_cheq_impo_mmnn           in varchar2, --number,
                         i_cheq_impo_mone_movi_orig in varchar2, --number,
                         i_cheq_indi                in varchar2,
                         i_seq                      in number) is
  
  begin
    
  
  
  
  
if i_cheq_tach_codi           is null then raise_application_error(-20001,'El talo no puede quedar vacio'); end if;
if i_cheq_cuen_codi           is null then raise_application_error(-20001,'La cuenta no puede quedar vacio'); end if;

if i_cheq_nume_cuen           is null then raise_application_error(-20010,'El numero de cuenta puede quedar vacio'); end if;
--if i_cheq_impo_mone_movi      is null then raise_application_error(-2000,'No puede quedar vacio'); end if
if i_cheq_banc_codi           is null then raise_application_error(-20001,'El banco no puede quedar vacio'); end if;
if i_cheq_mone_codi           is null then raise_application_error(-20001,'La moneda del cheque puede quedar vacio'); end if;
if i_cheq_serie               is null then raise_application_error(-20010,'La serie no puede quedar vacia'); end if;
if i_cheq_nume                is null then raise_application_error(-20010,'El numero de cheque no puede quedar vacio'); end if;
if i_tach_tipo_cheq           is null then raise_application_error(-20100,'El tipo de cheque no puede quedar vacio'); end if;
if i_cheq_fech_emis           is null then raise_application_error(-2000,'La fecha de emision no puede quedar vacio'); end if;
if i_cheq_fech_venc           is null then raise_application_error(-20010,'La fecha de vencimiento puede quedar vacio'); end if;
if i_cheq_tasa_mone           is null then raise_application_error(-20010,'La tasa no puede quedar vacia'); end if;
if nvl(i_cheq_impo_mone,0) <=0 then raise_application_error(-20010,'El importe no puede quedar vacio'); end if;
  
  
  if v('P45_CHEQ_CUEN_CODI') <> v('P45_ORIG_CUEN_CODI') then
       raise_application_error(-20010, 'El talonario no pertenece a la cuenta seleccinada');
      end if;
      
      IF v('P45_CHEQ_INDI') NOT IN ('U', 'D') THEN
IF v('P45_MOVI_FORM_PAGO') IN ('SC', 'CE') then	                    
	 if v('P45_CHEQ_NUME') is not null then
        begin
           I020013.PP_VALIDA_NUME_CHEQ(P_CHEQ_NUME      => v('P45_CHEQ_NUME'),
                                       P_CHEQ_SERIE     => v('P45_CHEQ_SERIE'),
                                       P_CHEQ_BANC_CODI => v('P45_CHEQ_BANC_CODI'));
        END;

   else
	   raise_application_error(-20010, 'Debe ingresar el Nro de Cheque');  
  end if;	        
end if;      

end if;

      I020013.PP_VALI_FECH_CHEQ(I_FECH_EMIS      =>  v('P45_S_FECH_EMIS'),
                                I_CHEQ_FECH_EMIS =>  v('P45_CHEQ_FECH_EMIS'));
                                
                                
  if nvl(v('P45_CHEQ_IMPO_MONE'),0) <= 0 then
		 raise_application_error(-20010, 'Debe ingresar el un valor mayor a cero para el importe del cheque') ;
end if;                               
    
    if i_cheq_indi = 'I' then
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_c012,
         taax_c013,
         taax_c014,
         taax_c015,
         taax_c016,
         taax_c017,
         taax_c018,
         taax_c019,
         taax_c020,
         taax_c030,
         taax_seq)
      values
        (v('APP_SESSION'),
         gen_user,
         i_cheq_tach_codi,
         i_cheq_cuen_codi,
         i_cheq_cuen_desc,
         i_cheq_nume_cuen,
         i_cheq_impo_mone_movi,
         i_cheq_banc_codi,
         i_cheq_mone_codi,
         i_cheq_banc_desc,
         i_cheq_mone_desc,
         i_cheq_serie,
         i_cheq_mone_desc_abre,
         i_cheq_nume,
         i_cheq_mone_cant_deci,
         i_tach_tipo_cheq,
         i_cheq_fech_emis,
         i_cheq_fech_venc,
         i_cheq_tasa_mone,
         i_cheq_impo_mone,
         i_cheq_impo_mmnn,
         i_cheq_impo_mone_movi_orig,
         v('P45_CHEQ_OBS'),
         seq_come_tabl_auxi.nextval);
    
    elsif i_cheq_indi = 'U' then
    
      update come_tabl_auxi
         set taax_c001 = i_cheq_tach_codi,
             taax_c002 = i_cheq_cuen_codi,
             taax_c003 = i_cheq_cuen_desc,
             taax_c004 = i_cheq_nume_cuen,
             taax_c005 = i_cheq_impo_mone_movi,
             taax_c006 = i_cheq_banc_codi,
             taax_c007 = i_cheq_mone_codi,
             taax_c008 = i_cheq_banc_desc,
             taax_c009 = i_cheq_mone_desc,
             taax_c010 = i_cheq_serie,
             taax_c011 = i_cheq_mone_desc_abre,
             taax_c012 = i_cheq_nume,
             taax_c013 = i_cheq_mone_cant_deci,
             taax_c014 = i_tach_tipo_cheq,
             taax_c015 = i_cheq_fech_emis,
             taax_c016 = i_cheq_fech_venc,
             taax_c017 = i_cheq_tasa_mone,
             taax_c018 = i_cheq_impo_mone,
             taax_c019 = i_cheq_impo_mmnn,
             taax_c020 = i_cheq_impo_mone_movi_orig,
             taax_C030 =   v('P45_CHEQ_OBS')
       where taax_seq = i_seq;
    
    elsif i_cheq_indi = 'D' then
    
      delete come_tabl_auxi where taax_seq = i_seq;
    
    end if;
  
  /*exception
    when others then
      raise_application_error(-20010,
                              'Error al momento de manjo cheque: ' ||
                              sqlcode);*/
  end pp_mane_cheq;

  procedure pp_consulta_nume_docu(i_fech_emis      in date,
                                  i_s_nume         in number,
                                  i_movi_tipo_tran in varchar2) is
    v_count number(20);
  begin
    select count(*)
      into v_count
      from come_movi c
     where c.movi_nume = i_s_nume
       and c.movi_timo_codi = 27
       and c.movi_fech_emis >= (i_fech_emis - 365);
  
    if i_movi_tipo_tran = 'D' then
      if v_count > 0 then
        raise_application_error(-20010,
                                'Atencion! El numero de Documento ingresado ya existe');
      end if;
    end if;
  
  end;

  procedure pp_validar_importes(i_orig_impo_mmnn in number,
                                i_dest_impo_mmnn in number,
                                i_orig_impo_mone in number,
                                i_dest_impo_mone in number,
                                i_orig_mone_codi in number,
                                i_dest_mone_codi in number,
                                i_movi_form_pago in varchar2) is
                                
  v_SUM_CHEQ_IMPO_MONE_MOVI_ORIG  number;
  v_SUM_CHEQ_IMPO_MMNN number;
  
  begin
  
  select 
        nvl(sum(taax_c018),0)        i_cheq_impo_mone,
        nvl(sum(taax_c019)   ,0)      i_cheq_impo_mmnn
  into v_SUM_CHEQ_IMPO_MONE_MOVI_ORIG, v_SUM_CHEQ_IMPO_MMNN
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = v('APP_USER')
     and nvl(taax_c011,'x')<>'Reporte';
  
    --  pl_mm(i_orig_impo_mmnn||' '||i_dest_impo_mmnn);
    if nvl(i_orig_impo_mmnn, 0) <> nvl(i_dest_impo_mmnn, 0) then
      raise_application_error(-20010,
                              'Los importes en moneda nacional de origen y destino deben ser iguales');
    end if;
  
    if i_orig_mone_codi = i_dest_mone_codi then
      if nvl(i_orig_impo_mone, 0) <> nvl(i_dest_impo_mone, 0) then
        raise_application_error(-20010,
                                'Los importes en moneda de origen y destino deben ser iguales');
      end if;
    end if;
    
    
  if I_movi_form_pago='SC' then
  	 
   if nvl(i_orig_impo_mone,0) <> nvl(v_SUM_CHEQ_IMPO_MONE_MOVI_ORIG,0) then
 			 raise_application_error(-20010,'El importe del cheque no corresponde al importe de la transferencia!!!');
   end if;	 
  
   if nvl(i_orig_impo_mmnn,0) <> nvl(v_SUM_CHEQ_IMPO_MMNN,0) then
  	  raise_application_error(-20010,'El importe del cheque no corresponde al importe de la transferencia!!!');
   end if;
  end if;
  
  end;

  procedure pp_muestra_tipo_movi_inser(p_timo_codi      in number,
                                       p_timo_afec_sald out char,
                                       p_timo_emit_reci out char,
                                       p_timo_dbcr      out char,
                                       p_tica_codi      out number) is
  begin
  
    select timo_afec_sald, timo_emit_reci, timo_dbcr, timo_tica_codi
      into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr, p_tica_codi
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_afec_sald := null;
      p_timo_emit_reci := null;
      p_timo_dbcr      := null;
      raise_application_error(-20010, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20010, 'Error al momento de mostrar TIMO');
  end;

  procedure pp_veri_secu(i_s_nro_4 in number, o_s_nro out number) is
    v_count number;
    v_nume  number;
  begin
  
    v_nume := i_s_nro_4;
  
    loop
      select count(*)
        into v_count
        from come_movi
       where movi_timo_codi = p_codi_timo_depo_banc
         and movi_nume = v_nume;
    
      if v_count > 0 then
        v_nume := v_nume + 1;
      else
        o_s_nro     := v_nume;
        p_tran_secu := v_nume;
        exit;
      end if;
    
    end loop;
  
  end;

  procedure pp_actualizar_movi(i_s_nume              in number,
                               i_fech_emis           in date,
                               i_obse                in varchar2,
                               i_movi_form_pago      in varchar2,
                               i_movi_tipo_tran      in varchar2,
                               i_apci_codi           in number,
                               i_orig_mone_cant_deci in number,
                               i_dest_mone_cant_deci in number,
                               i_orig_cuen_codi      in number,
                               i_dest_cuen_codi      in number,
                               i_orig_mone_codi      in number,
                               i_dest_mone_codi      in number,
                               i_orig_tasa_mone      in number,
                               i_dest_tasa_mone      in number,
                               i_orig_impo_mmnn      in number,
                               i_dest_impo_mmnn      in number,
                               i_orig_impo_mone      in number,
                               i_dest_impo_mone      in number) is
  
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    v_movi_grav_mmnn      number;
    v_movi_exen_mmnn      number;
    v_movi_iva_mmnn       number;
    v_movi_grav_mmee      number;
    v_movi_exen_mmee      number;
    v_movi_iva_mmee       number;
    v_movi_grav_mone      number;
    v_movi_exen_mone      number;
    v_movi_iva_mone       number;
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
    v_movi_obse           varchar2(80);
    v_tica_codi           number;
    v_movi_apci_codi      number;
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
  
    --variables para moimpo 
    v_moim_movi_codi number;
    v_moim_nume_item number := 0;
    v_moim_tipo      char(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      char(1);
    v_moim_afec_caja char(1);
    v_moim_fech      date;
    v_moim_fech_oper date;
    v_moim_impo_mone number;
    v_moim_impo_mmnn number;
    v_moim_cheq_codi number;
  
    cursor c_det_cheq is
      select taax_sess,
             taax_user,
             taax_c001 i_cheq_tach_codi,
             taax_c002 i_cheq_cuen_codi,
             taax_c003 i_cheq_cuen_desc,
             taax_c004 i_cheq_nume_cuen,
             taax_c005 i_cheq_impo_mone_movi,
             taax_c006 i_cheq_banc_codi,
             taax_c007 i_cheq_mone_codi,
             taax_c008 i_cheq_banc_desc,
             taax_c009 i_cheq_mone_desc,
             taax_c010 i_cheq_serie,
             taax_c011 i_cheq_mone_desc_abre,
             taax_c012 i_cheq_nume,
             taax_c013 i_cheq_mone_cant_deci,
             taax_c014 i_tach_tipo_cheq,
             taax_c015 i_cheq_fech_emis,
             taax_c016 i_cheq_fech_venc,
             to_number(taax_c017) i_cheq_tasa_mone,
             to_number(taax_c018) i_cheq_impo_mone,
             to_number(taax_c019) i_cheq_impo_mmnn,
             to_number(taax_c020) i_cheq_impo_mone_movi_orig,
             taax_c021 i_cheq_codi
        from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
           and nvl(taax_c011,'x')<>'Reporte';
  o_cheq_codi number;
  begin
   
    ---insertar el movimiento de entrada (destino)  (deposito)
    i020013.pp_muestra_tipo_movi_inser(to_number(p_codi_timo_depo_banc),
                                       v_movi_afec_sald,
                                       v_movi_emit_reci,
                                       v_movi_dbcr,
                                       v_tica_codi);
  
    v_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := p_codi_timo_depo_banc;
    v_movi_cuen_codi      := i_dest_cuen_codi;
    v_movi_clpr_codi      := null;
    v_movi_sucu_codi_orig := p_codi_sucu_defa;
    v_movi_mone_codi      := i_dest_mone_codi;
    v_movi_nume           := i_s_nume;
    v_movi_fech_emis      := i_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := i_dest_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := i_dest_impo_mmnn;
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := i_dest_impo_mone;
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := null;
    v_movi_empr_codi      := null;
    v_movi_obse           := i_obse;
    v_movi_apci_codi      := null;
    p_movi_codi_depo      := v_movi_codi;
  
    p_codi_padr := v_movi_codi;
 
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_cuen_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_obse,
                        v_movi_apci_codi);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := p_codi_conc_depo_mone;
    v_moco_dbcr      := 'D';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mone;
 
    i020013.pp_insert_movi_conc_deta(v_moco_movi_codi,
                                     v_moco_nume_item,
                                     v_moco_conc_codi,
                                     v_moco_cuco_codi,
                                     v_moco_impu_codi,
                                     v_moco_impo_mmnn,
                                     v_moco_impo_mmee,
                                     v_moco_impo_mone,
                                     v_moco_dbcr);
   
    --actualizar moimpu...
    i020013.pp_insert_come_movi_impu_deta(to_number(p_codi_impu_exen),
                                          v_movi_codi,
                                          v_movi_exen_mmnn,
                                          0,
                                          0,
                                          0,
                                          v_movi_exen_mone,
                                          0);
   
    --actualizar moimpo 
    if nvl(i_movi_form_pago, 'SE') = 'SE' then
      
      v_moim_movi_codi := v_movi_codi;
      v_moim_nume_item := 1;
      v_moim_tipo      := 'Efec. Deposito';
      v_moim_cuen_codi := v_movi_cuen_codi;
      v_moim_dbcr      := v_movi_dbcr;
      v_moim_afec_caja := 'S';
      v_moim_fech      := v_movi_fech_emis;
      v_moim_fech_oper := v_movi_fech_emis;
      v_moim_impo_mone := round(v_movi_exen_mone, i_dest_mone_cant_deci);
      v_moim_impo_mmnn := v_movi_exen_mmnn;
      v_moim_cheq_codi := v_moim_cheq_codi;
 
      i020013.pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                            v_moim_nume_item,
                                            v_moim_tipo,
                                            v_moim_cuen_codi,
                                            v_moim_dbcr,
                                            v_moim_afec_caja,
                                            v_moim_fech,
                                            v_moim_fech_oper,
                                            v_moim_impo_mone,
                                            v_moim_impo_mmnn,
                                            v_moim_cheq_codi);
    
    else

      for i in c_det_cheq loop
        v_moim_movi_codi := v_movi_codi;
        v_moim_nume_item := v_moim_nume_item + 1;
        v_moim_tipo      := 'Efec. Dep. Cheq.';
        v_moim_cuen_codi := v_movi_cuen_codi;
        v_moim_dbcr      := v_movi_dbcr;
        v_moim_afec_caja := 'S';
        v_moim_fech      := i.i_cheq_fech_venc;
        v_moim_fech_oper := i.i_cheq_fech_venc; --v_movi_fech_emis; A pedido de Jose Rolon
        v_moim_impo_mone := round(i.i_cheq_impo_mone_movi,
                                  i_dest_mone_cant_deci);
        v_moim_impo_mmnn := i.i_cheq_impo_mmnn;
        v_moim_cheq_codi := null;
        
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_fech_oper,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn,
                                      v_moim_cheq_codi);
       
      end loop;
    
    end if;
   
    v_moim_nume_item := 0;
    ---insertar el movimiento de salida (origen) (extraccion)
    pp_muestra_tipo_movi_inser(p_codi_timo_extr_banc,
                               v_movi_afec_sald,
                               v_movi_emit_reci,
                               v_movi_dbcr,
                               v_tica_codi);
  
    v_movi_codi_padr := v_movi_codi;
    v_movi_codi      := fa_sec_come_movi;
  
    v_movi_timo_codi      := to_number(p_codi_timo_extr_banc);
    v_movi_cuen_codi      := i_orig_cuen_codi;
    v_movi_clpr_codi      := null;
    v_movi_sucu_codi_orig := p_codi_sucu_defa;
    v_movi_mone_codi      := i_orig_mone_codi;
    v_movi_nume           := i_s_nume;
    v_movi_fech_emis      := i_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_tasa_mone      := i_orig_tasa_mone;
  
    --busca la tasa de la moneda extranjera para la fecha de la operacion
    pp_busca_tasa_mone(p_codi_mone_mmee,
                       i_fech_emis,
                       v_movi_tasa_mmee,
                       v_tica_codi);
    v_movi_grav_mmnn := 0;
    v_movi_exen_mmnn := i_orig_impo_mmnn;
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := round(i_orig_impo_mmnn / v_movi_tasa_mmee,
                              p_cant_deci_mmee);
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_exen_mone := i_orig_impo_mone;
    v_movi_iva_mone  := 0;
    v_movi_clpr_desc := null;
    v_movi_empr_codi := null;
    v_movi_obse      := i_obse;
  
    if i_movi_tipo_tran = 'I' then
      v_movi_apci_codi := i_apci_codi;
    else
      v_movi_apci_codi := null;
    end if;
 
    i020013.pp_insert_come_movi(v_movi_codi,
                                v_movi_timo_codi,
                                v_movi_cuen_codi,
                                v_movi_clpr_codi,
                                v_movi_sucu_codi_orig,
                                v_movi_mone_codi,
                                v_movi_nume,
                                v_movi_fech_emis,
                                v_movi_fech_grab,
                                v_movi_user,
                                v_movi_codi_padr,
                                v_movi_tasa_mone,
                                v_movi_tasa_mmee,
                                v_movi_grav_mmnn,
                                v_movi_exen_mmnn,
                                v_movi_iva_mmnn,
                                v_movi_grav_mmee,
                                v_movi_exen_mmee,
                                v_movi_iva_mmee,
                                v_movi_grav_mone,
                                v_movi_exen_mone,
                                v_movi_iva_mone,
                                v_movi_clpr_desc,
                                v_movi_emit_reci,
                                v_movi_afec_sald,
                                v_movi_dbcr,
                                v_movi_empr_codi,
                                v_movi_obse,
                                v_movi_apci_codi);
  
    pp_actualiza_cheque_emit (i_movi_form_pago,
                              i_orig_tasa_mone,
                              o_cheq_codi);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := p_codi_conc_extr_mone;
    v_moco_dbcr      := 'C';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mone;
   
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
    --actualizar moim...
    
   
    pp_insert_come_movi_impu_deta(to_number(p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0);
   
    if nvl(i_movi_form_pago, 'SE') = 'SE' then
    
      --actualizar moimpo 
      v_moim_movi_codi := v_movi_codi;
      v_moim_nume_item := 1;
      v_moim_tipo      := 'Efec. Extrac.';
      v_moim_cuen_codi := v_movi_cuen_codi;
      v_moim_dbcr      := v_movi_dbcr;
      v_moim_afec_caja := 'S';
      v_moim_fech      := v_movi_fech_emis;
      v_moim_fech_oper := v_movi_fech_emis;
      v_moim_impo_mone := round(v_movi_exen_mone, i_orig_mone_cant_deci);
      v_moim_impo_mmnn := round(v_movi_exen_mmnn);
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_fech_oper,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_cheq_codi);
    
    else
  
      for i in c_det_cheq loop
        v_moim_movi_codi := v_movi_codi;
        v_moim_nume_item := v_moim_nume_item + 1;
        v_moim_tipo      := 'Cheq. Extrac.';
        v_moim_cuen_codi := i.i_cheq_cuen_codi;
        v_moim_dbcr      := v_movi_dbcr;
        v_moim_afec_caja := 'S';
        v_moim_fech      := i.i_cheq_fech_venc;
        v_moim_fech_oper := i.i_cheq_fech_venc; --v_movi_fech_emis; A pedido de Jose Rolon
        v_moim_impo_mone := round(i.i_cheq_impo_mone_movi_orig,
                                  i_orig_mone_cant_deci);
        v_moim_impo_mmnn := i.i_cheq_impo_mmnn;
        v_moim_cheq_codi := i.i_cheq_codi;
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_fech_oper,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn,
                                      v_moim_cheq_codi);
      
       
      end loop;
    
    end if;
    
 /* exception
    when others then
      raise_application_error(-20010,
                              'Error el momento de actualizar movimiento');*/
    
  end;

  procedure pp_insert_come_movi(p_movi_codi           in number,
                                p_movi_timo_codi      in number,
                                p_movi_cuen_codi      in number,
                                p_movi_clpr_codi      in number,
                                p_movi_sucu_codi_orig in number,
                                p_movi_mone_codi      in number,
                                p_movi_nume           in number,
                                p_movi_fech_emis      in date,
                                p_movi_fech_grab      in date,
                                p_movi_user           in char,
                                p_movi_codi_padr      in number,
                                p_movi_tasa_mone      in number,
                                p_movi_tasa_mmee      in number,
                                p_movi_grav_mmnn      in number,
                                p_movi_exen_mmnn      in number,
                                p_movi_iva_mmnn       in number,
                                p_movi_grav_mmee      in number,
                                p_movi_exen_mmee      in number,
                                p_movi_iva_mmee       in number,
                                p_movi_grav_mone      in number,
                                p_movi_exen_mone      in number,
                                p_movi_iva_mone       in number,
                                p_movi_clpr_desc      in char,
                                p_movi_emit_reci      in char,
                                p_movi_afec_sald      in char,
                                p_movi_dbcr           in char,
                                p_movi_empr_codi      in number,
                                p_movi_obse           in varchar2,
                                p_movi_apci_codi      in number) is
  begin
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_cuen_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_codi_padr,
       movi_tasa_mone,
       movi_tasa_mmee,
       movi_grav_mmnn,
       movi_exen_mmnn,
       movi_iva_mmnn,
       movi_grav_mmee,
       movi_exen_mmee,
       movi_iva_mmee,
       movi_grav_mone,
       movi_exen_mone,
       movi_iva_mone,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_base,
       movi_obse,
       movi_apci_codi)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_cuen_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_fech_emis,
       p_movi_fech_grab,
       p_movi_user,
       p_movi_codi_padr,
       p_movi_tasa_mone,
       p_movi_tasa_mmee,
       p_movi_grav_mmnn,
       p_movi_exen_mmnn,
       p_movi_iva_mmnn,
       p_movi_grav_mmee,
       p_movi_exen_mmee,
       p_movi_iva_mmee,
       p_movi_grav_mone,
       p_movi_exen_mone,
       p_movi_iva_mone,
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       p_codi_base,
       p_movi_obse,
       p_movi_apci_codi);
  
  end;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi number,
                                     p_moco_nume_item number,
                                     p_moco_conc_codi number,
                                     p_moco_cuco_codi number,
                                     p_moco_impu_codi number,
                                     p_moco_impo_mmnn number,
                                     p_moco_impo_mmee number,
                                     p_moco_impo_mone number,
                                     p_moco_dbcr      char) is
  
  begin
    insert into come_movi_conc_deta
      (moco_movi_codi,
       moco_nume_item,
       moco_conc_codi,
       moco_cuco_codi,
       moco_impu_codi,
       moco_impo_mmnn,
       moco_impo_mmee,
       moco_impo_mone,
       moco_dbcr,
       moco_base)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr,
       p_codi_base);
  
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
                                          p_moim_movi_codi in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_impo_mmee in number,
                                          p_moim_impu_mmnn in number,
                                          p_moim_impu_mmee in number,
                                          p_moim_impo_mone in number,
                                          p_moim_impu_mone in number) is
  begin
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_base)
    values
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_codi_base);
  
  end;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                          p_moim_nume_item in number,
                                          p_moim_tipo      in char,
                                          p_moim_cuen_codi in number,
                                          p_moim_dbcr      in char,
                                          p_moim_afec_caja in char,
                                          p_moim_fech      in date,
                                          p_moim_fech_oper in date,
                                          p_moim_impo_mone in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_cheq_codi in number) is
  begin
    
  
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_fech_oper,
       moim_impo_mone,
       moim_impo_mmnn,
       moim_cheq_codi,
       moim_base)
    values
      (p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_fech_oper,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       p_moim_cheq_codi,
       p_codi_base);
       
    exception when others then
       raise_application_error(-20010,p_moim_movi_codi||'-'||
       p_moim_nume_item||'*'||
       p_moim_tipo||'-'||
       p_moim_cuen_codi||'*+'||
       p_moim_dbcr||'-'||
       p_moim_afec_caja||'*'||
       p_moim_fech||'-'||
       p_moim_fech_oper||'-'||
       p_moim_impo_mone||'-'||
       p_moim_impo_mmnn||'-'||
       p_moim_cheq_codi||'-'||
       p_codi_base);    
   
  end;

  ---Acualiza los cheques emitidos, en caso q sea un pago a un proveedor, y se utilizo una
  ---cuenta  bancaria externa, y c selecciona forma de pago (cheques.....)
  procedure pp_actualiza_cheque_emit(i_movi_form_pago in varchar2,
                                     i_orig_tasa_mone in number,
                                     o_cheq_codi out number) is
    -- variables para come_cheq
    v_cheq_codi           number;
    v_cheq_mone_codi      number;
    v_cheq_banc_codi      number;
    v_cheq_nume           number;
    v_cheq_serie          varchar2(3);
    v_cheq_nume_cuen      varchar2(20);
    v_cheq_fech_emis      date;
    v_cheq_fech_venc      date;
    v_cheq_impo_mone      number;
    v_cheq_impo_mmnn      number;
    v_cheq_tipo           varchar2(1);
    v_cheq_clpr_codi      number;
    v_cheq_esta           varchar2(1);
    v_cheq_fech_grab      date;
    v_cheq_user           varchar2(10);
    v_cheq_cuen_codi      number;
    v_cheq_indi_ingr_manu varchar2(1) := 'N';
    v_cheq_orde           varchar2(60);
    v_cheq_tasa_mone      number;
    v_cheq_tach_codi      number;
    v_tach_tipo_cheq      varchar2(10);
  
    --variables para movimiento cheque
    v_chmo_movi_codi number;
    v_chmo_cheq_codi number;
    v_chmo_esta_ante char(1);
    v_chmo_cheq_secu number;
  
    cursor c_det_cheq is
      select taax_sess,
             taax_user,
             taax_c001 i_cheq_tach_codi,
             taax_c002 i_cheq_cuen_codi,
             taax_c003 i_cheq_cuen_desc,
             taax_c004 i_cheq_nume_cuen,
             taax_c005 i_cheq_impo_mone_movi,
             taax_c006 i_cheq_banc_codi,
             taax_c007 i_cheq_mone_codi,
             taax_c008 i_cheq_banc_desc,
             taax_c009 i_cheq_mone_desc,
             taax_c010 i_cheq_serie,
             taax_c011 i_cheq_mone_desc_abre,
             taax_c012 i_cheq_nume,
             taax_c013 i_cheq_mone_cant_deci,
             taax_c014 i_tach_tipo_cheq,
             taax_c015 i_cheq_fech_emis,
             taax_c016 i_cheq_fech_venc,
             to_number(taax_c017) i_cheq_tasa_mone,
             to_number(taax_c018) i_cheq_impo_mone,
             to_number(taax_c019) i_cheq_impo_mmnn,
             to_number(taax_c020) i_cheq_impo_mone_movi_orig,
             taax_c021 i_cheq_codi,
             taax_c022 i_cheq_orde,
             taax_c023 i_tach_ulti_nume,
             taax_C030 orde,
             taax_seq seq
        from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
           and nvl(taax_c011,'x')<>'Reporte';
  v_obs varchar2(1000);
  begin
  
    --Validar q el total de cheques coincida con el total del pago....
    --solo si la cuenta origen es un banco...
    --solo si se selecciono forma de pago cheques.....
  
    if p_emit_reci = 'E' then
      if i_movi_form_pago in ('SC') then
        -- variables para come_cheq
        v_cheq_tipo := 'E'; --emitido       
        --v_cheq_clpr_codi          := i_movi_clpr_codi;
        v_cheq_esta      := 'I'; --ingresado        
        v_cheq_user      := substr(gen_user, 1, 10);
        v_cheq_fech_grab := sysdate;
      
        --variables para movimiento cheque        
        v_chmo_movi_codi := v_movi_codi;
      
        for i in c_det_cheq loop
          -- variables para come_cheq
          v_cheq_orde      := substr(i.orde, 1, 60);
          v_cheq_mone_codi := i.i_cheq_mone_codi;
          v_cheq_nume_cuen := i.i_cheq_nume_cuen;
          v_cheq_cuen_codi := i.i_cheq_cuen_codi;
          v_cheq_banc_codi := i.i_cheq_banc_codi;
          v_cheq_codi      := fa_sec_come_cheq;
          i.i_cheq_codi    := v_cheq_codi;
          v_cheq_nume      := i.i_cheq_nume;
          v_cheq_serie     := i.i_cheq_serie;
          v_cheq_fech_emis := i.i_cheq_fech_emis;
          v_cheq_fech_venc := i.i_cheq_fech_venc;
          v_cheq_impo_mone := i.i_cheq_impo_mone;
          v_cheq_impo_mmnn := round((i.i_cheq_impo_mone * i_orig_tasa_mone),
                                    p_cant_deci_mmnn);
          v_cheq_tasa_mone := i.i_cheq_tasa_mone;
          v_cheq_tach_codi := i.i_cheq_tach_codi;
          v_tach_tipo_cheq := i.i_tach_tipo_cheq;
        
          --variables para movimiento cheque
          v_chmo_cheq_codi := v_cheq_codi;
          v_chmo_esta_ante := null; --pq no tiene estado anterior..., o sea es el primier mov. dl chque
          v_chmo_cheq_secu := 1; --tendra la secuencia 1 pq es el movimiento q dio origen al cheque...
          --v_obs :=  i.obs;
          
          o_cheq_codi := v_cheq_codi;
          pp_insert_come_cheq(v_cheq_codi,
                              v_cheq_mone_codi,
                              v_cheq_banc_codi,
                              v_cheq_nume,
                              v_cheq_serie,
                              v_cheq_fech_emis,
                              v_cheq_fech_venc,
                              v_cheq_impo_mone,
                              v_cheq_impo_mmnn,
                              v_cheq_tipo,
                              v_cheq_clpr_codi,
                              v_cheq_esta,
                              v_cheq_nume_cuen,
                              v_cheq_user,
                              v_cheq_fech_grab,
                              v_cheq_cuen_codi,
                              v_cheq_indi_ingr_manu,
                              v_cheq_orde,
                              v_cheq_tasa_mone,
                              v_cheq_tach_codi,
                              v_tach_tipo_cheq);
        
          pp_insert_come_movi_cheq(v_chmo_movi_codi,
                                   v_chmo_cheq_codi,
                                   v_chmo_esta_ante,
                                   v_chmo_cheq_secu);
        
         -- if i.i_tach_ulti_nume = i.i_cheq_nume then
            pp_actualiza_come_talo_cheq(v_cheq_tach_codi,
                                        v_cheq_nume,
                                        v_tach_tipo_cheq);
         -- end if;
        
        
        
       update come_tabl_auxi a
         set taax_c021 =v_cheq_codi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
           and nvl(taax_c011,'x')<>'Reporte'
           and taax_seq = i.seq;
        end loop;
      end if;
    end if;
  
  end;

  procedure pp_insert_come_cheq(p_cheq_codi           number,
                                p_cheq_mone_codi      number,
                                p_cheq_banc_codi      number,
                                p_cheq_nume           number,
                                p_cheq_serie          varchar2,
                                p_cheq_fech_emis      date,
                                p_cheq_fech_venc      date,
                                p_cheq_impo_mone      number,
                                p_cheq_impo_mmnn      number,
                                p_cheq_tipo           varchar2,
                                p_cheq_clpr_codi      number,
                                p_cheq_esta           varchar2,
                                p_cheq_nume_cuen      varchar2,
                                p_cheq_user           varchar2,
                                p_cheq_fech_grab      date,
                                p_cheq_cuen_codi      number,
                                p_cheq_indi_ingr_manu varchar2,
                                p_cheq_orde           varchar2,
                                p_cheq_tasa_mone      number,
                                p_cheq_tach_codi      number,
                                p_tach_tipo_cheq      varchar2) is
  
  begin
    insert into come_cheq
      (cheq_codi,
       cheq_mone_codi,
       cheq_banc_codi,
       cheq_nume,
       cheq_serie,
       cheq_fech_emis,
       cheq_fech_venc,
       cheq_impo_mone,
       cheq_impo_mmnn,
       cheq_tipo,
       cheq_clpr_codi,
       cheq_esta,
       cheq_nume_cuen,
       cheq_user,
       cheq_fech_grab,
       cheq_cuen_codi,
       cheq_indi_ingr_manu,
       cheq_orde,
       cheq_tasa_mone,
       cheq_tach_codi,
       cheq_base,
       cheq_indi_dia_dife)
    values
      (p_cheq_codi,
       p_cheq_mone_codi,
       p_cheq_banc_codi,
       p_cheq_nume,
       p_cheq_serie,
       p_cheq_fech_emis,
       p_cheq_fech_venc,
       p_cheq_impo_mone,
       p_cheq_impo_mmnn,
       p_cheq_tipo,
       p_cheq_clpr_codi,
       p_cheq_esta,
       p_cheq_nume_cuen,
       p_cheq_user,
       p_cheq_fech_grab,
       p_cheq_cuen_codi,
       p_cheq_indi_ingr_manu,
       p_cheq_orde,
       p_cheq_tasa_mone,
       p_cheq_tach_codi,
       p_codi_base,
       p_tach_tipo_cheq);
  
  end;

  procedure pp_insert_come_movi_cheq(p_chmo_movi_codi in number,
                                     p_chmo_cheq_codi in number,
                                     p_chmo_esta_ante in char,
                                     p_chmo_cheq_secu in number) is
  
  begin
    insert into come_movi_cheq
      (chmo_movi_codi,
       chmo_cheq_codi,
       chmo_esta_ante,
       chmo_cheq_secu,
       chmo_base)
    values
      (p_chmo_movi_codi,
       p_chmo_cheq_codi,
       p_chmo_esta_ante,
       p_chmo_cheq_secu,
       p_codi_base);
  
  end;

  procedure pp_actualiza_come_talo_cheq(p_tach_codi      in number,
                                        p_tach_ulti_nume in number,
                                        p_tach_tipo_cheq in varchar2) is
  begin
    update come_talo_cheq
       set tach_ulti_nume = p_tach_ulti_nume,
           tach_tipo_cheq = p_tach_tipo_cheq
     where tach_codi = p_tach_codi;
  end;

  procedure pp_actu_secu is
  begin
    update come_para
       set para_valo = p_tran_secu
     where ltrim(rtrim(upper(para_nomb))) = upper('p_secu_tran_valo');
  
  end;

  procedure pp_actualizar_movi_fact(i_dest_cuen_codi   in number,
                                    i_movi_clpr_codi   in number,
                                    i_dest_mone_codi   in number,
                                    i_s_nume           in number,
                                    i_fech_emis        in date,
                                    i_dest_tasa_mone   in number,
                                    i_dest_impo_mmnn   in number,
                                    i_dest_impo_mone   in number,
                                    i_obse             in varchar2,
                                    i_movi_nume_timb   in varchar2,
                                    i_fech_venc_timb   in date) is
                                    
  
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    v_movi_grav_mmnn      number;
    v_movi_exen_mmnn      number;
    v_movi_iva_mmnn       number;
    v_movi_grav_mmee      number;
    v_movi_exen_mmee      number;
    v_movi_iva_mmee       number;
    v_movi_grav_mone      number;
    v_movi_exen_mone      number;
    v_movi_iva_mone       number;
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
    v_movi_obse           varchar2(80);
    v_tica_codi           number;
    v_movi_clpr_dire      varchar2(100);
    v_movi_clpr_tele      varchar2(50);
    v_movi_clpr_ruc       varchar2(20);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
    v_movi_excl_cont      varchar2(1);
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
  
    --variables para moimpo 
    v_moim_movi_codi number;
    v_moim_nume_item number := 0;
    v_moim_tipo      char(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      char(1);
    v_moim_afec_caja char(1);
    v_moim_fech      date;
    v_moim_fech_oper date;
    v_moim_impo_mone number;
    v_moim_impo_mmnn number;
    v_moim_cheq_codi number;
  
    --variables para moimpu
    
    
  i_movi_clpr_desc varchar2(500); 
  i_movi_clpr_dire varchar2(5000); 
  i_movi_clpr_tele varchar2(500);  
  i_movi_clpr_ruc   varchar2(500); 
  
  
  
  begin
  
  
  select clpr_desc, clpr_dire, clpr_tele, clpr_ruc 
    into i_movi_clpr_desc, i_movi_clpr_dire, i_movi_clpr_tele, i_movi_clpr_ruc 
    from come_clie_prov where clpr_codi =  i_movi_clpr_codi;
  
    ---insertar el movimiento de entrada (destino)  (deposito)
    i020013.pp_muestra_tipo_movi_inser(to_number(p_codi_timo_fcor),
                                       v_movi_afec_sald,
                                       v_movi_emit_reci,
                                       v_movi_dbcr,
                                       v_tica_codi);
  
    v_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := p_codi_timo_fcor;
    v_movi_cuen_codi      := i_dest_cuen_codi;
    v_movi_clpr_codi      := i_movi_clpr_codi; --null;
    v_movi_sucu_codi_orig := p_codi_sucu_defa;
    v_movi_mone_codi      := i_dest_mone_codi;
    v_movi_nume           := i_s_nume;
    v_movi_fech_emis      := i_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := p_codi_padr; --null;
    v_movi_tasa_mone      := i_dest_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := i_dest_impo_mmnn;
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := i_dest_impo_mone;
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := i_movi_clpr_desc; --null;                    
    v_movi_empr_codi      := null;
    v_movi_obse           := i_obse;
    p_movi_codi_depo      := v_movi_codi;
    v_movi_clpr_dire      := i_movi_clpr_dire;
    v_movi_clpr_tele      := i_movi_clpr_tele;
    v_movi_clpr_ruc       := i_movi_clpr_ruc;
    v_movi_nume_timb      := i_movi_nume_timb;
    v_movi_fech_venc_timb := i_fech_venc_timb;
    v_movi_excl_cont      := 'S';
  
    i020013.pp_insert_come_movi_fact(v_movi_codi,
                                     v_movi_timo_codi,
                                     v_movi_cuen_codi,
                                     v_movi_clpr_codi,
                                     v_movi_sucu_codi_orig,
                                     v_movi_mone_codi,
                                     v_movi_nume,
                                     v_movi_fech_emis,
                                     v_movi_fech_grab,
                                     v_movi_user,
                                     v_movi_codi_padr,
                                     v_movi_tasa_mone,
                                     v_movi_tasa_mmee,
                                     v_movi_grav_mmnn,
                                     v_movi_exen_mmnn,
                                     v_movi_iva_mmnn,
                                     v_movi_grav_mmee,
                                     v_movi_exen_mmee,
                                     v_movi_iva_mmee,
                                     v_movi_grav_mone,
                                     v_movi_exen_mone,
                                     v_movi_iva_mone,
                                     v_movi_clpr_desc,
                                     v_movi_emit_reci,
                                     v_movi_afec_sald,
                                     v_movi_dbcr,
                                     v_movi_empr_codi,
                                     v_movi_obse,
                                     v_movi_clpr_dire,
                                     v_movi_clpr_tele,
                                     v_movi_clpr_ruc,
                                     v_movi_nume_timb,
                                     v_movi_fech_venc_timb,
                                     v_movi_excl_cont);
  
    ----actualizar moco.... 
  
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := p_codi_conc_depo_mone;
    v_moco_dbcr      := 'D';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mone;
  
    i020013.pp_insert_movi_conc_deta(v_moco_movi_codi,
                                     v_moco_nume_item,
                                     v_moco_conc_codi,
                                     v_moco_cuco_codi,
                                     v_moco_impu_codi,
                                     v_moco_impo_mmnn,
                                     v_moco_impo_mmee,
                                     v_moco_impo_mone,
                                     v_moco_dbcr);
  
    --actualizar moimpu...
    i020013.pp_insert_come_movi_impu_deta(to_number(p_codi_impu_exen),
                                          v_movi_codi,
                                          v_movi_exen_mmnn,
                                          0,
                                          0,
                                          0,
                                          v_movi_exen_mone,
                                          0);
  
  end;

  procedure pp_insert_come_movi_fact(p_movi_codi           in number,
                                     p_movi_timo_codi      in number,
                                     p_movi_cuen_codi      in number,
                                     p_movi_clpr_codi      in number,
                                     p_movi_sucu_codi_orig in number,
                                     p_movi_mone_codi      in number,
                                     p_movi_nume           in number,
                                     p_movi_fech_emis      in date,
                                     p_movi_fech_grab      in date,
                                     p_movi_user           in char,
                                     p_movi_codi_padr      in number,
                                     p_movi_tasa_mone      in number,
                                     p_movi_tasa_mmee      in number,
                                     p_movi_grav_mmnn      in number,
                                     p_movi_exen_mmnn      in number,
                                     p_movi_iva_mmnn       in number,
                                     p_movi_grav_mmee      in number,
                                     p_movi_exen_mmee      in number,
                                     p_movi_iva_mmee       in number,
                                     p_movi_grav_mone      in number,
                                     p_movi_exen_mone      in number,
                                     p_movi_iva_mone       in number,
                                     p_movi_clpr_desc      in char,
                                     p_movi_emit_reci      in char,
                                     p_movi_afec_sald      in char,
                                     p_movi_dbcr           in char,
                                     p_movi_empr_codi      in number,
                                     p_movi_obse           in varchar2,
                                     p_movi_clpr_dire      in varchar2,
                                     p_movi_clpr_tele      in varchar2,
                                     p_movi_clpr_ruc       in varchar2,
                                     p_movi_nume_timb      in varchar2,
                                     p_movi_fech_venc_timb in date,
                                     p_movi_excl_cont      in varchar2) is
  begin
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_cuen_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_codi_padr,
       movi_tasa_mone,
       movi_tasa_mmee,
       movi_grav_mmnn,
       movi_exen_mmnn,
       movi_iva_mmnn,
       movi_grav_mmee,
       movi_exen_mmee,
       movi_iva_mmee,
       movi_grav_mone,
       movi_exen_mone,
       movi_iva_mone,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_base,
       movi_obse,
       movi_clpr_dire,
       movi_clpr_tele,
       movi_clpr_ruc,
       movi_nume_timb,
       movi_fech_venc_timb,
       movi_excl_cont)
    
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_cuen_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_fech_emis,
       p_movi_fech_grab,
       p_movi_user,
       p_movi_codi_padr,
       p_movi_tasa_mone,
       p_movi_tasa_mmee,
       p_movi_grav_mmnn,
       p_movi_exen_mmnn,
       p_movi_iva_mmnn,
       p_movi_grav_mmee,
       p_movi_exen_mmee,
       p_movi_iva_mmee,
       p_movi_grav_mone,
       p_movi_exen_mone,
       p_movi_iva_mone,
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       p_codi_base,
       p_movi_obse,
       p_movi_clpr_dire,
       p_movi_clpr_tele,
       p_movi_clpr_ruc,
       p_movi_nume_timb,
       p_movi_fech_venc_timb,
       p_movi_excl_cont);
  
  end;
  
  
/**************** REPORTE *************************/
procedure pp_generar_reporte(i_movi_codi in number) is
  v_where       varchar2(1000) := ' ';
  v_where_adel  varchar2(1000) := ' ';
  salir         exception;
  
    v_sql       varchar2(20000);
    v_cant_regi number := 0;
    v_para      varchar2(500);
    v_cont      varchar2(500);
    v_repo      varchar2(500);
      
begin

   
v_where      := ' and m.movi_codi =  '||i_movi_codi;


  
v_sql := '
insert into come_tabl_auxi (taax_sess ,
                            taax_user ,
                            taax_seq  ,
                            taax_c001 ,
                            taax_c002 ,
                            taax_c003 ,
                            taax_c004 ,
                            taax_c005 ,
                            taax_c006 ,
                            taax_c007 ,
                            taax_c008 ,
                            taax_c009 ,
                            taax_c010,
                            taax_c011 )
select '''||v('APP_SESSION')||''',
       gen_user,
       seq_come_tabl_auxi.nextval,
       movi_fech_emis,
       movi_nume,
       movi_mone_codi,
       mone_desc_abre,
       movi_tasa_mone,
       movi_exen_mone,
       movi_obse,
       importe_letras,
       movi_timo_codi,
       movi_codi,
       ''Reporte''
  from (select
       m.movi_fech_emis,
       m.movi_nume,
       m.movi_mone_codi,
       mo.mone_desc_abre,
       m.movi_tasa_mone,
       m.movi_exen_mone,
       m.movi_obse,
       upper(''('' || ''son'' || '' '' || mo.mone_desc_abre || '' '' ||
             pack_nume_to_text.fa_conv_nume_text(m.movi_exen_mone) || '')'') importe_letras,
       m.movi_timo_codi,
       m.movi_codi
  from come_movi m, come_mone mo
 where m.movi_mone_codi = mo.mone_codi '||v_where||'
 order by m.movi_codi)';
  
insert into come_concat (otro, campo1) values ('che kaneo lentoma', v_sql);
commit; 
 execute immediate v_sql;
 
  v_cont := 'p_app_session:p_app_user';
  v_para := v('APP_SESSION') || ':' || gen_user;
  v_repo := 'I020013';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;
   
exception
  when salir then 
    null;
end;

function fp_carga_caja_dest(p_timo_codi in number, p_movi_codi in number)
  return varchar2 is

  v_desc_dest varchar2(200);
  cursor c_cuen is
    select (dd.moim_cuen_codi || '   ' || cd.cuen_desc || ' ' || ' ' || ' ' ||
           'Moneda: ' || md.mone_desc_abre) cuen_desc
      from come_movi           e,
           come_movi           d,
           come_movi_impo_deta ed,
           come_movi_impo_deta dd,
           come_cuen_banc      co,
           come_cuen_banc      cd,
           come_mone           mo,
           come_mone           md
    
     where e.movi_codi_padr = d.movi_codi
       and ed.moim_movi_codi = e.movi_codi
       and dd.moim_movi_codi = d.movi_codi
       and ed.moim_cuen_codi = co.cuen_codi
       and dd.moim_cuen_codi = cd.cuen_codi
       and e.movi_mone_codi = mo.mone_codi
       and d.movi_mone_codi = md.mone_codi
          
       and e.movi_timo_codi = 28
       and d.movi_timo_codi = 27
       and decode(p_timo_codi, 28, e.movi_codi, d.movi_codi) = p_movi_codi
     order by 1;

begin

  for x in c_cuen loop
    v_desc_dest := x.cuen_desc;
    exit;
  end loop;

  return v_desc_dest;

exception
  when no_data_found then
    return ' ';
end;

function fp_carga_caja_orig(p_timo_codi in number, p_movi_codi in number)
  return varchar2 is

  v_desc_orig varchar2(200);
  cursor c_cuen is
    select (ed.moim_cuen_codi || '   ' || co.cuen_desc || ' ' || ' ' || ' ' ||
           'Moneda: ' || mo.mone_desc_abre) cuen_desc
      from come_movi           e,
           come_movi           d,
           come_movi_impo_deta ed,
           come_movi_impo_deta dd,
           come_cuen_banc      co,
           come_cuen_banc      cd,
           come_mone           mo,
           come_mone           md
    
     where e.movi_codi_padr = d.movi_codi
       and ed.moim_movi_codi = e.movi_codi
       and dd.moim_movi_codi = d.movi_codi
       and ed.moim_cuen_codi = co.cuen_codi
       and dd.moim_cuen_codi = cd.cuen_codi
       and e.movi_mone_codi = mo.mone_codi
       and d.movi_mone_codi = md.mone_codi
          
       and e.movi_timo_codi = 28
       and d.movi_timo_codi = 27
       and decode(p_timo_codi, 28, e.movi_codi, d.movi_codi) = p_movi_codi
     order by 1;

begin

  for x in c_cuen loop
    v_desc_orig := x.cuen_desc;
    exit;
  end loop;

  return v_desc_orig;

exception
  when no_data_found then
    return ' ';
end;


end I020013;
