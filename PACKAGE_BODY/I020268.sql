
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020268" is

 procedure pl_fp_actualiza_cobr_vent(p_movi_codi in number,
                                    p_movi_afec_sald in varchar2,
                                    p_movi_clpr_codi in number,
                                    p_movi_clpr_desc in varchar2,
                                    p_movi_clpr_ruc in varchar2,
                                    p_movi_dbcr in varchar2,
                                    p_movi_emit_reci in varchar2,
                                    p_movi_empr_codi in varchar2,
                                    p_movi_fech_emis in date,
                                    p_movi_fech_oper in date,
                                    p_movi_sucu_codi_orig in number,
                                    p_movi_mone_cant_deci in number,
                                    p_movi_tasa_mone in number,
                                    p_movi_timo_codi in number  ) is

  ---v_movi_codi       number;
  salir             exception;
  v_tot pack_fpago.t_fptot;


  --v_impo_cheq number;
begin
  /*if :bfp.sum_s_impo_mmnn > 0 then
    if fl_confirmar_reg ('Desea Registrar el Pago?') <> 'CONFIRMAR'  then
      raise salir;
    end if;*/
    
    
  v_tot := pack_fpago.fp_calc_ingreso_egreso;



    
     if nvl(v_tot.s_sum_impo_mmnn,0 )  = 0 then
        pl_me('No existe ningun pago favor verificar.');
     end if;
    -- v_tot.s_sum_impo_movi
    
    if v_tot.s_sum_impo_mmnn  <> v('P24_MOVI_IMPO_MONE') then
      pl_me('Existe una diferencia en montos. Saldo distinto a 0(cero). ');
    end if;
    
   --raise_application_error(-20001,'pruebaaa. '||v_tot.s_sum_impo_mmnn);
    
    if p_movi_afec_sald = 'N' then
    --  pl_fp_actualiza_moimpo;
      
       pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi       =>p_movi_clpr_codi,
                                        i_movi_clpr_desc       => p_movi_clpr_desc,
                                        i_movi_clpr_ruc        => p_movi_clpr_ruc,
                                        i_movi_codi            => p_movi_codi,
                                        i_movi_dbcr            => p_movi_dbcr,
                                        i_movi_emit_reci       => p_movi_emit_reci,
                                        i_movi_empr_codi       => p_movi_empr_codi,
                                        i_movi_fech_emis       => p_movi_fech_emis,
                                        i_movi_fech_oper       => p_movi_fech_oper,
                                        i_movi_mone_cant_deci  => p_movi_mone_cant_deci,
                                        i_movi_sucu_codi_orig  => p_movi_sucu_codi_orig,
                                        i_movi_tasa_mone       => p_movi_tasa_mone,
                                        i_movi_timo_codi       => p_movi_timo_codi,
                                        i_s_impo_rete          => null,
                                        i_s_impo_rete_rent     => null);
    end if;
  
    pl_fp_actualiza_cuotcanc(p_movi_codi);
  
    begin
      update come_movi m
         set m.movi_indi_cobr_dife = 'C'
       where m.movi_codi = p_movi_codi;
    exception
      when others then
        pl_me(sqlerrm);
    end;
  
  
  
   -- parameter.p_cobr_vent_sucu_codi      := name_in('bsel.sucu_codi');
   ---parameter.p_cobr_vent_sucu_codi_alte := name_in('bsel.sucu_codi_alte');
  --- parameter.p_cobr_vent_sucu_desc      := name_in('bsel.sucu_desc');
   
    /*if not form_success then
      clear_form(no_validate, full_rollback);
      message('Registro no actualizado.'); bell;
    else        
      go_block('bsel');
      Message('Registro actualizado.'); bell;
      clear_form(no_validate);
    end if;*/
  
  
   -- parameter.p_cobr_vent_cobr_fp := 'S';
    --hide_window('win_fp');
    --go_block('bpie');
 /* else
    null;
 
   -- parameter.p_cobr_vent_cobr_fp := 'S';
    
    --parameter.p_cobr_vent_sucu_codi      := name_in('bsel.sucu_codi');
    --parameter.p_cobr_vent_sucu_codi_alte := name_in('bsel.sucu_codi_alte');
    --parameter.p_cobr_vent_sucu_desc      := name_in('bsel.sucu_desc');
  end if;*/
  
  
exception
  when salir then
    null;
   -- parameter.p_cobr_vent_cobr_fp := 'S';
  
   -- parameter.p_cobr_vent_sucu_codi      := v('bsel.sucu_codi');
   -- parameter.p_cobr_vent_sucu_codi_alte := v('bsel.sucu_codi_alte');
  ---  parameter.p_cobr_vent_sucu_desc      := v('bsel.sucu_desc');


end pl_fp_actualiza_cobr_vent;
 


procedure pl_fp_actualiza_cuotcanc(p_movi_codi in number) is
  cursor c_canc is
    select canc_movi_codi,
           canc_cuot_movi_codi,
           canc_cuot_fech_venc,
           canc_fech_pago,
           canc_base,
           canc_impo_mone,
           canc_impo_mmee,
           canc_impo_mmnn,
           canc_impo_dife_camb,
           canc_asie_codi,
           canc_indi_afec_sald,
           canc_impu_mone,
           canc_impu_mmnn,
           canc_cuot_codi,
           canc_impu_codi,
           canc_desc,
           canc_impo_rete_mone,
           canc_impo_rete_mmnn,
           canc_indi_refi_tran
      from roga_cuot_canc
     where canc_movi_codi = p_movi_codi
     order by canc_cuot_movi_codi, canc_cuot_fech_venc;

  v_canc_movi_codi      number(20);
  v_canc_cuot_movi_codi number(20);
  v_canc_cuot_fech_venc date;
  v_canc_fech_pago      date;
  v_canc_base           number(2);
  v_canc_impo_mone      number(20, 4);
  v_canc_impo_mmee      number(20, 4);
  v_canc_impo_mmnn      number(20, 4);
  v_canc_impo_dife_camb number(20, 4);
  v_canc_asie_codi      number(20);
  v_canc_indi_afec_sald varchar2(1);
  v_canc_impu_mone      number(20, 4);
  v_canc_impu_mmnn      number(20, 4);
  v_canc_cuot_codi      number(20);
  v_canc_impu_codi      number(10);
  v_canc_desc           varchar2(60);
  v_canc_impo_rete_mone number(20, 4);
  v_canc_impo_rete_mmnn number(20, 4);
  v_canc_indi_refi_tran varchar2(1);

begin
  for k in c_canc loop
    v_canc_movi_codi      := k.canc_movi_codi;
    v_canc_cuot_movi_codi := k.canc_cuot_movi_codi;
    v_canc_cuot_fech_venc := k.canc_cuot_fech_venc;
    v_canc_fech_pago      := k.canc_fech_pago;
    v_canc_base           := k.canc_base;
    v_canc_impo_mone      := k.canc_impo_mone;
    v_canc_impo_mmee      := k.canc_impo_mmee;
    v_canc_impo_mmnn      := k.canc_impo_mmnn;
    v_canc_impo_dife_camb := k.canc_impo_dife_camb;
    v_canc_asie_codi      := k.canc_asie_codi;
    v_canc_indi_afec_sald := k.canc_indi_afec_sald;
    v_canc_impu_mone      := k.canc_impu_mone;
    v_canc_impu_mmnn      := k.canc_impu_mmnn;
    v_canc_cuot_codi      := k.canc_cuot_codi;
    v_canc_impu_codi      := k.canc_impu_codi;
    v_canc_desc           := k.canc_desc;
    v_canc_impo_rete_mone := k.canc_impo_rete_mone;
    v_canc_impo_rete_mmnn := k.canc_impo_rete_mmnn;
    v_canc_indi_refi_tran := k.canc_indi_refi_tran;
  
    begin
      insert into come_movi_cuot_canc
        (canc_movi_codi,
         canc_cuot_movi_codi,
         canc_cuot_fech_venc,
         canc_fech_pago,
         canc_base,
         canc_impo_mone,
         canc_impo_mmee,
         canc_impo_mmnn,
         canc_impo_dife_camb,
         canc_asie_codi,
         canc_indi_afec_sald,
         canc_impu_mone,
         canc_impu_mmnn,
         canc_cuot_codi,
         canc_impu_codi,
         canc_desc,
         canc_impo_rete_mone,
         canc_impo_rete_mmnn,
         canc_indi_refi_tran)
      values
        (v_canc_movi_codi,
         v_canc_cuot_movi_codi,
         v_canc_cuot_fech_venc,
         v_canc_fech_pago,
         v_canc_base,
         v_canc_impo_mone,
         v_canc_impo_mmee,
         v_canc_impo_mmnn,
         v_canc_impo_dife_camb,
         v_canc_asie_codi,
         v_canc_indi_afec_sald,
         v_canc_impu_mone,
         v_canc_impu_mmnn,
         v_canc_cuot_codi,
         v_canc_impu_codi,
         v_canc_desc,
         v_canc_impo_rete_mone,
         v_canc_impo_rete_mmnn,
         v_canc_indi_refi_tran);
    exception
      when others then
        pl_me(sqlerrm);
    end;
  end loop;

  begin
    delete roga_cuot_canc where canc_movi_codi = p_movi_codi;
  exception
    when others then
      pl_me(sqlerrm);
  end;

end pl_fp_actualiza_cuotcanc;



 procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;




end I020268;
